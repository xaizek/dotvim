" mark section on <leader>d
noremap <leader>d :Linediff<cr>

" reset all on <leader>D
noremap <leader>D :LinediffReset!<cr>

" do not automatically reindent samples
let g:linediff_indent = 0

" don't create temporary files
let g:linediff_buffer_type = 'scratch'
