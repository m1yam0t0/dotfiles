if &compatible
	set nocompatible " Be iMproved
endif

" reset augroup
augroup MyAutoCmd
	autocmd!
augroup END

" dein settings {{{
" Install Dein
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
	call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath

" Install Plugin
let s:rc_dir = empty($XDG_CONFIG_HOME) ? expand('~/.config/nvim/') : ($XDG_CONFIG_HOME . '/nvim/')
let s:toml_file = fnamemodify(s:rc_dir, ':h') . '/dein.toml'
let s:lazy_toml_file = fnamemodify(s:rc_dir, ':h') . '/dein_lazy.toml'
if dein#load_state(s:dein_dir)
	call dein#begin(s:dein_dir)
	call dein#load_toml(s:toml_file, {'lazy': 0})
	call dein#load_toml(s:lazy_toml_file, {'lazy': 1})
	call dein#end()
	call dein#save_state()
endif

" Required:
filetype plugin indent on

" If you want to install not installed plugins on startup.
if dein#check_install()
	call dein#install()
endif
" }}}

" Python settings
let g:python_host_prog = ''
if isdirectory(expand($PYENV_ROOT))
    let g:python3_host_prog = $PYENV_ROOT . '/versions/neovim/bin/python'
endif

syntax enable

" encode options
set backspace=indent,eol,start
set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileformats=unix,dos,mac

set number
set title
set showmatch
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent

" Turn off paste mode when leaving insert
autocmd InsertLeave * set nopaste

" key mappings {{{
" common
nnoremap ; :
nnoremap : ;
inoremap <silent> jj <ESC>
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>
nnoremap <silent> <C-d> :bdelete<CR>

" Denite
nnoremap <silent> <C-b> :<C-u>Denite buffer<CR>
nnoremap <silent> <C-p> :<C-u>Denite file/rec<CR>
" }}}

" Color settings
set background=dark
colorscheme solarized
