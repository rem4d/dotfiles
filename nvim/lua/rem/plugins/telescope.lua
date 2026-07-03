------------------------
------ Telescope -------
------------------------

local lga_actions = require("telescope-live-grep-args.actions")
require("telescope").setup({
	defaults = {
		path_display = { "filename_first" },
		file_ignore_patterns = { "node_modules" },
		color_devicons = true,
		layout_config = {
			prompt_position = "top",
			horizontal = {
				preview_width = 0.5,
			},
		},
		sorting_strategy = "ascending",
		mappings = {
			i = {
				["<C-k>"] = lga_actions.quote_prompt(),
				["<C-t>"] = require("telescope.actions.layout").toggle_preview,
			},
		},
		-- vimgrep_arguments = {
		-- 	"rg",
		-- 	"--color=never",
		-- 	"--no-heading",
		-- 	"--with-filename",
		-- 	"--line-number",
		-- 	"--column",
		-- 	"--smart-case",
		-- 	"--fixed-strings",
		-- },
	},
	pickers = {
		git_files = {
			theme = "ivy",
		},
		find_files = {
			theme = "ivy",
		},
		grep_string = {
			additional_args = { "--hidden" },
		},
		live_grep = {
			additional_args = { "--hidden" },
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		-- перехватывает vim.ui.select (в т.ч. LSP code actions) в telescope-пикер
		["ui-select"] = {
			require("telescope.themes").get_dropdown({
				winblend = 10,
				layout_config = {
					width = 0.6,
					height = 0.5,
				},
			}),
		},
	},
})
local telescope = require("telescope")

telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")
telescope.load_extension("ui-select")

local builtin = require("telescope.builtin")
local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })

-- vim.keymap.set("n", "<leader>rg", function()
-- 	builtin.grep_string({ search = vim.fn.input("Grep > ") })
-- end)

keymap.set("n", "<leader>a", builtin.live_grep, { desc = "Fuzzy find recent files" })

-- Возвращает путь к пакету, внутри которого лежит текущий файл,
-- т.е. ~/projects/services/packages/<some_package>
local function current_package_root()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		return nil
	end
	return file:match("(.*/packages/[^/]+)")
end

keymap.set("n", "<leader>fp", function()
	local root = current_package_root()
	if not root then
		vim.notify("Не в пакете (нет packages/ в пути)", vim.log.levels.WARN)
		return
	end
	builtin.live_grep({
		search_dirs = { root },
		prompt_title = "Grep: " .. vim.fn.fnamemodify(root, ":t"),
	})
end, { desc = "Live grep по текущему пакету" })

keymap.set("n", "<leader>fP", function()
	local root = current_package_root()
	if not root then
		vim.notify("Не в пакете (нет packages/ в пути)", vim.log.levels.WARN)
		return
	end
	builtin.find_files({
		search_dirs = { root },
		prompt_title = "Files: " .. vim.fn.fnamemodify(root, ":t"),
	})
end, { desc = "Find files по текущему пакету" })
keymap.set("n", "<leader>hi", builtin.command_history, { desc = "Command history" })
keymap.set("n", "<C-f>", builtin.git_files, { desc = "" })
keymap.set("n", "<leader>fr", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
keymap.set("n", "gR", function()
	builtin.lsp_references({
		layout_strategy = "horizontal",
		layout_config = {
			prompt_position = "top",
			horizontal = {
				preview_width = 0.5,
			},
		},
	})
end)

keymap.set("n", "gd", builtin.lsp_definitions, {})
keymap.set("n", "gi", vim.lsp.buf.implementation, {})

-- Add to init.lua
vim.keymap.set("v", "<leader>gr", builtin.git_bcommits_range, { desc = "Git bcommits range" })
-- keymap.set("n", "<leader>rg", "<cmd>Telescope grep_string search=<cr>")
-- keymap.set("n", "<C-b>", "<cmd>Telescope buffers<cr>", {})

keymap.set("n", "<BS>", builtin.command_history, {})
keymap.set("n", "<leader>t", builtin.resume, {})

vim.api.nvim_create_user_command("DiffGrep", function()
	local changed = vim.fn.systemlist("git diff --name-only origin/main...HEAD")

	require("telescope.builtin").live_grep({
		search_dirs = changed,
	})
end, {})

keymap.set("n", "<leader>ai", function()
	builtin.live_grep({
		additional_args = { "--hidden", "--no-ignore", "--glob=!node_modules/**", "--glob=!.git/**" },
		prompt_title = "Live grep (incl. gitignored)",
	})
end, { desc = "Live grep включая gitignore, кроме node_modules" })
