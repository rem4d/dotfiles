-- vim.cmd([[colorscheme tokyonight]])
vim.cmd([[colorscheme nordic]])

-- brighter comments (default nordic gray4 #4C566A is too dim)
vim.api.nvim_set_hl(0, "Comment", { fg = "#7e8aa3", italic = true })

-- фон визуального выделения — синий вместо тёмного дефолта nordic
vim.api.nvim_set_hl(0, "Visual", { bg = "#2e4870" })

-- Единая палитра диффов: отсюда красятся и встроенные Diff*/diffview, и codediff
-- (см. rem.plugins.git). Приглушённый красный: было #43292d — слишком яркое.
local diff = {
  add = "#34403a", -- добавленные строки
  del = "#33262a", -- удалённые строки
  change = "#2d3440", -- изменённые строки целиком
  text = "#3a5670", -- изменённый фрагмент внутри строки
  del_fg = "#b3838a", -- текст в удалённых строках
  filler_fg = "#585f6e", -- символ ╱ на месте вырезанного
}

-- diff colors: nordic красит всё синим — делаем добавленное зелёным, удалённое красным
vim.api.nvim_set_hl(0, "DiffAdd", { bg = diff.add })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = diff.del, fg = diff.del_fg })
vim.api.nvim_set_hl(0, "DiffChange", { bg = diff.change })
vim.api.nvim_set_hl(0, "DiffText", { bg = diff.text })

local function set_diff_hl()
  vim.api.nvim_set_hl(0, "DiffText", { bg = diff.text, bold = false })
  vim.api.nvim_set_hl(0, "DiffAdd", { bg = diff.add, bold = false })
  -- удалённые строки — красный фон + читаемый красный текст (было серым)
  vim.api.nvim_set_hl(0, "DiffDelete", { bg = diff.del, fg = diff.del_fg })
  -- вырезанные строки в левой панели diffview (enhanced_diff_hl переносит
  -- DiffAdd -> DiffviewDiffAddAsDelete, цвет фиксируется при setup)
  vim.api.nvim_set_hl(0, "DiffviewDiffAddAsDelete", { bg = diff.del, fg = diff.del_fg })
  -- the "╱" filler over deleted regions in diffview (enhanced_diff_hl remaps
  -- DiffDelete -> DiffviewDiffDeleteDim, which links to Comment by default)
  vim.api.nvim_set_hl(0, "DiffviewDiffDeleteDim", { bg = diff.del, fg = diff.filler_fg })
  vim.api.nvim_set_hl(0, "DiffChange", { bg = diff.change })
  -- fold column (the gutter with "+" next to each changed chunk)
  vim.api.nvim_set_hl(0, "FoldColumn", { bg = "#242933", fg = "#414e63" })
  vim.api.nvim_set_hl(0, "Folded", {
    fg = "#414e63",
    bg = "#1b1f26",
    italic = true,
  })
end

-- apply now (colorscheme is already loaded by the time this file is required),
-- and re-apply on any future ColorScheme switch to nordic
set_diff_hl()
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "nordic",
  callback = set_diff_hl,
})

return { diff = diff }
