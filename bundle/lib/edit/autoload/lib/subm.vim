" substitute {motion} text with contents of a register
function! lib#subm#SubstituteMotion(type, ...)
    let l:reg = g:substitutemotion_reg
    if a:0
        " visual mode, use '< and '> marks
        silent exe "normal! `<" . a:type . "`>\"_c\<c-r>" . l:reg . "\<esc>"
    elseif a:type == 'line'
        " linewise
        silent exe "normal! '[V']\"_c\<c-r>" . l:reg . "\<esc>"
    elseif a:type == 'block'
        " blockwise-visual
        silent exe "normal! `[\<C-V>`]\"_c\<c-r>" . l:reg . "\<esc>"
    else
        " characterwise
        silent exe "normal! `[v`]\"_c\<c-r>" . l:reg . "\<esc>"
    endif
endfunction
