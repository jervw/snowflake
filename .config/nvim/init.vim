
" turn on syntax highlighting
syntax on

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" tree shitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" better statusline
Plug 'itchyny/lightline.vim'

" color scheme
Plug 'catppuccin/nvim', {'as': 'catppuccin'}

" autoformat (todo. find alt)
Plug 'chiel92/vim-autoformat'

" language packs and syntax highlighting
Plug 'sheerun/vim-polyglot'

" fancy stuff
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'psliwka/vim-smoothie'
Plug 'frazrepo/vim-rainbow'


call plug#end()

" map space as leader
let mapleader = " "

" security
set modelines=0

" show line numbers
set number

" show file stats
set ruler

" blink cursor on error instead of beeping
set visualbell

" whitespace
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" list ends here. plugins become visible to vim after this caller.
call plug#end()

" cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" move up/down editor lines
nnoremap j gj
nnoremap k gk

" allow hidden buffers
set hidden

" rendering
set ttyfast

" status bar
set laststatus=2

" last line
set noshowmode
set showcmd

" searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " clear search

" remap help key.
inoremap <f1> <esc>:set invfullscreen<cr>a
nnoremap <f1> :set invfullscreen<cr>
vnoremap <f1> :set invfullscreen<cr>


" formatting
au bufwrite * :Autoformat
nnoremap <leader>f :Autoformat<cr>

" visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" uncomment this to enable by default:
" set list " to enable by default
" or use your leader key + l to toggle on/off
map <leader>l :set list!<cr> " toggle tabs and eol


" statusline
let g:lightline = {
      \ 'colorscheme': 'catppuccin',
      \ }

" color scheme
set termguicolors
set t_co=256
colorscheme catppuccin
hi normal guibg=none ctermbg=none
hi nontext ctermbg=none

