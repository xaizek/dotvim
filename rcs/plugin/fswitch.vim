function! AppendCreate(var, val)
    if exists(a:var)
        let l:lst = split(eval(a:var), ',')
    else
        execute 'let' a:var '=""'
        let l:lst = []
    endif

    let l:val = eval(a:val)
    if index(l:lst, l:val) == -1
        execute 'let' a:var '.=",".' a:val
    endif
endfunction

" autocommands to setup settings for different file types
augroup fswitch
    autocmd!
    autocmd! BufEnter,BufRead *.h call AppendCreate('b:fswitchdst', '"c"')
                              \ | call AppendCreate('b:fswitchdst', '"cpp"')
                              \ | call AppendCreate('b:fswitchlocs', '"."')
    autocmd! BufEnter,BufRead *.c let b:fswitchdst = 'h'
                              \ | let b:fswitchlocs = '.'
    autocmd! BufEnter,BufRead *.hpp let b:fswitchdst = 'cpp'
                              \ | let b:fswitchlocs = '.'
    autocmd! BufEnter,BufRead *.cpp let b:fswitchdst = 'hpp,h'
                                \ | let b:fswitchlocs = '.,../include'
    autocmd! BufEnter,BufRead *.xaml let b:fswitchdst = 'xaml.cs'
                              \ | let b:fswitchlocs = '.'
    autocmd! BufEnter,BufRead *.xaml.cs let b:fswitchdst = 'xaml'
                              \ | let b:fswitchfnames = '/\.xaml//'
                              \ | let b:fswitchlocs = '.'
augroup end

" switch to the file and load it into the current window
nnoremap <silent> <leader>of :FSHere<cr>

" in current window
nnoremap <silent> <leader>oo :FSHere<cr>
" in a new tab
nnoremap <silent> <leader>ot :call FSwitch('%', 'tabedit')<cr>
" in a new tab opened before this one
nnoremap <silent> <leader>oT :call FSwitch('%', "<c-r>=tabpagenr()-1<cr>tabedit")<cr>

" switch to the file and load it into the window on the right
nnoremap <silent> <leader>ol :FSRight<cr>

" switch to the file and load it into a new window split on the right
nnoremap <silent> <leader>oL :FSSplitRight<cr>

" switch to the file and load it into the window on the left
nnoremap <silent> <leader>oh :FSLeft<cr>

" switch to the file and load it into a new window split on the left
nnoremap <silent> <leader>oH :FSSplitLeft<cr>

" switch to the file and load it into the window above
nnoremap <silent> <leader>ok :FSAbove<cr>

" switch to the file and load it into a new window split above
nnoremap <silent> <leader>oK :FSSplitAbove<cr>

" switch to the file and load it into the window below
nnoremap <silent> <leader>oj :FSBelow<cr>

" switch to the file and load it into a new window split below
nnoremap <silent> <leader>oJ :FSSplitBelow<cr>
