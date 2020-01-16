let s:filename = expand('<afile>')
let s:ext = fnamemodify(s:filename, ':e')

" for header files
if s:ext == 'h'
    " let configuration set file specific variables
    call lib#prj#Do('.in.vim')

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
