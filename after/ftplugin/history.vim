" Vim filetype plugin file
" Language:     History
" Maintainer:   xaizek
" Last Change:  

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif

" Don't load another plugin for this buffer
let b:did_ftplugin = 1

let b:undo_ftplugin = 'setlocal tabstop< softtabstop< expandtab< textwidth<'

setlocal tabstop=2
setlocal softtabstop=2
setlocal expandtab
setlocal textwidth=80

normal G
