" convert end of lines in the current buffer to Unix style
function! libedit#eols#ToUnix()
    edit ++ff=dos
    set ff=unix
    w
endfunction
