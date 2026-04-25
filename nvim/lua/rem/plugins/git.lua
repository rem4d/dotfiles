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

		-- 	-- Actions
		-- map("n", "<leader>hs", gs.stage_hunk)
		map("n", "<leader>hd", gs.reset_hunk)
		-- map("n", "<leader>hu", gs.undo_stage_hunk)
		-- map("n", "<leader>hp", gs.preview_hunk)
	end,
})
