function! onelinexml#ExpandOneLineXML()
    substitute/>/>\r/g
    %substitute/\S\zs</\r</
    normal gg=GGdd
endfunction

function! onelinexml#FoldToOneLineXML()
    %substitute/^\s\+//
    %substitute/\n//
endfunction

function! onelinexml#ToggleOneLineXML()
    if line('$') == 1
        call lib#xml#ExpandOneLineXML()
    else
        call lib#xml#FoldToOneLineXML()
    endif
endfunction
