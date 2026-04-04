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

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.enable(false)<cr>", opts)
vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.enable()<cr>", opts)
