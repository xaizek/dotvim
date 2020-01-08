" ~/.vim/bundle/vifm/ftplugin/mail.vim

" mutt: insert attachment
function! s:AddMuttAttacments()
    if has('gui')
        silent !xterm -e 'vifm -f'
    else
        silent !vifm -f
    endif

    let l:path = expand('$HOME/.vifm/vimfiles')
    let l:insert_pos = search('^Reply-To:', 'nw')

    if filereadable(l:path) && l:insert_pos != 0
        for line in readfile(l:path)
            call append(l:insert_pos, 'Attach: '.line)
            let l:insert_pos += 1
        endfor
    endif

    redraw!
endfunction

nnoremap <buffer> <silent> <leader>A :call <sid>AddMuttAttacments()<cr>
