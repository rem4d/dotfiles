return {
	{
		"supermaven-inc/supermaven-nvim",
		enabled = true,
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
	{
		"olimorris/codecompanion.nvim",
		enabled = true,
		opts = {
			adapters = {
				mistral = function()
					return require("codecompanion.adapters").extend("mistral", {
						env = {
							api_key = "MISTRAL_API_KEY", -- Set your Mistral API key here
						},
					})
				end,
				codestral = function()
					return require("codecompanion.adapters").extend("mistral", {
						env = {
							url = "https://codestral.mistral.ai",
							api_key = "CODESTRAL_API_KEY",
						},
						schema = {
							model = {
								default = "codestral-latest",
							},
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "codestral",
				},
				inline = {
					adapter = "mistral",
				},
			},
		},
		dependencies = {
			"j-hui/fidget.nvim", -- Display status
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
