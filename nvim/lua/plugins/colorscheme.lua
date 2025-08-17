return {
	{
		"sainnhe/sonokai",
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme sonokai]])
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		config = function()
			require("tokyonight").setup()
		end,
	},
}
