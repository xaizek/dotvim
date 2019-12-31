" Name:            autoexec
" Author:          xaizek <xaizek@posteo.net>
" License:         Same terms as Vim itself (see :help license)

function! autoexec#SystemSupportsExecutableBit()
    return !has('win32')
endfunction

function! autoexec#FileSupportsExecutableBit()
    return getline(1) =~ '^#!'
endfunction

function! autoexec#SetExecutableBit()
    let l:fname = expand('%:p')
    checktime
    execute 'autocmd FileChangedShell' fname ':echo'
    silent !chmod a+x %
    checktime
    execute 'autocmd! FileChangedShell' fname
endfunction

function! autoexec#SetExecutable()
    if !autoexec#SystemSupportsExecutableBit()
        return
    endif
    if !autoexec#FileSupportsExecutableBit()
        return
    endif
    call autoexec#SetExecutableBit()
endfunction
