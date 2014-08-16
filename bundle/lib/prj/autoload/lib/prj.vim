" sources configuration file for a project
function! lib#prj#Do(scrfile)
    let l:scr = findfile(a:scrfile, '.;')
    if !empty(l:scr) && filereadable(l:scr)
        execute 'source '.escape(l:scr, ' ')
    endif
endfunction

function! lib#prj#GetRoot()
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
