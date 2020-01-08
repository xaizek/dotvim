" query title of page at URL in the current line (whole line) and insert it one
" line above
function! libedit#url#QueryURLTitle()
    let l:url = getline('.')
    let l:title = libext#curl#GetPageTitle(l:url)
    call append(line('.') - 1, l:title)
endfunction
