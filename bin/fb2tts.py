#!/usr/bin/env python3
"""FB2 -> mp3 по главам через edge-tts.

    ./fb2tts.py book1.fb2 --list
    ./fb2tts.py book1.fb2 -o ~/Audiobooks/Книга -v ru-RU-SvetlanaNeural
"""

import argparse
import re
import threading
from concurrent.futures import ThreadPoolExecutor
import shutil
import subprocess
import sys
import unicodedata
import xml.etree.ElementTree as ET
from pathlib import Path

NS = {"f": "http://www.gribuser.ru/xml/fictionbook/2.0"}
BLOCK = {"p", "v", "subtitle", "text-author"}  # элементы, дающие отдельный абзац


def tag(el) -> str:
    return el.tag.rsplit("}", 1)[-1]


def flat(el) -> str:
    return re.sub(r"\s+", " ", "".join(el.itertext())).strip()


def title_of(sec) -> str:
    t = sec.find("f:title", NS)
    return flat(t) if t is not None else ""


def body_text(sec, say_title: str | None) -> str:
    """Текст секции абзацами, без вложенных секций и без служебных сносок."""
    out = []
    if say_title:
        out.append(say_title.rstrip(".") + ".")
    for child in sec:
        if tag(child) in {"title", "section"}:
            continue
        for el in child.iter() if tag(child) not in BLOCK else [child]:
            if tag(el) in BLOCK:
                txt = flat(el)
                if txt:
                    out.append(txt)
    return "\n\n".join(out)


def leaves(sec, trail: list[str]) -> list[tuple[str, str, ET.Element]]:
    """Секции без подсекций — это и есть главы. Возвращает (путь, заголовок, узел)."""
    own = title_of(sec)
    kids = sec.findall("f:section", NS)
    if not kids:
        return [(" / ".join(trail + [own]).strip(" /"), own, sec)]
    found = []
    for k in kids:
        found += leaves(k, trail + [own] if own else trail)
    return found


def slug(s: str, limit: int = 70) -> str:
    s = unicodedata.normalize("NFC", s)
    s = re.sub(r"[^\w\s-]", "", s, flags=re.UNICODE)
    return (re.sub(r"\s+", "_", s.strip()) or "chapter")[:limit]


def synth(txt: Path, mp3: Path, args) -> bool:
    cmd = [
        "edge-tts", "-f", str(txt), "-v", args.voice,
        f"--rate={args.rate}", f"--volume={args.volume}", f"--pitch={args.pitch}",
        "--write-media", str(mp3),
    ]
    if args.subtitles:
        cmd += ["--write-subtitles", str(mp3.with_suffix(".vtt"))]
    for attempt in range(1, args.retries + 1):
        proc = subprocess.run(cmd, capture_output=True)
        if proc.returncode == 0 and mp3.exists() and mp3.stat().st_size > 2048:
            return True
        mp3.unlink(missing_ok=True)
        print(f"    попытка {attempt}/{args.retries}: "
              f"{proc.stderr.decode('utf-8', 'replace').strip()[:200]}", file=sys.stderr, flush=True)
    return False


