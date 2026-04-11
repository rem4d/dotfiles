require("rem.core.options")
require("rem.core.autocmds")
require("rem.core.keymaps")

vim.pack.add({
	"https://github.com/sainnhe/sonokai",
	"https://github.com/christoomey/vim-tmux-navigator",
	"https://github.com/tpope/vim-surround",
	"https://github.com/andymass/vim-matchup",
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/christoomey/vim-tmux-navigator",
	"https://github.com/nvim-tree/nvim-tree.lua",

	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/akinsho/bufferline.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",

	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	{
		src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	"https://github.com/nvim-telescope/telescope-live-grep-args.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/f-person/git-blame.nvim",

	"https://github.com/stevearc/conform.nvim",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/mason-org/mason.nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = "v1.10.2",
	},
})

vim.cmd.colorscheme("sonokai")

require("rem.plugins.telescope")
require("rem.plugins.treesitter")
require("rem.plugins.nvim-tree")
require("rem.plugins.git")
require("rem.plugins.mason")

require("bufferline").setup({
	options = {
		mode = "buffers",
		separator_style = "thick",
		-- buffer_close_icon = "×",
		show_buffer_close_icons = false,
	},
})

require("lualine").setup({
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
})

require("conform").setup({
	formatters_by_ft = {
		javascript = { "prettierd", "eslint_d" },
		typescript = { "prettierd", "eslint_d" },
		javascriptreact = { "prettierd", "eslint_d" },
		typescriptreact = { "prettierd", "eslint_d" },
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

require("nvim-autopairs").setup({
	disable_filetype = { "TelescopePrompt", "vim" },

	check_ts = true, -- enable treesitter
	ts_config = {
		lua = { "string" }, -- don't add pairs in lua string treesitter nodes
		javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
		java = false, -- don't check treesitter on java
	},
})

require("blink.cmp").setup({
	keymap = {
		preset = "default",
	},

	appearance = {
		nerd_font_variant = "mono",
	},

	completion = {
		documentation = { auto_show = false },
		trigger = { prefetch_on_insert = false },
	},

	sources = {
		default = {
			"lsp",
			"path",
			"buffer",
			-- , "snippets", "buffer"
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})

vim.diagnostic.config({
	-- virtual_lines = true,
	virtual_text = false,
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

require("vim._core.ui2").enable({
	enable = true,
	msg = {
		targets = {
			[""] = "msg",
			empty = "cmd",
			bufwrite = "msg",
			confirm = "cmd",
			emsg = "pager",
			echo = "msg",
			echomsg = "msg",
			echoerr = "pager",
			completion = "cmd",
			list_cmd = "pager",
			lua_error = "pager",
			lua_print = "msg",
			progress = "pager",
			rpc_error = "pager",
			quickfix = "msg",
			search_cmd = "cmd",
			search_count = "cmd",
			shell_cmd = "pager",
			shell_err = "pager",
			shell_out = "pager",
			shell_ret = "msg",
			undo = "msg",
			verbose = "pager",
			wildlist = "cmd",
			wmsg = "msg",
			typed_cmd = "cmd",
		},
		cmd = {
			height = 0.5,
		},
		dialog = {
			height = 0.5,
		},
		msg = {
			height = 0.3,
			timeout = 5000,
		},
		pager = {
			height = 0.5,
		},
	},
})
