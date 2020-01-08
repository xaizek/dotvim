nnoremap ZA A

" A that considers indentation level
function! libedit#adva#AdvancedA()
    let l:prev_indent = indent(line('.') - 1)
    let l:indent_diff = l:prev_indent - indent(line('.'))
    let l:is_empty = len(getline('.')) == 0
    if l:indent_diff >= 0 && l:is_empty
        if line('$') == line('.')
            " no need to go up after removing the last line
            return '"_ddo'
        else
            return '"_ddko'
        endif
    elseif l:is_empty
        return 'I'
    else
        return 'ZA'
    endif
endfunction
