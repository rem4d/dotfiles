return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	opts = {
		formatters_by_ft = {
			javascript = { "prettierd", "eslint_d" },
			typescript = { "prettierd", "eslint_d" },
			javascriptreact = { "prettierd", "eslint_d" },
			typescriptreact = { "prettierd", "eslint_d" },
			css = { "prettier" },
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
	},
}
