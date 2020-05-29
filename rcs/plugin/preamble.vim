" minimum number of lines to fold
let g:preamble_min_lines = 3

" list of files to fold preamble in
try
    call Preamble#Enable('c,cpp,csharp,python,perl,php')
catch /E117:/
endtry
