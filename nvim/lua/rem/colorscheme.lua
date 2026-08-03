-- vim.cmd([[colorscheme tokyonight]])
vim.cmd([[colorscheme nordic]])

-- brighter comments (default nordic gray4 #4C566A is too dim)
vim.api.nvim_set_hl(0, "Comment", { fg = "#7e8aa3", italic = true })

-- фон визуального выделения — синий вместо тёмного дефолта nordic
vim.api.nvim_set_hl(0, "Visual", { bg = "#2e4870" })

-- diff colors: nordic красит всё синим — делаем добавленное зелёным, удалённое красным
vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#33402c" }) -- добавленные строки
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#43292d", fg = "#7d4c52" }) -- удалённые строки / заполнитель
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#3a3f4b" }) -- изменённые строки целиком
vim.api.nvim_set_hl(0, "DiffText", { bg = "#4c5a38" }) -- изменённый фрагмент внутри строки

local function set_diff_hl()
	vim.api.nvim_set_hl(0, "DiffText", { bg = "#3a5670", bold = false })
	vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#34403a", bold = false })
	-- удалённые строки — красный фон + читаемый красный текст (было серым)
	vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#43292d", fg = "#c98a90" })
	-- the "╱" filler over deleted regions in diffview (enhanced_diff_hl remaps
	-- DiffDelete -> DiffviewDiffDeleteDim, which links to Comment by default)
	vim.api.nvim_set_hl(0, "DiffviewDiffDeleteDim", { fg = "#585f6e" })
	vim.api.nvim_set_hl(0, "DiffChange", { bg = "#2d3440" })
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
