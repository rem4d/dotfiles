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
	-- 	"nvim-telescope/telescope-fzf-native.nvim",
	-- 	build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
	-- },
}
