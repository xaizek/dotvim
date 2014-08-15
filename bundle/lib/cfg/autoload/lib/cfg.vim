" return path to root of data directories
function! lib#cfg#GetVimStorageDir()
    return fnamemodify($MYVIMRC, ':p:h').'/data/'
endfunction

" return path to existing storage directory with specified name
function! lib#cfg#CreateVimStorageDir(name)
    let l:path = lib#cfg#GetVimStorageDir().'/'.a:name

    call lib#fs#EnsureDirExists(l:path)

    return l:path
endfunction
