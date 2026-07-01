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
			if vim.wo.diff then
				return "]h"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "[h", function()
			if vim.wo.diff then
				return "[h"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "<leader>hi", gs.preview_hunk_inline)
		map("n", "<leader>hp", gs.preview_hunk)

		-- 	-- Actions
		-- map("n", "<leader>hs", gs.stage_hunk)
		map("n", "<leader>hr", gs.reset_hunk)
		-- map("n", "<leader>hu", gs.undo_stage_hunk)
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

local function set_diff_hl()
	vim.api.nvim_set_hl(0, "DiffText", { bg = "#3a5670", bold = false })
	vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#34403a", bold = false })
	vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#373a42" })
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
	if dir == "" then
		dir = vim.fn.getcwd()
	end
	local function ref_exists(ref)
		vim.fn.system({ "git", "-C", dir, "rev-parse", "--verify", "--quiet", ref })
		return vim.v.shell_error == 0
	end

	for _, branch in ipairs({ "origin/master", "origin/main" }) do
		if ref_exists(branch) then
			vim.cmd("DiffviewOpen " .. branch .. "...HEAD --imply-local")
			return
		end
	end
	vim.notify("Diffview: не найдено ни origin/master, ни origin/main", vim.log.levels.ERROR)
end

vim.keymap.set("n", "dvo", diff_base_branch, { desc = "Diffview против базовой ветки (master/main)" })
vim.keymap.set("n", "dvc", ":DiffviewClose<cr>")
