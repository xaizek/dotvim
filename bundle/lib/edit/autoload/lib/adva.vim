nnoremap ZA A

" A that considers indentation level
function! lib#adva#AdvancedA()
    let l:prev_indent = indent(line('.') - 1)
    let l:indent_diff = l:prev_indent - indent(line('.'))
    let l:is_empty = len(getline('.')) == 0
    if l:indent_diff >= 0 && l:is_empty
        return '"_ddko'
    elseif l:is_empty
        return 'I'
    else
        return 'ZA'
    endif
endfunction
