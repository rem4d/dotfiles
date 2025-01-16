" use vim settings, rather then vi settings (much better!).
" this must be first, because it changes other options as a side effect.
set nocompatible

" ================== Plugins ================="

call plug#begin('~/.vim/plugged')
  " Theme
  Plug 'sainnhe/sonokai'
  " Editing
  Plug 'tpope/vim-surround'    " cs`' to change `` to '', etc
  Plug 'tpope/vim-repeat'
  Plug 'wellle/targets.vim'
  Plug 'tpope/vim-repeat'

  " Tmux
  Plug 'christoomey/vim-tmux-navigator'

call plug#end()


" ================== Theme ================="

let g:sonokai_style = 'shusia'
let g:sonokai_enable_italic = 1
colorscheme sonokai
set background=dark


if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif


" ================== Tmux ================="

if executable('tmux')
  " Navigate between vim and tmux splits
  nnoremap <silent><C-h> <C-\><C-n> :TmuxNavigateLeft<cr>
  nnoremap <silent><C-j> <C-\><C-n> :TmuxNavigateDown<cr>
  nnoremap <silent><C-k> <C-\><C-n> :TmuxNavigateUp<cr>
  nnoremap <silent><C-l> <C-\><C-n> :TmuxNavigateRight<cr>
endif

" ================== General ================="

set number " Precede each line with its line number
set cursorline " Highlight the current line
set history=1000 " Remember a lot of stuff
set wildmenu " Enhance command-line completion
set wildmode=longest:full,full
set wildignorecase
set belloff=all
set noshowmode " Don't display native status line
set ignorecase " Ignore case in search
set hlsearch " Highlight searches
set incsearch
" If a pattern contains an uppercase letter
" it is case sensitive, otherwise, it is not
set smartcase
set backspace=indent,eol,start " Allow backspace in insert mode
set updatecount=0 " Disable swap files
set hidden " Enable abandon buffer if modified
set nowrap " Display long lines as one line
set linebreak " Don't break words when wrapping
set breakindent " Enable break indent
set autoindent " Auto-indent new lines
set expandtab " Convert tabs to spaces
set shiftwidth=4 " Spaces per indentation
set softtabstop=4  " Spaces per tab during editing ops
set spelllang=en,ru " Spell language
set nostartofline " Keep the cursor in the same place when switching buffers
set autoread " Automatically refresh file if it was changed external program
set modifiable " Able to modify buffer with :argdo
set formatoptions+=n1 " Turn off auto-commenting behaviour on new line. Does not work!
set splitright " Open new split pane to the right
set cmdheight=2 " Better display for messages

" ================== Key Mappings ================="

" Set <space> to leader
let mapleader=' '
let maplocalleader='\'
nnoremap <leader>v :vsplit ~/.vimrc<CR>
nnoremap <leader><space>r :so ~/.vimrc<CR>
nnoremap <leader><leader>q :qa!<cr>
nnoremap <leader>b :bd<cr>
nnoremap <leader>w :w<cr>

" Switch buffers
nnoremap <silent> H :bp<CR>
nnoremap <silent> L :bn<CR>

" Quit buffer
nnoremap <leader>q :bd<CR>

nnoremap <silent> L :bn<CR>

" Force j and k to work on display lines
nnoremap k gk
nnoremap j gj
vnoremap k gk
vnoremap j gj

" Window mappings
noremap <right> <C-w>>
noremap <left> <C-w><
noremap <up> <C-w>+
noremap <down> <C-w>-

" Return to normal mode from insert mode
inoremap fd <Esc>
inoremap jj <Esc>

" Add ';' at the end of line
nnoremap <leader>; mqg_a;<esc>`q

" Add ',' at the end of line
nnoremap <leader><leader>; mqg_a,<esc>`q

" Move cursor to the end of line in insert mode
inoremap <C-e> <Esc>A

" Press enter for newline without insert
nnoremap <cr> o<esc>

" Clear search (highlight)
nnoremap <silent> <leader>k :noh<cr>

" delete single character without copying into register
nnoremap x "_x