def main() -> int:
    p = argparse.ArgumentParser(description="FB2 -> mp3 по главам через edge-tts")
    p.add_argument("fb2", type=Path)
    p.add_argument("-o", "--outdir", type=Path)
    p.add_argument("-v", "--voice", default="ru-RU-SvetlanaNeural")
    p.add_argument("--rate", default="+0%")
    p.add_argument("--volume", default="+0%")
    p.add_argument("--pitch", default="+0Hz")
    p.add_argument("--no-say-title", action="store_true", help="не проговаривать заголовок главы")
    p.add_argument("--only", help="номера глав: 1,5,10-20")
    p.add_argument("--min-chars", type=int, default=0, help="пропускать главы короче")
    p.add_argument("--subtitles", action="store_true")
    p.add_argument("--retries", type=int, default=4)
    p.add_argument("-j", "--jobs", type=int, default=4, help="сколько глав озвучивать параллельно")
    p.add_argument("--force", action="store_true", help="перегенерировать уже готовые mp3")
    p.add_argument("--list", action="store_true")
    p.add_argument("--text-only", action="store_true")
    args = p.parse_args()

    for flag, val in (("--rate", args.rate), ("--volume", args.volume)):
        if not re.fullmatch(r"[+-]\d+%", val):
            print(f"{flag} должен быть со знаком, например +10%  (получено: {val})", file=sys.stderr)
            return 1
    if not args.list and not args.text_only and not shutil.which("edge-tts"):
        print("нет edge-tts в PATH", file=sys.stderr)
        return 1

    root = ET.parse(args.fb2).getroot()
    book = root.find(".//f:book-title", NS)
    book = flat(book) if book is not None else args.fb2.stem

    chapters = []
    for body in root.findall("f:body", NS):
        if body.get("name") == "notes":  # сноски отдельным телом не озвучиваем
            continue
        for sec in body.findall("f:section", NS):
            chapters += leaves(sec, [])

    picked = None
    if args.only:
        picked = set()
        for part in args.only.split(","):
            a, _, b = part.strip().partition("-")
            picked.update(range(int(a), int(b or a) + 1))

    outdir = args.outdir or Path.home() / "Audiobooks" / slug(book)
    if not args.list:
        outdir.mkdir(parents=True, exist_ok=True)

    width = max(2, len(str(len(chapters))))
    print(f"{book} — глав: {len(chapters)}")
    if not args.list:
        print(f"каталог: {outdir}")
    print()

    total, tasks = 0, []
    for i, (path, head, sec) in enumerate(chapters, 1):
        text = body_text(sec, None if args.no_say_title else (head or None))
        total += len(text)
        mark = ""
        if picked and i not in picked:
            mark = " [пропуск: --only]"
        elif len(text) < args.min_chars:
            mark = " [пропуск: короткая]"
        print(f"[{i:0{width}d}] {path or head}  ({len(text)} симв., ~{len(text)/900:.0f} мин){mark}",
              flush=True)
        if args.list or mark:
            continue

        base = outdir / f"{i:0{width}d}_{slug(head or path)}"
        base.with_suffix(".txt").write_text(text + "\n", encoding="utf-8")
        if not args.text_only:
            tasks.append((i, head or path, base))

    failed, done = [], 0
    if tasks:
        lock = threading.Lock()
        print(f"\nозвучиваю {len(tasks)} глав в {args.jobs} потока(ов)\n", flush=True)

        def work(task):
            nonlocal done
            i, name, base = task
            mp3 = base.with_suffix(".mp3")
            if mp3.exists() and mp3.stat().st_size > 2048 and not args.force:
                with lock:
                    done += 1
                    print(f"  [{i:0{width}d}] {name}: уже есть", flush=True)
                return
            ok = synth(base.with_suffix(".txt"), mp3, args)
            with lock:
                if ok:
                    done += 1
                    print(f"  [{i:0{width}d}] {name}: готово, "
                          f"{mp3.stat().st_size/1_048_576:.1f} МБ  ({done}/{len(tasks)})", flush=True)
                else:
                    failed.append(i)
                    print(f"  [{i:0{width}d}] {name}: НЕ ОЗВУЧЕНО", file=sys.stderr, flush=True)

        with ThreadPoolExecutor(max_workers=args.jobs) as pool:
            list(pool.map(work, tasks))

    print(f"\nвсего текста: {total} симв., ~{total/900/60:.1f} ч звучания")
    if not args.list and not args.text_only:
        print(f"озвучено глав: {done}/{len(tasks)}")
        if failed:
            print(f"не удались: {','.join(map(str, failed))} — "
                  f"повтори с --only {','.join(map(str, failed))}")
    return 0 if not failed else 2


if __name__ == "__main__":
    raise SystemExit(main())
