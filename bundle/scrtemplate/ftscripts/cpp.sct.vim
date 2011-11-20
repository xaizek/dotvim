let s:filename = expand('<afile>')
let s:ext = fnamemodify(s:filename, ':e')
let s:hdrexts = ['h', 'hpp', 'hxx', 'hh']

if index(s:hdrexts, s:ext) != -1
    " for header files
    call AddHeaderGuard()
    call AddHeaderAndFooter()
    finish
endif

" for source files
let s:withoutext = fnamemodify(s:filename, ':t:r')
let s:hdrnames = map(copy(s:hdrexts), 's:withoutext.".".v:val')
let s:found = ''
for hdrname in s:hdrnames
    if findfile(hdrname) != ''
        let s:found = hdrname
        break
    endif
endfor
if s:found != ''
    0put = '#include \"'.s:found.'\"'
    1put = ''
    normal G
endif

call AddHeaderAndFooter()
