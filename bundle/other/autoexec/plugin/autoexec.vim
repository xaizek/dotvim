" Name:            autoexec
" Author:          xaizek <xaizek@posteo.net>
" License:         Same terms as Vim itself (see :help license)

augroup autoexec
    autocmd!
    autocmd BufWritePost * call autoexec#SetExecutable()
augroup END
