require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]h", function()
      if vim.wo.diff then return "]h" end
      vim.schedule(function() gs.next_hunk() end)
      return "<Ignore>"
    end, { expr = true })

    map("n", "[h", function()
      if vim.wo.diff then return "[h" end
      vim.schedule(function() gs.prev_hunk() end)
      return "<Ignore>"
    end, { expr = true })

    map("n", "<leader>hi", gs.preview_hunk_inline)
    map("n", "<leader>hp", gs.preview_hunk)

    -- 	-- Actions
    -- map("n", "<leader>hs", gs.stage_hunk)
    map("n", "<leader>hr", gs.reset_hunk)
    map("n", "<leader>hu", gs.undo_stage_hunk)
    -- map("n", "<leader>hp", gs.preview_hunk)
  end,
})

-- Diffview
vim.opt.fillchars:append("diff:╱")

require("diffview").setup({
  enhanced_diff_hl = true,
  default_args = { "--imply-local" },
  view = {
    merge_tool = {
      layout = "diff3_mixed",
    },
  },
})

-- Автодополнение `:DiffviewOpen` в upstream собирает кандидатов через
-- `unpack(...)` — на репах с >~8000 git-ссылок (теги + ветки) LuaJIT падает с
-- "too many results to unpack" (init.lua:213). Форк dlyongemallo/diffview.nvim
-- это починил через расширение списка; здесь тот же компл., но на list_extend.
do
  local dv = require("diffview")
  dv.completers.DiffviewOpen = function(ctx)
    local has_rev_arg = false
    local adapter = dv.get_adapter()

    for i = 2, math.min(#ctx.args, ctx.divideridx) do
      if ctx.args[i]:sub(1, 1) ~= "-" and i ~= ctx.argidx then
        has_rev_arg = true
        break
      end
    end

    local candidates = {}

    if ctx.argidx > ctx.divideridx then
      if adapter then
        vim.list_extend(candidates, adapter:path_candidates(ctx.arg_lead))
      else
        vim.list_extend(candidates, vim.fn.getcompletion(ctx.arg_lead, "file", 0))
      end
    elseif adapter then
      if not has_rev_arg and ctx.arg_lead:sub(1, 1) ~= "-" then
        vim.list_extend(candidates, adapter.comp.open:get_all_names())
        vim.list_extend(candidates, adapter:rev_candidates(ctx.arg_lead, { accept_range = true }))
      else
        vim.list_extend(
          candidates,
          adapter.comp.open:get_completion(ctx.arg_lead) or adapter.comp.open:get_all_names()
        )
      end
    end

    return candidates
  end
end

vim.keymap.set("n", "<leader>gdd", ":DiffviewOpen<cr>")
vim.keymap.set("n", "<leader>gdm", ":DiffviewOpen master..HEAD %<cr>")

require("neogit").setup({
  treesitter_diff_highlight = true,
  word_diff_highlight = true,
})

require("gitblame").setup({
  enabled = false,
})

vim.keymap.set("n", "<leader>gb", ":GitBlameToggle<cr>", { desc = "Toggle git blame" })

-- Каталог текущего файла (или cwd), чтобы git-команды работали из нужного репозитория.
local function git_dir()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" then dir = vim.fn.getcwd() end
  return dir
end

local function ref_exists(dir, ref)
  vim.fn.system({ "git", "-C", dir, "rev-parse", "--verify", "--quiet", ref })
  return vim.v.shell_error == 0
end

-- Базовая ветка репозитория: master, иначе main. nil, если нет ни одной.
local function find_base_branch(dir)
  for _, branch in ipairs({ "master", "main" }) do
    if ref_exists(dir, branch) then return branch end
  end
  return nil
end

-- Открывает diff против базовой ветки, пробуя master, затем main.
-- Если ни одной нет — сообщает через vim.notify.
local function diff_base_branch()
  local dir = git_dir()
  local base = find_base_branch(dir)
  if not base then
    vim.notify("Diffview: не найдено ни master, ни main", vim.log.levels.ERROR)
    return
  end
  vim.cmd("DiffviewOpen " .. base .. "...HEAD --imply-local")
end

-- Фетчит базовую ветку и реф MR (refs/merge-requests/<iid>/head) в origin/mr/<iid>.
-- Реф MR указывается явно, fetch-спека в репозитории не нужна. Возвращает true при успехе.
local function fetch_merge_request(dir, base, iid)
  vim.notify("git fetch origin " .. base .. " !" .. iid .. "…", vim.log.levels.INFO)
  local out = vim.fn.system({
    "git",
    "-C",
    dir,
    "fetch",
    "origin",
    base,
    "+refs/merge-requests/" .. iid .. "/head:refs/remotes/origin/mr/" .. iid,
  })
  if vim.v.shell_error ~= 0 then
    vim.notify(
      "Diffview: не удалось получить MR !" .. iid .. ":\n" .. vim.trim(out),
      vim.log.levels.ERROR
    )
    return false
  end
  return true
end

local function rev_parse(dir, ref)
  local sha = vim.trim(vim.fn.system({ "git", "-C", dir, "rev-parse", "--verify", "--quiet", ref }))
  if vim.v.shell_error ~= 0 then return nil end
  return sha
end

-- Отметка «просмотрено до этого коммита» — локальный реф, переживает force-push автора.
local function reviewed_ref(iid) return "refs/reviewed/mr/" .. iid end

-- Последний открытый MR и SHA его головы на момент открытия — его и отмечает dvr.
local last_mr = nil

local function remember_mr(dir, iid)
  local sha = rev_parse(dir, "origin/mr/" .. iid)
  if sha then last_mr = { dir = dir, iid = iid, sha = sha } end
end

-- Спрашивает номер MR (по умолчанию — последний открытый) и передаёт его в callback.
local function ask_mr(callback)
  vim.ui.input(
    { prompt = "MR номер: ", default = last_mr and last_mr.iid or nil },
    function(iid)
      if not iid or iid == "" then return end
      callback((vim.trim(iid):gsub("^!", "")))
    end
  )
end

-- Открывает diff Merge Request по номеру без checkout: origin/<base>...origin/mr/<iid>.
local function diff_merge_request()
  ask_mr(function(iid)
    local dir = git_dir()
    local base = find_base_branch(dir)
    if not base then
      vim.notify("Diffview: не найдено ни master, ни main", vim.log.levels.ERROR)
      return
    end
    if not fetch_merge_request(dir, base, iid) then return end

    remember_mr(dir, iid)
    local reviewed = rev_parse(dir, reviewed_ref(iid))
    if reviewed and reviewed ~= last_mr.sha then
      vim.notify("MR !" .. iid .. ": есть изменения с прошлого просмотра — dvn", vim.log.levels.INFO)
    end

    vim.cmd("DiffviewOpen origin/" .. base .. "...origin/mr/" .. iid .. " --imply-local")
  end)
end

-- Отмечает последний открытый MR просмотренным: та голова MR, что была показана в dvm/dvn.
local function mark_merge_request_reviewed()
  if not last_mr then
    vim.notify("Сначала открой MR через dvm или dvn", vim.log.levels.WARN)
    return
  end
  vim.fn.system({ "git", "-C", last_mr.dir, "update-ref", reviewed_ref(last_mr.iid), last_mr.sha })
  if vim.v.shell_error ~= 0 then
    vim.notify("Не удалось записать " .. reviewed_ref(last_mr.iid), vim.log.levels.ERROR)
    return
  end
  vim.notify("MR !" .. last_mr.iid .. " просмотрен до " .. last_mr.sha:sub(1, 8))
end

-- Открывает изменения MR с последней отметки dvr: refs/reviewed/mr/<iid>..origin/mr/<iid>.
-- Если автор сделал rebase/force-push, предлагает range-diff (сравнение самих патчей),
-- потому что обычный diff потянет изменения из базовой ветки.
local function diff_merge_request_since_reviewed()
  ask_mr(function(iid)
    local dir = git_dir()
    local base = find_base_branch(dir)
    if not base then
      vim.notify("Diffview: не найдено ни master, ни main", vim.log.levels.ERROR)
      return
    end

    local old = rev_parse(dir, reviewed_ref(iid))
    if not old then
      vim.notify(
        "MR !" .. iid .. " ещё не отмечен просмотренным — открой через dvm и нажми dvr",
        vim.log.levels.WARN
      )
      return
    end
    if not fetch_merge_request(dir, base, iid) then return end

    remember_mr(dir, iid)
    local new = last_mr.sha
    if old == new then
      vim.notify("MR !" .. iid .. ": новых изменений нет")
      return
    end

    vim.fn.system({ "git", "-C", dir, "merge-base", "--is-ancestor", old, new })
    if vim.v.shell_error == 0 then
      vim.cmd("DiffviewOpen " .. old .. ".." .. new)
      return
    end

    vim.ui.select({ "range-diff", "diff" }, {
      prompt = "MR !" .. iid .. " переписан (rebase/force-push). Как показать?",
      format_item = function(item)
        if item == "range-diff" then return "range-diff — сравнить патчи до и после" end
        return "diff — старая голова → новая (с изменениями из " .. base .. ")"
      end,
    }, function(choice)
      if choice == "range-diff" then
        vim.cmd("tab Git range-diff origin/" .. base .. " " .. old .. " " .. new)
      elseif choice == "diff" then
        vim.cmd("DiffviewOpen " .. old .. ".." .. new)
      end
    end)
  end)
end

vim.keymap.set(
  "n",
  "dvo",
  diff_base_branch,
  { desc = "Diffview против базовой ветки (master/main)" }
)
vim.keymap.set(
  "n",
  "dvm",
  diff_merge_request,
  { desc = "Diffview по номеру MR (без checkout)" }
)
vim.keymap.set(
  "n",
  "dvr",
  mark_merge_request_reviewed,
  { desc = "Отметить последний открытый MR просмотренным" }
)
vim.keymap.set(
  "n",
  "dvn",
  diff_merge_request_since_reviewed,
  { desc = "Diffview: новое в MR с последнего просмотра" }
)
vim.keymap.set("n", "dvc", ":DiffviewClose<cr>")

vim.pack.add({
  "https://github.com/barrettruth/diffs.nvim",
})

-- CodeDiff: диффы в стиле VSCode (двухуровневая подсветка: строки + символы).
-- Библиотека скачивается сама при первом использовании (`:CodeDiff install` — вручную).
require("codediff").setup({
  diff = {
    layout = "inline",
  },
  keymaps = {
    view = {
      -- переход по файлам: Tab/Shift+Tab вместо дефолтных ]f/[f
      next_file = "<Tab>",
      prev_file = "<S-Tab>",
      -- тот же тоггл сайдбара, что и у diffview (там это дефолтный <leader>b)
      toggle_explorer = "<leader>b",
      focus_explorer = "<leader>e",
      -- переход по ханкам как в diffview — штатные ]c/[c из diff-режима Vim
      next_hunk = "]c",
      prev_hunk = "[c",
    },
  },
})

-- ╱ на месте вырезанного — тот же фон и цвет символа, что у diffview
-- (DiffviewDiffDeleteDim). Ставим после setup(): плагин задаёт CodeDiffFiller
-- через `default = true`, поэтому явное значение он не перезапишет.
local diff_colors = require("rem.colorscheme").diff
vim.api.nvim_set_hl(0, "CodeDiffFiller", {
  bg = "NONE",
  fg = diff_colors.filler_fg,
})

vim.g.diffs = {
  integrations = {
    fugitive = true,
  },
}
