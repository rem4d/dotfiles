-- import mason
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_tool_installer = require("mason-tool-installer")

-- enable mason and configure icons
mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

mason_lspconfig.setup({
	ensure_installed = {
		"vtsls",
		"html",
		"cssls",
		"tailwindcss",
		"lua_ls",
		"graphql",
		-- "basedpyright",
		"somesass_ls",
	},
	automatic_installation = true,
	automatic_enable = {
		exclude = {
			"tailwindcss",
		},
	},
})

mason_tool_installer.setup({
	ensure_installed = {
		"prettierd", -- prettierd formatter
		"prettier", -- prettier formatter
		"stylua", -- lua formatter
		"eslint_d", -- js linter
		"biome", -- js linter
		"hadolint",
	},
})
