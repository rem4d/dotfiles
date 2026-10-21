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

-- Открывает diff против базовой ветки, пробуя origin/master, затем origin/main.
-- Если ни одной нет — сообщает через vim.notify.
local function diff_base_branch()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" then dir = vim.fn.getcwd() end
  local function ref_exists(ref)
    vim.fn.system({ "git", "-C", dir, "rev-parse", "--verify", "--quiet", ref })
    return vim.v.shell_error == 0
  end

  for _, branch in ipairs({ "master", "main" }) do
    if ref_exists(branch) then
      vim.cmd("DiffviewOpen " .. branch .. "...HEAD --imply-local")
      return
    end
  end
  vim.notify(
    "Diffview: не найдено ни origin/master, ни origin/main",
    vim.log.levels.ERROR
  )
end

vim.keymap.set(
  "n",
  "dvo",
  diff_base_branch,
  { desc = "Diffview против базовой ветки (master/main)" }
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
