" key mapiing for denite window
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
    " open file
    nnoremap <silent><buffer><expr> <CR>    denite#do_map('do_action')
    nnoremap <silent><buffer><expr> h       denite#do_map('do_action', 'split')
    nnoremap <silent><buffer><expr> v       denite#do_map('do_action', 'vsplit')
    nnoremap <silent><buffer><expr> p       denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> i       denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'
    "close Denite
    nnoremap <silent><buffer><expr> q       denite#do_map('quit')
    nnoremap <silent><buffer><expr> <C-c>   denite#do_map('quit')
endfunction

" key mapping for dentie-filter window
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
    imap <silent><buffer> jj <Plug>(denite_filter_quit)
endfunction

" config
let s:denite_default_options = {
    \ 'prompt': '> ',
    \ 'start_filter': v:true,
    \ }
call denite#custom#option('default', s:denite_default_options)

" use the silver searcher
if executable('ag')
    call denite#custom#var('file/rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''])
    call denite#custom#var('grep', 'command', ['ag'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'default_opts', ['--follow', '--no-group', '--no-color', '--hidden'])
endif
