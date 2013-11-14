" ~/.vim/bundle/vifm/ftplugin/mail.vim

" mutt: insert attachment
function! s:RangerMuttAttach()
    if has('gui')
        silent !xterm -e 'vifm -f'
    else
        silent !vifm -f
    endif
    let l:path = expand('$HOME/.vifm/vimfiles')
    if filereadable(l:path)
        exec 'read' l:path
    endif
    redraw!
endfunction
nnoremap <buffer> <leader>A magg/Reply-To<cr><esc>:call <sid>RangerMuttAttach()<cr>IAttach: <esc>`a
