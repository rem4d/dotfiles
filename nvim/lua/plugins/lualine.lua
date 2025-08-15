return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "meuter/lualine-so-fancy.nvim" },
	opts = {
		options = {
			theme = "seoul256",
			component_separators = { left = "│", right = "│" },
			section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = {},
			lualine_b = {
				{ "fancy_branch" },
			},
			lualine_c = {
				{ "fancy_cwd", substitute_home = true },
				{ "filename", path = 1 },
			},
			lualine_x = {
				{ "fancy_macro" },
				{ "fancy_diagnostics" },
			},
			lualine_y = {
				{ "fancy_lsp_servers" },
				{ "fancy_diff" },
			},
			lualine_z = {},
		},
	},
}
