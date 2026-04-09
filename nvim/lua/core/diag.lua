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

local opts = { noremap = true, silent = true }
-- vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.enable(false)<cr>", opts)
-- vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.enable()<cr>", opts)
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

require("vim._core.ui2").enable({
	enable = true,
	msg = {
		targets = "msg",
	},
})

vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(ev)
		local value = ev.data.params.value
		vim.api.nvim_echo({ { value.message or "done" } }, false, {
			id = "lsp." .. ev.data.client_id,
			kind = "progress",
			source = "vim.lsp",
			title = value.title,
			status = value.kind ~= "end" and "running" or "success",
			percent = value.percentage,
		})
	end,
})
