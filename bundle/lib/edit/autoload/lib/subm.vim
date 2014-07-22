" substitute {motion} text with content of default register
function! lib#subm#SubstituteMotion(type, ...)
    if a:0  " Invoked from Visual mode, use '< and '> marks.
        silent exe "normal! `<" . a:type . "`>\"_c\<c-r>\"\<esc>"
    elseif a:type == 'line'
        silent exe "normal! '[V']\"_c\<c-r>\"\<esc>"
    elseif a:type == 'block'
        silent exe "normal! `[\<C-V>`]\"_c\<c-r>\"\<esc>"
    else
        silent exe "normal! `[v`]\"_c\<c-r>\"\<esc>"
    endif
endfunction
