" move line in insert mode
call denite#custom#map('insert', "<C-j>", '<denite:move_to_next_line>')
call denite#custom#map('insert', "<C-k>", '<denite:move_to_previous_line>')

" enter normal mode jj 
call denite#custom#map('insert', 'jj', '<denite:enter_mode:normal>')

" key mappings
nnoremap <silent> <C-b> :<C-u>Denite buffer<CR>
nnoremap <silent> <C-p> :<C-u>Denite file_rec<CR>
