" move tab to [count] tab position, if [count] is present
function libaction#CountTabMove()
    if v:count == 0
        return 'gT'
    endif

    let ret = ":\<C-u>tabmove "
    if v:count > tabpagenr('$')
        let ret .= tabpagenr('$')
    elseif v:count >= tabpagenr()
        let ret .= v:count
    elseif v:count < tabpagenr()
        let ret .= v:count - 1
    endif
    let ret .= "\<CR>"
    return ret
endfunction
