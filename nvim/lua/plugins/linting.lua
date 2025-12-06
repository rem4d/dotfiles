return {
	"mfussenegger/nvim-lint",
	enabled = true,
	-- lazy = true,
	-- event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			python = { "flake8" },
			json = { "jsonlint" },
		}

		-- lint.linters_by_ft = {
		-- 	javascript = { "biomejs", "eslint_d", "eslint" },
		-- 	typescript = { "biomejs", "eslint_d", "eslint" },
		-- 	javascriptreact = { "biomejs", "eslint_d", "eslint" },
		-- 	typescriptreact = { "biomejs", "eslint_d", "eslint" },
		-- 	svelte = { "eslint_d" },
		-- 	python = { "pylint" },
		-- }

		local eslint = lint.linters.eslint_d

		eslint.args = {
			-- "--no-warn-ignored", -- <-- this is the key argument
			"--format",
			"json",
			"--stdin",
			"--stdin-filename",
			function()
				return vim.api.nvim_buf_get_name(0)
			end,
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		-- vim.keymap.set("n", "<leader>l", function()
		-- 	lint.try_lint()
		-- end, { desc = "Trigger linting for current file" })
	end,
}
