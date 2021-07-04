" This implementation formats textual tabs trying to keep tip of the current tab
" visible at all times and providing indication of how many tab tips were
" hidden.  It looks like this:
"
" [+2][3:~/r/v/s/u/str.h] [4:~/r/v/s/u/str.c] [5:~/r/v/s/c/os.h][+4]          X

" formats tab line
function! libui#tabs#TabLine()
    let ctab = tabpagenr() - 1
    let ntabs = tabpagenr('$')

    let labels = []
    for i in range(ntabs)
        call add(labels, s:TabLabel(i + 1))
    endfor

    let s = s:WrapTabLabel(labels[ctab], 1, ctab)
    let left = &columns - len(s) - 1
    let l = ctab - 1
    let r = ctab + 1
    while left > 0 && (l >= 0 || r < ntabs)
        let oldl = l
        let oldr = r

        if l >= 0 && left >= len(labels[l])
            let s = s:WrapTabLabel(labels[l], 0, l) . ' ' . s
            let left -= len(labels[l])
            let l -= 1
        endif
        if r < ntabs && left >= len(labels[r])
            let s .= '%* ' . s:WrapTabLabel(labels[r], 0, r)
            let left -= len(labels[r])
            let r += 1
        endif

        if oldl == l && oldr == r
            break
        endif
    endwhile

    if l >= 0
        let s = '[+' . (l + 1) . ']' . s
    endif
    if r < ntabs
        let s .= '%*[+' . (ntabs - r) . ']'
    endif

    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'

    " right-align the label to close the current tab page
    if ntabs > 1
        let s .= '%=%#TabLine#%999XX'
    endif

    return s
endfunction

" adds macros around the label
function! s:WrapTabLabel(lbl, iscurrent, idx)
    " select the highlighting
    let hl = a:iscurrent ? '%#TabLineSel#' : '%#TabLine#'

    " set the tab page id (for mouse clicks)
    return hl . '%' . (a:idx + 1) . 'T' . a:lbl
endfunction

" formats tab label
function! s:TabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let l = pathshorten(expand('#'.buflist[winnr - 1].':p:~'))
    if empty(l)
        let l = 'No Name'
    endif
    if getbufvar(buflist[winnr - 1], '&modified')
        let l .= '|+'
    endif
    if len(buflist) > 1
        let l = len(buflist).'w|'.l
    endif
    return '['.a:n.':'.l.']'
endfunction
