augroup inccompleteautoload
    autocmd! FileType c,cpp packadd inccomplete
                         \| doautocmd inccompleteDeferredInit VimEnter
augroup end
