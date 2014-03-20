function! lib#xml#ExpandOneLineXML()
    substitute/>/>\r/g
    %substitute/\S\zs</\r</
    normal gg=GGdd
endfunction

function! lib#xml#FoldToOneLineXML()
    %substitute/^\s\+//
    %substitute/\n//
endfunction

function! lib#xml#ToggleOneLineXML()
    if line('$') == 1
        call lib#xml#FoldToOneLineXML()
    else
        call lib#xml#ExpandOneLineXML()
    endif
endfunction
