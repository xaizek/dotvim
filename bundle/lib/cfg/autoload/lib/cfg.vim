function! lib#cfg#CreateVimStorageDir(name)
    let l:path = fnamemodify($MYVIMRC, ':p:h').'/data/'.a:name

    call lib#fs#EnsureDirExists(l:path)

    return l:path
endfunction
