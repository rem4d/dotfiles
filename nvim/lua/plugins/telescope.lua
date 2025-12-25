return {
	"nvim-telescope/telescope.nvim",
	tag = "v0.2.0",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install",
		},
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local builtin = require("telescope.builtin")
		-- local actions = require("telescope.actions")
		--
		-- telescope.setup({
		-- 	defaults = {
		-- 		path_display = { "truncate " },
		-- 		mappings = {
		-- 			i = {
		-- 				["<C-k>"] = actions.move_selection_previous, -- move to prev result
		-- 				["<C-j>"] = actions.move_selection_next, -- move to next result
		-- 				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
		-- 			},
		-- 		},
		-- 	},
		-- })
		--
		-- telescope.load_extension("fzf")
		--
		-- -- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<C-f>", builtin.find_files, { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>a", builtin.live_grep, { desc = "Fuzzy find recent files" })
		-- keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		-- keymap.set("n", "<BS>", "<cmd>Telescope command_history<cr>")
		-- keymap.set("n", "<leader>aa", "<cmd>Telescope grep_string search=<cr>")
		-- keymap.set("n", "<C-b>", "<cmd>Telescope buffers<cr>", {})
	end,
}
