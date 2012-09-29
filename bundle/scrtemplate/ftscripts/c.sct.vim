let s:filename = expand('<afile>')
let s:ext = fnamemodify(s:filename, ':e')

if s:ext == 'h'
    " for header files
    call AddHeaderGuard()
    finish
endif

" for source files
let s:withoutext = fnamemodify(s:filename, ':t:r')
let s:hdrname = s:withoutext.'.h'
if findfile(s:hdrname) != ''
    0put = '#include \"'.s:hdrname.'\"'
    let s:fullPath = fnamemodify(s:filename, ':p:h').'/'.s:hdrname
    silent! $put = GetIncludesIn(s:fullPath)
    $put = ''
    $put = ''
    normal G
endif

call AddHeaderAndFooter()
