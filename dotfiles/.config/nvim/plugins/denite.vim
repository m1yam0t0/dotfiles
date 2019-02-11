" move line in insert mode
call denite#custom#map('insert', "<C-j>", '<denite:move_to_next_line>')
call denite#custom#map('insert', "<C-k>", '<denite:move_to_previous_line>')

" enter normal mode jj 
call denite#custom#map('insert', 'jj', '<denite:enter_mode:normal>')

" open split & vsplit
call denite#custom#map('normal', "<C-h>", '<denite:do_action:split>')
call denite#custom#map('insert', "<C-h>", '<denite:do_action:split>')
call denite#custom#map('normal', "<C-v>", '<denite:do_action:vsplit>')
call denite#custom#map('insert', "<C-v>", '<denite:do_action:vsplit>')

" use the silver searcher
if executable('ag')
    call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''])
    call denite#custom#var('grep', 'command', ['ag'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'default_opts', ['--follow', '--no-group', '--no-color', '--hidden'])
endif
