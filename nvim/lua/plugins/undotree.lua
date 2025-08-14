return {
	"mbbill/undotree",
	config = function()
		local keymap = vim.keymap

		keymap.set("n", "<leader>u", "<cmd>:UndotreeToggle<cr>", { desc = "Toggle undo tree" })
		-- vim.cmd([[colorscheme sonokai]])
		vim.opt.undodir = vim.fn.stdpath("config") .. "./undo"
		vim.opt.undofile = true
		vim.opt.undolevels = 1000
		vim.opt.undoreload = 10000
	end,
}
