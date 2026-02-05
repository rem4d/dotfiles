return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	config = function()
		local parsers = {
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
		}

		-- local ts = require("nvim-treesitter")
		-- for _, parser in ipairs(parsers) do
		-- 	ts.install(parser)
		-- end

		-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		vim.api.nvim_create_autocmd("FileType", {
			pattern = parsers,
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}
