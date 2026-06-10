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
		map("n", "<leader>hd", gs.reset_hunk)
		-- map("n", "<leader>hu", gs.undo_stage_hunk)
		-- map("n", "<leader>hp", gs.preview_hunk)
	end,
})

-- Diffview
vim.opt.fillchars:append("diff:╱")

vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#20303b", fg = "none" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#362225" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#40252c", fg = "none" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#6b2020", fg = "none" })

vim.api.nvim_set_hl(0, "DiffDelete", {
	fg = "#333333", -- color of the ╱ symbol
	-- bg = "#37222c", -- background if you want
})

vim.keymap.set("n", "<leader>gdd", ":DiffviewOpen<cr>")
vim.keymap.set("n", "<leader>gdm", ":DiffviewOpen master..HEAD %<cr>")

require("neogit").setup({
	treesitter_diff_highlight = true,
	word_diff_highlight = true,
})

require("gitblame").setup({
	enabled = true,
})

vim.keymap.set("n", "dfo", ":DiffviewOpen origin/main...HEAD --imply-local<cr>")
vim.keymap.set("n", "dfc", ":DiffviewClose<cr>")

vim.api.nvim_set_hl(0, "Folded", {
	fg = "#414e63",
	bg = "#131a26",
	italic = true,
})
