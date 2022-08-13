" reset augroup
augroup vimrc
	autocmd!
augroup END

" vim-plug
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:plug_dir = s:cache_home . '/nvim/plugged'

call plug#begin( s:plug_dir )

Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'
Plug 'lifepillar/vim-solarized8'

call plug#end()

syntax enable

" options
set backspace=indent,eol,start
set encoding=utf-8
set fileencodings=utf-8,cp932,euc-jp,sjis
set fileformats=unix,dos,mac

set number
set title
set splitright
set splitbelow
set hidden

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set showmatch

set clipboard=unnamed

" Turn off paste mode when leaving insert
autocmd InsertLeave * set nopaste

" key mappings
let mapleader = "\<Space>"

" common
nnoremap ; :
nnoremap : ;
inoremap <silent> jj <ESC>

" buffer
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>

" window
nnoremap <silent> sh <C-w>h
nnoremap <silent> sj <C-w>j
nnoremap <silent> sk <C-w>k
nnoremap <silent> sl <C-w>l
nnoremap <silent> sH <C-w>H
nnoremap <silent> sJ <C-w>J
nnoremap <silent> sK <C-w>K
nnoremap <silent> sL <C-w>L
nnoremap <tab> <C-w>w
nnoremap <S-tab> <C-w>W

" terminal
nnoremap <silent> <leader>t :terminal<CR>i
nnoremap <silent> <leader>ht :new<CR>:terminal<CR>i
nnoremap <silent> <leader>vt :vnew<CR>:terminal<CR>i
tnoremap <Esc> <C-\><C-n>

let s:config_home = empty($XDG_CONFIG_HOME) ? expand('~/.config') : $XDG_CONFIG_HOME
let s:config_dir = s:config_home . '/nvim'

" Plugin settings
execute 'source' s:config_dir . '/plugins/lightline.vim'
execute 'source' s:config_dir . '/plugins/fzf.vim'

" Color settings
set background=dark
colorscheme solarized8

highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight LineNr ctermbg=none
highlight Folded ctermbg=none
highlight EndOfBuffer ctermbg=none

