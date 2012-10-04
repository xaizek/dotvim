nnoremap <silent><buffer> ]] :call <SID>FindBegin(1)<cr>
nnoremap <silent><buffer> [[ :call <SID>FindBegin(0)<cr>

function! <SID>FindBegin(forward)
    if a:forward
        let l:forward = ''
    else
        let l:forward = 'b'
    endif
    let l:openbracket = search('^\S', 'nW'.l:forward)
    if l:openbracket != 0
        call cursor(l:openbracket, 1)
    else
        call cursor(a:forward ? line('$') : 1, 1)
    endif
endfunction
