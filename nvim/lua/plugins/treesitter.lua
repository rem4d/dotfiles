return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"andymass/vim-matchup",
		},
		config = function()
			local treesitter = require("nvim-treesitter.configs")

			treesitter.setup({
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				matchup = { enable = true },
				ensure_installed = {
					"bash",
					"css",
					"dockerfile",
					"gitignore",
					"graphql",
					"html",
					"javascript",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"prisma",
					"python",
					"query",
					"sql",
					"tmux",
					"tsx",
					"typescript",
					"vim",
					"yaml",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
			})

			-- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
			require("ts_context_commentstring").setup({})
		end,
	},
}
