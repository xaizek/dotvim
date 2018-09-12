function! lib#tags#UpdateTags()
    " don't try to write to non-accessible directories, e.g. to fugitive:///...
    if filewritable(expand('%:p:h')) != 2
        return
    endif

    let l:tags = findfile('tags', '.;')
    if l:tags == ''
        return
    endif

    let l:tagsfile = fnamemodify(l:tags, ':p')
    let l:srcdir = fnamemodify(l:tagsfile, ':h')

    " account for fake paths like fugitive:///...
    if !filereadable(l:srcdir)
        return
    endif

    " do not write all modified buffers on :!
    let l:autowrite_saved = &l:autowrite
    setlocal noautowrite

    let l:olddir = getcwd()
    execute 'silent! lcd '.escape(l:srcdir, ' ')

    if empty(readfile(l:tagsfile))
        let l:pathtoscan = l:srcdir
    else
        if has('win32')
            let l:pathtoscan = l:olddir[2 + strlen(l:srcdir) - 1:]
        else
            let l:pathtoscan = l:olddir[strlen(l:srcdir) + 1:]
        endif
    endif

    if has('win32')
        execute 'silent !start /b ctags -R -a --c++-kinds=+p '
                    \.'--tag-relative=yes --fields=+iaS --extra=+q '
                    \.l:pathtoscan
    else
        execute 'silent !flock '
              \.shellescape(l:tagsfile)
              \.' ctags -R -a --tag-relative=yes -f '
              \.shellescape(l:tagsfile)
              \.' --c++-kinds=+p --fields=+iaS --extra=+q '
              \.l:pathtoscan
              \.'&'
    endif
    execute 'silent! lcd '.escape(l:olddir, ' ')

    let &l:autowrite = l:autowrite_saved
endfunction
