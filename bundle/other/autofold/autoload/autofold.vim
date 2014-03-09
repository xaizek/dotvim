function! autofold#foldexpr()
    if v:lnum == 1
        return 0
    endif

    let [l:prevLine, l:thisLine] = getline(v:lnum - 1, v:lnum)

    let l:prevChar = l:prevLine[2]
    let l:thisChar = l:thisLine[2]

    if l:prevChar ==# '=' || l:thisChar ==# '='
        if s:Matches(l:prevLine)
            return l:thisLine[0] ==# l:prevLine[0] ? 'a1' : '='
        elseif s:Matches(l:thisLine)
            return 0
        endif
    elseif l:prevChar ==# '-' || l:thisChar ==# '-'
        if s:Matches(l:prevLine)
            return l:thisLine[0] ==# l:prevLine[0] ? 'a1' : '='
        elseif s:Matches(l:thisLine)
            let farPrevChar = getline(v:lnum - 3)[2]
            return farPrevChar ==# '=' ? '=' : 's1'
        endif
    endif

    return '='
endfunction

function! s:Matches(line)
    " test whether line matches /^. .\{78\}$/
    return len(a:line) == &textwidth && a:line[1] ==# ' '
      \ && a:line[2:] ==# repeat(a:line[2], &textwidth - 2)
endfunction
