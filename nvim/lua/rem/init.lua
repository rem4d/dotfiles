require("rem.core.options")
require("rem.core.autocmds")
require("rem.core.keymaps")

vim.pack.add({
	"https://github.com/sainnhe/sonokai",
	"https://github.com/folke/tokyonight.nvim",
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

	"https://github.com/stevearc/conform.nvim",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/mason-org/mason.nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = "v1.10.2",
	},
	-- "https://github.com/mfussenegger/nvim-lint",
	"https://github.com/esmuellert/nvim-eslint",

	-- "https://github.com/supermaven-inc/supermaven-nvim",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/L3MON4D3/LuaSnip",

	-- git plugins
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/f-person/git-blame.nvim",
	"https://github.com/sindrets/diffview.nvim",
	"https://github.com/neogitorg/neogit",
	"https://github.com/isakbm/gitgraph.nvim",

	-- text objects
	"https://github.com/wellle/targets.vim",

	"https://github.com/acksld/nvim-neoclip.lua",
})

vim.pack.add({ "https://github.com/nvim-mini/mini.ai" })
vim.pack.add({ "https://github.com/nvim-mini/mini.bracketed" })

-- vim.cmd.colorscheme("sonokai")
vim.cmd([[colorscheme tokyonight]])

require("rem.plugins.telescope")
require("rem.plugins.treesitter")
require("rem.plugins.nvim-tree")
require("rem.plugins.git")
require("rem.plugins.blink")
require("rem.plugins.mason")
require("rem.plugins.markdown")

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
		javascript = { "oxfmt", "eslint_d" },
		typescript = { "oxfmt", "eslint_d" },
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

require("nvim-autopairs").setup({
	disable_filetype = { "TelescopePrompt", "vim" },

	check_ts = true, -- enable treesitter
	ts_config = {
		lua = { "string" }, -- don't add pairs in lua string treesitter nodes
		javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
		java = false, -- don't check treesitter on java
	},
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

-- require("supermaven-nvim").enable({
-- 	keymaps = {
-- 		accept_suggestion = "<Tab>",
-- 		clear_suggestion = "<C-[>",
-- 		accept_word = "<C-]>",
-- 	},
-- 	disable_keymaps = false,
-- 	disable_inline_completion = false,
-- 	ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
-- })

require("luasnip.loaders.from_vscode").lazy_load()
require("nvim-ts-autotag").setup({})
-- require("mini.bracketed").setup({})
require("neoclip").setup({
	keys = {
		telescope = {
			i = {
				select = "<c-]>",
				paste = "<cr>",
				paste_behind = "<c-k>",
				replay = "<c-q>", -- replay a macro
				delete = "<c-d>", -- delete an entry
				edit = "<c-e>", -- edit an entry
				custom = {},
			},
			n = {
				select = "<cr>",
				paste = "p",
				--- It is possible to map to more than one key.
				-- paste = { 'p', '<c-p>' },
				paste_behind = "P",
				replay = "q",
				delete = "d",
				edit = "e",
				custom = {},
			},
		},
	},
})
