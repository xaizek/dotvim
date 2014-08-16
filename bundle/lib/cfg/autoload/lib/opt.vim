" toggles 'hlsearch' option and prints out its new state
function! lib#opt#ToggleHlsearch()
    set hlsearch!
    if &hlsearch
        echo 'Search results highlighting is ON'
    else
        echo 'Search results highlighting is OFF'
    endif
endfunction

" toggles 'spell' option and prints out its new state
function! lib#opt#ToggleSpell()
    setlocal spell!
    if &l:spell
        echo 'Spell checking is ON'
    else
        echo 'Spell checking is OFF'
    endif
endfunction
