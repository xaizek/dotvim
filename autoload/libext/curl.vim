" obtains title of a page at url via curl
function! libext#curl#GetPageTitle(url)
    let l:sedcmd = 's/.*<title.*>\([^<>]*\)<\/title>.*/\1/i'
    let l:cmd = "curl -s '".a:url."' | tr -d '\\n' | egrep '<\\s*title' | sed '".l:sedcmd."' | tr -d '\\n'"
    silent! let l:title = system(l:cmd)
    return l:title
endfunction
