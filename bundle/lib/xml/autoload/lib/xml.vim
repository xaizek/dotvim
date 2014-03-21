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
        call lib#xml#ExpandOneLineXML()
    else
        call lib#xml#FoldToOneLineXML()
    endif
endfunction
