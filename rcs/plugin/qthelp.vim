if has('win32')
    let g:qthelp_browser = 'start '
                         \.'e:\programs\internet\Mozilla Firefox\firefox.exe'
else
    let g:qthelp_browser = 'dwb'
endif

let g:qthelp_tags='/mnt/data/programming/libs/qt/4.6.3/doc/html/tags'

" show help on Qt classes
nnoremap <silent> <leader>q :QHelpOnThis<cr>
