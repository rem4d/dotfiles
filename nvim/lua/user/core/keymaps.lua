-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local mulstr = [[
Multi line
string
here
  atata
]]

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

-- Open init.lua
map("n", "<leader>v", ":vsplit ~/.config/nvim/init.lua<cr>")

-- Save file
map("n", "<leader>w", ":w<cr>")

-- Save file without auto-formatting
map("n", "<leader>nw", "<cmd>noautocmd w <CR>")

-- Quit without saving
map("n", "<leader><leader>q", ":qa!<cr>")

-- Close buffer
map("n", "<leader>q", ":bd<cr>")

-- delete single character without copying into register
map("n", "x", '"_x')

-- Clear search highlighting with <leader> and k
map("n", "<leader>k", ":nohl<cr>")

-- Vertical scroll and center
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Find and center
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Return to normal mode from insert mode
map("i", "fd", "<Esc>")
map("i", "jj", "<Esc>")

-- Press enter for newline without insert
map("n", "<cr>", "o<Esc>")

-- Add ';' at the end of line
map("n", "<leader>;", "mqg_a;<esc>`q")

-- Add ',' at the end of line
map("n", "<leader><leader>;", "mqg_a,<esc>`q")

-- Go to previous buffer
map("n", "H", ":bp<cr>")

-- Go to next buffer
map("n", "L", ":bn<cr>")

-- Windows size mappings
map("n", "<right>", "<C-w>>")
map("n", "<left>", "<C-w><")
map("n", "<up>", "<C-w>+")
map("n", "<down>", "<C-w>-")

-- Force j and k to work on the screen lines
map("n", "k", "gk")
map("n", "j", "gj")
map("v", "k", "gk")
map("v", "j", "gj")

-- Toggle line wrapping
map("n", "<leader>lw", "<cmd>set wrap!<CR>")

-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Keep last yanked when pasting
map("v", "p", '"_dP')

-- Copy/paste
map("n", "<C-y>", '"*y')
map("x", "<C-y>", '"*y')
map("n", "<C-p>", ':set paste<cr>"*]p:set nopaste<cr>')
map("x", "<C-p>", ':set paste<cr>"*]p:set nopaste<cr>')
-- Copy/paste
-- nnoremap <silent> s :set opfunc=PasteReplace<CR>g@
-- vnoremap <silent> s :<C-U>call PasteReplace(visualmode(), 1)<CR>
map("v", "s", ":<C-U>call PasteReplace(visualmode(),1)<cr>")

-- Reload configuration without restart nvim
map("n", "<leader><leader>r", ":so %<cr>")
-----------------------------------------------------------
-- Applications and Plugins shortcuts
-----------------------------------------------------------

-- Tmux navigator
if vim.fn.executable("tmux") == 1 then
	map("n", "<C-h>", ":TmuxNavigateLeft<cr>")
	map("n", "<C-j>", ":TmuxNavigateDown<cr>")
	map("n", "<C-k>", ":TmuxNavigateUp<cr>")
	map("n", "<C-l>", ":TmuxNavigateRight<cr>")
end
