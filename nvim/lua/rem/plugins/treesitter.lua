------------------------
--- Treesitter setup ---
------------------------

local ts_parsers = {
	"css",
	"dockerfile",
	"jsdoc",
	"json",
	"markdown",
	"markdown_inline",
	"python",
	"tsx",
	"javascript",
	"typescript",
	"yaml",
	"svelte",
	"astro",
}

local nts = require("nvim-treesitter")
nts.install(ts_parsers)
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function()
		nts.update()
	end,
})

local ignore_filetypes = {
	"checkhealth",
	"lazy",
	"mason",
	"cmd",
	"snacks_dashboard",
	"snacks_notif",
	"snacks_win",
}

local ignore_indent_filetypes = {
	lua = true,
}

vim.api.nvim_create_autocmd("FileType", { -- enable treesitter highlighting and indents
	callback = function(args)
		local filetype = args.match
		if vim.tbl_contains(ignore_filetypes, filetype) then
			return
		end

		if filetype == nil or filetype == "" then
			return
		end

		local lang = vim.treesitter.language.get_lang(filetype)
		if lang and vim.treesitter.language.add(lang) then
			if not ignore_indent_filetypes[filetype] then
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
			vim.treesitter.start()
		end
	end,
})
