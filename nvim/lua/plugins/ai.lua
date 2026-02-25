return {
	{
		"supermaven-inc/supermaven-nvim",
		enabled = false,
		event = "InsertEnter",
		cmd = {
			"SupermavenUseFree",
			"SupermavenUsePro",
		},
		opts = {
			keymaps = {
				accept_suggestion = "<Tab>",
				clear_suggestion = "<C-[>",
				accept_word = "<C-]>",
			},
			disable_keymaps = false,
			disable_inline_completion = false,
			ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
		},
	},
	{
		"github/copilot.vim",
		enabled = false,
		-- "zbirenbaum/copilot.lua",
	},
	{ "nvim-lua/plenary.nvim", branch = "master" },
}
