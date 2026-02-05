return {
	{
		"supermaven-inc/supermaven-nvim",
		enabled = true,
		event = "InsertEnter",
		cmd = {
			"SupermavenUseFree",
			"SupermavenUsePro",
		},
		opts = {
			keymaps = {
				accept_suggestion = "<Tab>",
				clear_suggestion = "<C-[>",
				accept_word = "<C-]>",
			},
			disable_keymaps = false,
			disable_inline_completion = false,
			ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
		},
	},
	{
		"milanglacier/minuet-ai.nvim",
		enabled = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			throttle = 1000,
			debounce = 250,
			provider = "codestral",
			virtualtext = {
				auto_trigger_ft = {},
				keymap = {
					-- accept whole completion
					accept = "<Tab>",
					-- accept one line
					accept_line = "<A-a>",
					-- accept n lines (prompts for number)
					-- e.g. "A-z 2 CR" will accept 2 lines
					accept_n_lines = "<A-z>",
					-- Cycle to prev completion item, or manually invoke completion
					prev = "<A-[>",
					-- Cycle to next completion item, or manually invoke completion
					next = "<A-]>",
					dismiss = "<A-e>",
				},
			},
			provider_options = {
				codestral = {
					optional = {
						max_tokens = 256,
						stop = { "\n\n" },
					},
				},
			},
		},
	},
	{
		"github/copilot.vim",
		enabled = false,
		-- "zbirenbaum/copilot.lua",
	},
	{ "nvim-lua/plenary.nvim", branch = "master" },
	{
		"olimorris/codecompanion.nvim",
		enabled = true,
		opts = {
			adapters = {
				mistral = function()
					return require("codecompanion.adapters").extend("mistral", {
						env = {
							api_key = "MISTRAL_API_KEY", -- Set your Mistral API key here
						},
					})
				end,
				codestral = function()
					return require("codecompanion.adapters").extend("mistral", {
						env = {
							url = "https://codestral.mistral.ai",
							api_key = "CODESTRAL_API_KEY",
						},
						schema = {
							model = {
								default = "codestral-latest",
							},
						},
					})
				end,
				-- ollama = function()
				-- 	return require("codecompanion.adapters").extend("ollama", {
				-- 		schema = {
				-- 			model = {
				-- 				default = "qwen3:latest",
				-- 			},
				-- 			num_ctx = {
				-- 				default = 20000,
				-- 			},
				-- 		},
				-- 	})
				-- end,
			},
			strategies = {
				chat = {
					adapter = "codestral",
				},
				inline = {
					adapter = "mistral",
				},
			},
		},
		dependencies = {
			"j-hui/fidget.nvim", -- Display status
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"yetone/avante.nvim",
		enabled = false,
		build = "make",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		opts = {
			provider = "copilot",
			providers = {
				ollama = {
					endpoint = "http://127.0.0.1:11434",
					model = "qwen3:8b",
					disable_tools = false,
					timeout = 15000,
					extra_request_body = {
						stream = true,
					},
				},
				copilot = {},
				mistral = {
					__inherited_from = "openai",
					endpoint = "https://codestral.mistral.ai/v1/chat/completions",
					model = "codestral-latest",
					api_key_name = "CODESTRAL_API_KEY",
					-- parse_curl_args = function(opts, code_opts)
					-- 	local api_key = os.getenv(opts.api_key_name)
					-- 	local Llm = require("avante.providers")
					--
					-- 	return {
					-- 		url = opts.endpoint,
					-- 		headers = {
					-- 			["Accept"] = "application/json",
					-- 			["Content-Type"] = "application/json",
					-- 			["Authorization"] = "Bearer " .. api_key,
					-- 		},
					-- 		body = {
					-- 			model = opts.model,
					-- 			messages = Llm.openai.parse_message(code_opts),
					-- 			temperature = 0.7,
					-- 			max_tokens = 8192,
					-- 			stream = true,
					-- 			safe_prompt = false,
					-- 		},
					-- 	}
					-- end,
					-- parse_response_data = function(data_stream, event_state, opts)
					-- 	local Llm = require("avante.providers")
					-- 	Llm.openai.parse_response(data_stream, event_state, opts)
					-- end,
				},
				mistral2 = {
					-- endpoint = "https://api.mistral.ai/v1/chat/completions",
					-- model = "codestral-2501",
					-- timeout = 15000,
					-- extra_request_body = {
					-- 	stream = true,
					-- },
					__inherited_from = "openai",
					api_key_name = "MISTRAL_API_KEY",
					endpoint = "https://api.mistral.ai/v1/",
					model = "mistral-large-latest",
					extra_request_body = {
						max_tokens = 4096, -- to avoid using max_completion_tokens
					},
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"echasnovski/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"stevearc/dressing.nvim", -- for input provider dressing
			"folke/snacks.nvim", -- for input provider snacks
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
}
