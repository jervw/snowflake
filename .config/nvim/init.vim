"=======================================================================
"general
"=======================================================================

syntax on
set ma
set mouse=a
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoread
set nobackup
set nowritebackup
set noswapfile
set nu
set foldlevelstart=99
set scrolloff=7
set number
set ruler



"=======================================================================
"plugins
"=======================================================================

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" color scheme
Plug 'catppuccin/nvim', {'as': 'catppuccin'}

" tree shitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" better statusline
Plug 'itchyny/lightline.vim'

" motions
Plug 'phaazon/hop.nvim'

" lang packs
Plug 'sheerun/vim-polyglot'

" native LSP
Plug 'neovim/nvim-lspconfig'

" LSP autocomplete
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'onsails/lspkind-nvim'

" Fuzzy
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" files
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}

" fancy
Plug 'frazrepo/vim-rainbow'
Plug 'sbdchd/neoformat'
Plug 'psliwka/vim-smoothie'

call plug#end()

colorscheme catppuccin

highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
set cursorline
hi normal guibg=none ctermbg=none
hi nontext ctermbg=none

"=======================================================================
" keybindings
"=======================================================================

let mapleader = " "

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

nnoremap <leader>v <cmd>CHADopen<cr>

"format
nnoremap <leader>f :Neoformat

"=======================================================================
" plugin configs
"=======================================================================

let $FZF_DEFAULT_OPTS='--reverse'
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }


let g:lightline = {
      \ 'colorscheme': 'catppuccin',
      \ }


lua require("jervw")
