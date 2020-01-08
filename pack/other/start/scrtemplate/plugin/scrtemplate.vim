if exists('g:loaded_scrtemplate')
    finish
endif
let g:loaded_scrtemplate = 1

augroup scrtemplate
    autocmd!
    autocmd FileType * call s:LoadFTScript()
augroup end

function! s:LoadFTScript()
    if line2byte(line('$') + 1) != -1
        return
    endif

    let l:type = expand('<amatch>')
    let l:sct = findfile('ftscripts/'.l:type.'.sct.vim', &runtimepath)
    if l:sct != ""
        execute 'source' l:sct
    endif
endfunction
