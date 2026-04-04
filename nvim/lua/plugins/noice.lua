return {
	{
		"folke/noice.nvim",
		enabled = false,
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"hrsh7th/nvim-cmp",
		},
		opts = {
			routes = {
				{
					view = "notify",
					filter = { event = "msg_showmode" },
				},
			},
			views = {
				hover = {
					border = {
						style = "rounded",
					},
				},
			},
		},
	},
	{
		"Fildo7525/pretty_hover",
		event = "LspAttach",
		keys = {
			{
				"K",
				function()
					require("pretty_hover").hover()
				end,
				desc = "Pretty Hover",
			},
		},
		opts = {},
	},
}
