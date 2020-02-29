if has('win32')
    let g:vifm_term = ''
    let g:vifm_exec_args = '--select'
else
    let g:vifm_term = 'xterm -maximized -e'
endif

" embed Vifm into Vim's terminal when possible
let g:vifm_embed_term = 1

" open embedded terminal in a split
let g:vifm_embed_split = 1
