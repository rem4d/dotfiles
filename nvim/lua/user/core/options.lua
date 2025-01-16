local g = vim.g -- Global variables
local opt = vim.opt -- Set options (global/buffer/windows-scoped)

opt.number = true -- Show line number
opt.relativenumber = true
opt.mouse = "a" -- Enable mouse support
opt.clipboard = "unnamedplus" -- Copy/paste to system clipboard
opt.linebreak = true -- Wrap on word boundary
opt.undofile = true -- Save undo history
opt.ignorecase = true -- Ignore case letters when search
opt.completeopt = "menuone,noselect" -- Set completeopt to have a better completion experience
opt.showmatch = true -- Highlight matching parenthesis
--opt.colorcolumn = '80'      -- Line lenght marker at 80 columns
opt.splitbelow = true -- force all horizontal splits to go below current window
opt.splitright = true -- force all vertical splits to go to the right of current window
--If a pattern contains an uppercase letter
--it is case sensitive, otherwise, it is not
opt.smartcase = true
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.laststatus = 3 -- Set global statusline
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Shift 2 spaces when tab
opt.tabstop = 2 -- 1 tab == 2 spaces
-- opt.smartindent = true -- Autoindent new lines
opt.autoindent = true -- copy indent from current line when starting new one
opt.hidden = true -- Enable background buffers
opt.history = 1000 -- Remember N lines in history
opt.lazyredraw = true -- Faster scrolling
opt.synmaxcol = 240 -- Max column for syntax highlight
opt.updatetime = 250 -- ms to wait for trigger an event
opt.swapfile = false -- Don't use swapfile
opt.showtabline = 2 -- always show tabs
opt.cursorline = false -- highlight the current line
vim.opt.jumpoptions:remove("clean") -- open previously closed buffer with CTRL-O

-- https://github.com/hendrikmi/dotfiles/blob/main/nvim/lua/core/options.lua

-- vim.o.hlsearch = false -- Set highlight on search
-- vim.wo.signcolumn = 'yes' -- Keep signcolumn on by default
-- vim.o.timeoutlen = 300 -- time to wait for a mapped sequence to complete (in milliseconds)
-- vim.o.backup = false -- creates a backup file
-- vim.o.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
-- vim.o.whichwrap = 'bs<>[]hl' -- which "horizontal" keys are allowed to travel to prev/next line
-- vim.o.wrap = false -- display lines as one long line
-- vim.o.scrolloff = 4 -- minimal number of screen lines to keep above and below the cursor
-- vim.o.sidescrolloff = 8 -- minimal number of screen columns either side of cursor if wrap is `false`
-- vim.o.numberwidth = 4 -- set number column width to 2 {default 4}
-- vim.o.shiftwidth = 4 -- the number of spaces inserted for each indentation
-- vim.o.tabstop = 4 -- insert n spaces for a tab
-- vim.o.softtabstop = 4 -- Number of spaces that a tab counts for while performing editing operations
-- vim.o.showmode = false -- we don't need to see things like -- INSERT -- anymore
-- vim.o.backspace = 'indent,eol,start' -- allow backspace on
-- vim.o.pumheight = 10 -- pop up menu height
-- vim.o.conceallevel = 0 -- so that `` is visible in markdown files
-- vim.o.fileencoding = 'utf-8' -- the encoding written to a file
-- vim.o.cmdheight = 1 -- more space in the neovim command line for displaying messages
-- vim.opt.shortmess:append 'c' -- don't give |ins-completion-menu| messages
-- vim.opt.iskeyword:append '-' -- hyphenated words recognized by searches
-- vim.opt.formatoptions:remove { 'c', 'r', 'o' } -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
-- vim.opt.runtimepath:remove '/usr/share/vim/vimfiles' -- separate vim plugins from neovim in case vim still in use

-----------------------------------------------------------
-- Disable nvim intro
opt.shortmess:append("sI")

-- Disable builtin plugins
local disabled_built_ins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"matchit",
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
	"tutor",
	"rplugin",
	"synmenu",
	"optwin",
	"compiler",
	"bugreport",
	"ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end
