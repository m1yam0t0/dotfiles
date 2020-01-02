" lightline settings

" functions for lightline
function! LightlineFugitive()
    if exists('*fugitive#head') && strlen(fugitive#head())
        return "\ue0a0 " . fugitive#head()
    else
        return ''
    endif
endfunction

" status line
let g:lightline = {
    \ 'active': {
    \   'left': [
    \     [ 'mode', 'paste' ],
    \     [ 'gitbranch', 'readonly', 'filename', 'modified' ]
    \   ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'LightlineFugitive'
    \ },
    \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
    \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
    \ 'colorscheme': 'solarized'
	\ }

" show statusbar
set laststatus=2

" hide --INSERT--
set noshowmode
