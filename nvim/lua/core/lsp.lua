vim.lsp.enable({
	"vtsls",
	"lua_ls",
	"tailwindcss",
})

vim.diagnostic.config({
	-- virtual_lines = true,
	virtual_text = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	},
	severity_sort = true,
})
