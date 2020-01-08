" formats tab line
function! libui#tabs#TabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        " select the highlighting
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif

        " set the tab page $1(for mouse clicks)
        let s .= '%' . (i + 1) . 'T'

        " the label is made by TabLabel()
        let s .= ' %{libui#tabs#TabLabel(' . (i + 1) . ')} '
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'

    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999XX'
    endif

    return s
endfunction

" formats tab label
function! libui#tabs#TabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let l = pathshorten(expand('#'.buflist[winnr - 1].':p:~'))
    if l == ""
        let l = "No Name"
    endif
    if getbufvar(buflist[winnr - 1], "&modified")
        let l .= ' [+]'
    endif
    if len(buflist) > 1
        let l = len(buflist).'w '.l
    endif
    return '['.a:n.':'.l.']'
endfunction
