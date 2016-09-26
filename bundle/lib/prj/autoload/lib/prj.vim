" sources configuration file for a project
function! lib#prj#Do(scrfile)
    let l:scr = findfile(a:scrfile, '.;')
    if !empty(l:scr) && filereadable(l:scr)
        execute 'source '.escape(l:scr, ' ')
    endif
endfunction

command! LibPrjDoNext call lib#prj#DoNext(expand('<sfile>'))
function! lib#prj#DoNext(scrfile)
    let l:scrfile = fnamemodify(a:scrfile, ':t')
    let l:findspec = fnamemodify(a:scrfile, ':p:h:h').';'
    let l:scr = findfile(l:scrfile, l:findspec)
    if !empty(l:scr) && filereadable(l:scr)
        execute 'source '.escape(l:scr, ' ')
    endif
endfunction

function! lib#prj#GetRoot()
    if exists('b:project_root')
        return b:project_root
    endif

    let l:parts = split(getcwd(), '/')
    let l:pos = index(l:parts, 'src', 0, has('win32'))
    if l:pos >= 0
        let l:result = join(l:parts[:l:pos], '/')
        if !has('win32')
            let l:result = '/'.l:result
        endif
    else
        let l:result = '.'
    endif
    return l:result
endfunction
