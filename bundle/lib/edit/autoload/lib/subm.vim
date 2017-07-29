" substitute {motion} text with content of default register
function! lib#subm#SubstituteMotion(type, ...)
    let l:reg = g:changepaste_buffer
    if a:0  " Invoked from Visual mode, use '< and '> marks.
        silent exe "normal! `<" . a:type . "`>\"_c\<c-r>" . l:reg . "\<esc>"
    elseif a:type == 'line'
        silent exe "normal! '[V']\"_c\<c-r>" . l:reg . "\<esc>"
    elseif a:type == 'block'
        silent exe "normal! `[\<C-V>`]\"_c\<c-r>" . l:reg . "\<esc>"
    else
        silent exe "normal! `[v`]\"_c\<c-r>" . l:reg . "\<esc>"
    endif
endfunction
