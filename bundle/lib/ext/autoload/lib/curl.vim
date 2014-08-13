" obtains title of a page at url via curl
function! lib#curl#GetPageTitle(url)
    let l:sedcmd = 's/.*<title.*>\(.*\)<\/title>.*/\1/i;'
    let l:cmd = "curl -s '".a:url."' | tr -dc '[:print:]' | sed '".l:sedcmd."'"
    silent! let l:title = system(l:cmd)
    return l:title
endfunction
