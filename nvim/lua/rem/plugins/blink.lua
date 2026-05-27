require("blink.cmp").setup({
	keymap = {
		preset = "default",
	},

	appearance = {
		nerd_font_variant = "mono",
	},

	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 150,
			window = {
				border = "rounded",
			},
		},
		trigger = { prefetch_on_insert = false },
	},

	sources = {
		default = {
			"lsp",
			"path",
			"buffer",
			"snippets",
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})
