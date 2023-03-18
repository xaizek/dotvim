nnoremap <silent><buffer> ]] :call <SID>FindBegin(1)<cr>
nnoremap <silent><buffer> [[ :call <SID>FindBegin(0)<cr>
nnoremap <silent><buffer> ][ :call <SID>FindEnd(1)<cr>
nnoremap <silent><buffer> [] :call <SID>FindEnd(0)<cr>

function! <SID>FindBegin(forward)
    if a:forward
        let l:forward = ''
    else
        let l:forward = 'b'
    endif
    let l:openbracket = search('^\s*{\s*$', 'nW'.l:forward)
    if l:openbracket != -1
        call cursor(l:openbracket, col('.'))
    endif
endfunction

function! <SID>FindEnd(forward)
    if a:forward
        let l:forward = ''
    else
        let l:forward = 'b'
    endif
    let l:openBracket = search('^\s*{\s*$', 'nbcW')
    let l:closeBracket = search('^\s*}\s*$', 'sW'.l:forward)
    let l:openBracketIndent = indent(l:openBracket)
    while l:closeBracket != 1
        if indent(l:closeBracket) == l:openBracketIndent
            call cursor(l:closeBracket, col('.'))
            return
        endif
        let l:closeBracket = search('^\s*}\s*$', 'W'.l:forward)
    endwhile
    normal ''
endfunction
