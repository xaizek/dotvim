" return path to root of data directories
function! libcfg#cfg#GetVimStorageDir()
    return fnamemodify($MYVIMRC, ':p:h').'/data/'
endfunction

" return path to existing storage directory with specified name
function! libcfg#cfg#CreateVimStorageDir(name)
    let l:path = libcfg#cfg#GetVimStorageDir().'/'.a:name

    call libfs#fs#EnsureDirExists(l:path)

    return l:path
endfunction
