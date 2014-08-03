function! lib#hl#Highlight(before, what, after)
    if empty(a:what)
        echohl WarningMsg | echo 'No string under the cursor.' | echohl None
        return
    end

    let l:escapedWord = escape(a:what, '()[]~\')
    " Need to do this again because it will be used inside double quoted string
    let l:escapedWord = escape(l:escapedWord, '\')
    " Escape double quote after escaping slash
    let l:escapedWord = escape(l:escapedWord, '"')
    execute a:before.l:escapedWord.a:after
    echo 'Highlighting: '.a:what
endfunction
