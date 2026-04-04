-----------------------------------------------------------
-- Autocommand functions
-----------------------------------------------------------

-- Define autocommands with Lua APIs
-- See: h:api-autocmd, h:augroup

local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- General settings:
--------------------

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
	group = "YankHighlight",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = "1000" })
	end,
})

-- Remove whitespace on save
-- autocmd("BufWritePre", {
-- 	pattern = "",
-- 	command = ":%s/\\s\\+$//e",
-- })

-- Don't auto commenting new lines
autocmd("BufEnter", {
	pattern = "",
	command = "set fo-=c fo-=o",
})

-- Open help vertically
autocmd("Filetype", {
	pattern = "help",
	command = "wincmd L",
})
-- auto-remove unused imports when saving a file
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
-- 	-- group = vim.api.nvim_create_augroup("ts_imports", { clear = true }),
-- 	pattern = { "*.tsx", "*.ts" },
-- 	callback = function()
-- 		vim.lsp.buf.code_action({
-- 			apply = true,
-- 			context = {
-- 				only = { "source.removeUnused.ts" },
-- 				diagnostics = {},
-- 			},
-- 		})
-- 	end,
-- })
