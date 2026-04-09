return {
	"christoomey/vim-tmux-navigator",
	"tpope/vim-surround",
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
	},
	"wellle/targets.vim",
	"LunarVim/bigfile.nvim",
	{
		"davidmh/mdx.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	-- "lambdalisue/vim-suda",
	-- "tpope/vim-fugitive",
	-- {
	-- 	"j-hui/fidget.nvim",
	-- 	opts = { },
	-- },
	-- jumb between opening/closing tags
	{
		"andymass/vim-matchup",
		event = "BufReadPost",
	},
	{
		"romus204/tree-sitter-manager.nvim",
		enabled = false,
		dependencies = {}, -- tree-sitter CLI must be installed system-wide
		config = function()
			require("tree-sitter-manager").setup({
				ensure_installed = {
					"css",
					"dockerfile",
					"jsdoc",
					"json",
					"markdown",
					"markdown_inline",
					"python",
					-- "tsx",
					-- "javascript",
					"typescript",
					"yaml",
				},
				-- Optional: custom paths
				-- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
				-- query_dir = vim.fn.stdpath("data") .. "/site/queries",
			})
		end,
	},
}
