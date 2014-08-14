" convert end of lines in the current buffer to Unix style
function! lib#eols#ToUnix()
    edit ++ff=dos
    set ff=unix
    w
endfunction
