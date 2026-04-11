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
opt.hidden = true -- Enable background buffers
opt.history = 1000 -- Remember N lines in history
-- opt.lazyredraw = true -- Faster scrolling
opt.synmaxcol = 240 -- Max column for syntax highlight
opt.updatetime = 250 -- ms to wait for trigger an event
opt.swapfile = false -- Don't use swapfile
opt.showtabline = 2 -- always show tabs
opt.cursorline = false -- highlight the current line

opt.jumpoptions:remove("clean") -- open previously closed buffer with CTRL-O
opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

-- Disable nvim intro
opt.shortmess:append("sI")

-- Tab options
opt.shiftwidth = 4 -- Shift 4 spaces when tab
opt.tabstop = 4 -- 1 tab == 4 spaces
opt.expandtab = true -- Use spaces instead of tabs
-- End tab options

-- Auto indent
opt.autoindent = true -- New lines inherit indentation from the previous line
opt.smartindent = false -- can conflict with Treesitter
opt.cindent = false -- can conflict with Treesitter
-- End Auto indent

vim.o.cmdheight = 1
vim.o.winborder = "rounded"

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
