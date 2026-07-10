require("nvim-eslint").setup({})

require("conform").setup({
	formatters_by_ft = {
		javascript = { "prettierd", "eslint_d" },
		typescript = { "prettierd" },
		javascriptreact = { "oxfmt", "eslint_d" },
		typescriptreact = { "oxfmt", "eslint_d" },
		css = { "prettier" },
		scss = { "prettier" },
		html = { "prettierd" },
		svg = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		graphql = { "prettier" },
		lua = { "stylua" },
		python = { "isort", "black" },
	},
	format_on_save = {
		timeout_ms = 1000,
		lsp_format = "fallback",
		async = false,
	},
})
