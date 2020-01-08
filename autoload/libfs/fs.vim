function! libfs#fs#EnsureDirExists(path)
    if !isdirectory(a:path)
        call mkdir(a:path, 'p')
    endif
endfunction
