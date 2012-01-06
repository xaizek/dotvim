" Name:        qthelp
" Author:      xaizek (xaizek@gmail.com)
" Version:     1.0.0
"
" Description: This plugin would allow you to open Qt help pages in browser
"              from your C++ source code. Currently it can show help if the word
"              underneath your cursor is a class name, a variable name or a
"              class-member name.
"
" Examples:    QStr|ing trackTitle, artistName;
"              QString track|Title, artistName("Unknown");
"              track|Title = "Unknown";
"              Running command :QHelpOnThis will open help on QString.
"
"              trackTitle.ri|ght(10);
"              Running command :QHelpOnThis will open help on QString::right.
"
"              Running command :QHelp QPixmap::QPixmap will open help on
"              QPixmap constructor.
"
" Configuring: g:qthelp_browser - command to run your browser
"              default: '' (so an error message will be printed if your try to
"                           use plugin)
"              Note: on Windows use something like (notice 'start' at the
"                    beginning)
"                    'start c:\Program files\Mozilla Firefox\firefox.exe'
"                    or Vim will be waiting until you close your browser.
"
" Using:       1. Make tags-file for your html-qthelp.
"              2. Add that tags-file into your 'tags' option (WARNING: doing
"                 this in your .vimrc file can slow down and pollute completion
"                 list for not Qt-projects).
"              3. Setup g:qthelp_browser variable with the command to run your
"                 browser.
"              4. Map command QHelpOnThis on some hotkey.
"              5. Use QHelp from command-line for faster navigating through
"                 help (to escape manual searching of needed section).
"
" Limitation:  I didn't found a way to determine inheritance hierarchy using
"              tags so trying
"              QStringList strlst;
"              strlst.in|sert("String");
"              will open reference for QString, not for QList::insert.
"
" Warning:     In some cases it can take a while for searching definition (for
"              example when it doesn't exist) if this happens hit Ctrl-C to
"              break searching.
"
" ToDo:        - Maybe it should look for declaration not only in one header
"                file ("companion"), but in all included from this?
"              - Is there a way to determine variable type without regexps?

if exists("g:loaded_qthelp")
    finish
endif

let g:loaded_gthelp = 1

if !exists('g:qthelp_browser')
    let g:qthelp_browser = ''
endif

" boolean for switching debug output
let s:debugging = 0

" regexps, as you can see
let s:idregex = '\%(\<const\>\)\?'.'[_a-zA-Z][_a-zA-Z0-9]*'.'\%(\<const\>\)\?'
let s:nsregex = '\%('.s:idregex.'::\)*'
let s:numregex = '[0-9]\+'
let s:varpfxregex = '\s*&\?\s*\%(\*\s*\)*'
let s:varsfxregex = '\s*\%('.
            \'\%(([^)]*)\)'.
            \'\|'.
            \'\%(\['.s:numregex.'\]\)'.
            \'\)\?'
let s:varregex = s:varpfxregex.s:idregex.s:varsfxregex
let s:varlstregex = '\%('.s:varregex.'\s*\%(,\s*\)\?\)*'
let s:typeregex = '^\s*\%(const\s\+\)\?'.s:nsregex.'\zs'.s:idregex.'\ze'
                 \.'\%(<.*>\)\?'.s:varpfxregex.'\s\+'

" buffer variables
" b:membername
" b:foundinfile
" b:foundatline

" commands definition
command! -nargs=0 QHelpOnThis call QHHelp('')
command! -nargs=1 QHelp call QHHelp('<args>')

" the main function
" cword parameter is what we want to get help on or '' for analyzing word
" underneath the cursor
function! QHHelp(query)
    call s:QHDebug('QHDBG: QHHelp(cword="'.a:query.'")')
    if a:query != ''
        let l:lst = s:QHGetTagsList(a:query)
    else
        let l:lst = s:QHGetTagsListUC()
    endif

    if len(l:lst) == 0
        call s:QHTellUser("Nothing was found")
    else
        call s:QHDebug('QHDBG: QHHelp, filename="'.l:lst[0]['filename'].'"')
        call <SID>QHOpenBrowser(l:lst[0]['filename'])
    endif
endfunction

" determines if a class name, a variable name or a class member name is
" underneath the cursor and returns appropriate taglist
function! s:QHGetTagsListUC()
    " wuc is for Word Underneath the Cursor
    let l:wuc = expand('<cword>')
    let l:lst = taglist('//apple_ref/cpp/cl//'.l:wuc.'$')
    if len(l:lst) == 0  " if WUC is var_name
        let [l:class, b:membername] = QHGetVUCInfo()
        if b:membername == ''
            let l:lst = taglist('//apple_ref/cpp/cl//'.l:class.'$')
        else
            let l:lst = s:QHGetTagsListOnMember(l:class, b:membername)
            if len(l:lst) == 0
                let b:membername = ''
                let l:lst = taglist('//apple_ref/cpp/cl//'.l:class.'$')
            endif
        endif
    else
        let b:membername = ''
    endif
    return l:lst
endfunction

" b:membername should be set before calling this function because one should
" modify it last
function! s:QHGetTagsListOnMember(class, member)
    let l:lst = taglist('^'.a:member.'-typedef$')
    if len(l:lst) != 0
        let b:membername = a:member.'-typedef'
        return l:lst
    endif
    let l:lst = taglist('^'.a:member.'-enum$')
    if len(l:lst) != 0
        let b:membername = a:member.'-enum'
        return l:lst
    endif

    if len(l:lst) == 0
        let l:lst = taglist('//apple_ref/cpp/clm/'.a:class.'/'.a:member.'$')
    endif
    if len(l:lst) == 0
        let l:lst = taglist('//apple_ref/cpp/instm/'.a:class.'/'.a:member.'$')
    endif
    if len(l:lst) == 0
        let l:lst = taglist('//apple_ref/cpp/econst/'.a:class.'/'.a:member.'$')
    endif
    if len(l:lst) == 0
        let l:lst = taglist('//apple_ref/cpp/tag/'.a:class.'/'.a:member.'$')
    endif
    return l:lst
endfunction

" analyses query for class name or class name and its member name
function! s:QHGetTagsList(query)
    call s:QHDebug('QHDBG: QHGetTagsList(query="'.a:query.'")')
    let l:lst = []

    let l:regex = '\('.s:idregex.'\)::\('.s:idregex.'\)'
    if matchstr(a:query, l:regex) != ''
        let l:class = substitute(a:query, l:regex, '\1', '')
        call s:QHDebug('QHDBG: QHGetTagsList, class="'.l:class.'"')
        let l:member = substitute(a:query, l:regex, '\2', '')
        call s:QHDebug('QHDBG: QHGetTagsList, member="'.l:member.'"')
        let l:lst = taglist('//apple_ref/cpp/clm/'.l:class.'/'.l:member.'$')
        if len(l:lst) == 0
            let l:lst = taglist('//apple_ref/cpp/instm/'
                               \.l:class.'/'.l:member.'$')
        endif
        if len(l:lst) == 0
            let l:lst = taglist('//apple_ref/cpp/tag/'
                               \.l:class.'/'.l:member.'$')
        endif
        let b:membername = l:member
    else
        let l:lst = taglist('//apple_ref/cpp/cl//'.a:query.'$')
        let b:membername = ''
    endif

    return l:lst
endfunction

" opens users browser
function! s:QHOpenBrowser(file)
    if s:debugging == 1
        return
    endif
    let l:browserargs = 'file://'.fnamemodify(a:file, ':p')
    if b:membername != ''
        let l:browserargs = l:browserargs.'\#'.b:membername
    endif
    let l:browserargs = shellescape(l:browserargs)
    if !has('win32') && !has('win64')
        let l:browserargs = l:browserargs.'&'
    endif
    try
        exe ":silent !".shellescape(g:qthelp_browser)." ".l:browserargs
    catch 'E484'
        call s:QHTellUser('An error occuried while running your browser. '
                        \.'Maybe your g:qthelp_browser option is incorrect.')
    endtry
endfunction

" lets tell user about what we have found
function! s:QHInformUser(varname, class, membername)
    let l:msg = a:class
    if a:membername != ''
        let l:msg = l:msg.'::'
    endif
    if a:varname != ''
        let l:msg = a:varname.' ('.l:msg.')'
    endif
    if b:foundinfile != ''
        let l:msg = l:msg.'; was found in '.b:foundinfile
                   \.' at line '.b:foundatline
    endif
    call s:QHTellUser(l:msg)
endfunction

" prints some message to a user to let him know what are we doing
function! s:QHTellUser(msg)
    execute 'echomsg("QtHelp: '.escape(a:msg, '"').'")'
endfunction

" prints debug message
function! s:QHDebug(msg)
    if s:debugging == 1
        execute 'echomsg("QtHelp: '.escape(a:msg, '"').'")'
    endif
endfunction

" ------------------------------------------------------------------------------
" stuff below is for analyzing code --------------------------------------------
" ------------------------------------------------------------------------------

" returns list with information about Variable Underneath the Cursor in form of
" [classname, membername]
function! QHGetVUCInfo()
    let l:wuc = expand('<cword>')
    let l:wuctype = s:QHGetWUCType(wuc)
    if l:wuctype == 0 " we're assuming that this is varname
        let l:varname = s:QHGetVarType(l:wuc)
        if l:varname == ''
            return [l:wuc, '']
        else
            return [l:varname, '']
        endif
    elseif l:wuctype == 1
        return [s:QHGetNSName(l:wuc), l:wuc]
    elseif l:wuctype == 2
        return [s:QHGetVarType(s:QHGetVarName(l:wuc)), l:wuc]
    elseif l:wuctype == 3
        return [l:wuc, '']
    endif
endfunction

" this function searches for variable definition in current file and header
" file if the current one is a source
function! s:QHGetVarType(varname)
    let b:foundatline = line('.')

    " firstly lets try to find declaration in current file
    " simple case
    let l:type = s:QHSearchSimpleVarDef(a:varname)
    if l:type != ''
        call s:QHDebug('QHDBG: Simple definition search succesed')
        return l:type
    endif
    " more complex
    let l:type = s:QHSearchComplexVarDef(a:varname)
    if l:type != ''
        call s:QHDebug('QHDBG: Complex definition search succesed')
        return l:type
    endif

    " try to find variable in function declaration
    let l:type = s:QHSearchVarDefInArgs(a:varname)
    if l:type != ''
        call s:QHDebug('QHDBG: Arg search succesed')
        return l:type
    endif

    " and now lets take a look at the header if it exists
    if expand('%:e') == 'cpp'
        if filereadable(expand('%:r').'.hpp')
            return s:QHSearchVarDefInFile(a:varname, expand('%:r').'.hpp')
        elseif filereadable(expand('%:r').'.h')
            return s:QHSearchVarDefInFile(a:varname, expand('%:r').'.h')
        else
            call s:QHDebug('QHDBG: QHGetVarType, cant find companion file')
            return ''
        endif
    endif

    return ''
endfunction

" searches for simple declaration of varname above cursor position
function! s:QHSearchSimpleVarDef(varname)
    let l:sdefregex = '\<'.s:nsregex.s:idregex.'\>'.'\%(<.*>\)\?'.'[^,()=]\+'
                    \.'\<'.a:varname.'\>[^&]'
    let l:lnum = search(l:sdefregex, 'bcnW')
    if l:lnum > 0
        let l:type = matchstr(matchstr(getline(l:lnum), l:sdefregex)
                             \, s:typeregex)
        if l:type != 'delete'
            let b:foundinfile = 'this file'
            let b:foundatline = l:lnum
            return l:type
        endif
    endif
endfunction

" searches for complex declaration of varname above cursor position
function! s:QHSearchComplexVarDef(varname)
    let l:defregex = '\s*'.s:nsregex.s:idregex.'\s\+'
                 \.s:varlstregex.s:varpfxregex.a:varname.s:varsfxregex
                 \.'\%(<.*>\)\?\s*\%(;\|,\|\%(=\)\)'
    let l:lnum = search(l:defregex, 'bcnW')
    if l:lnum > 0
        call s:QHDebug('QHDBG: QHGetVarType, lnum="'.l:lnum.'"')
        let l:type = matchstr(getline(l:lnum), s:typeregex)
        if l:type != 'delete'
            let b:foundinfile = 'this file'
            let b:foundatline = l:lnum
            return l:type
        else
            " continue the search but without search() to escape moving cursor
            for l:l in range(l:lnum - 1, 1, -1)
                let l:type = matchstr(getline(l:l), l:defregex)
                if l:type != '' && l:type != 'delete'
                    let b:foundinfile = 'this file'
                    let b:foundatline = l:l
                    return l:type
                endif
            endfor
        endif
    endif
endfunction

" searches for declaration of varname in argument list of current function
function! s:QHSearchVarDefInArgs(varname)
    let l:argdefregex = '[(,]\s*\%(const\)\?'.s:nsregex.s:idregex.s:varpfxregex
                   \.'\s\+'.a:varname.s:varsfxregex.'\s*[,)]\?'
    let l:stoplnum = search('^}', 'bcnW')
    let l:lnum = search(l:argdefregex, 'bcnW', l:stoplnum + 1)
    if l:lnum > 0
        let b:foundinfile = 'this file'
        let b:foundatline = l:lnum
        return matchstr(getline(l:lnum), l:argdefregex, 'bcnW')
    endif
    return ''
endfunction

" searches for declaration of varname in file filename
function! s:QHSearchVarDefInFile(varname, filename)
    let l:defregex = '^\s*'.s:nsregex.s:idregex.'\>.*\<'.a:varname.'\>'
    let l:headerfile = readfile(a:filename)
    let l:lnum = 0
    for l:line in l:headerfile
        let l:definition = matchstr(l:line, l:defregex)
        if l:definition != ''
            let b:foundinfile = a:filename
            let b:foundatline = l:lnum
            return matchstr(l:line, s:typeregex)
        endif
        let l:lnum = l:lnum + 1
    endfor
    return ''
endfunction

" returns variable name that goes right before the cursor
function! s:QHGetVarName(funcname)
    let [l:line, l:col] = searchpos(expand('<cword>'), 'bcn')
    let l:varname = matchstr(getline('.'),
                \ s:idregex.'\ze\%(\.\|->\)\%'.l:col.'c'.a:funcname)
    return l:varname
endfunction

" returns namespace name that goes right before the cursor
function! s:QHGetNSName(funcname)
    let [l:line, l:col] = searchpos(expand('<cword>'), 'bcn')
    let l:varname = matchstr(getline('.'),
                \ s:idregex.'\ze::\%'.l:col.'c'.a:funcname)
    return l:varname
endfunction

" analyses what is before the wuc and returns:
" - 0 for class_n|ame or va|r_name
" - 1 for class_name::mem|ber_name
" - 2 for var_name.mem|ber_name or var_name->me|mber_name
" - 3 for class_n|ame
function! s:QHGetWUCType(wuc)
    let [l:line, l:col] = searchpos(a:wuc, 'bcn')
    let l:pref = matchstr(getline('.'),
                        \ s:idregex.'\zs\%(::\|\.\|->\)\ze\%'.l:col.'c'
                        \ .a:wuc)
    let l:suf = matchstr(getline('.'),
                        \ '\%'.l:col.'c'
                        \ .a:wuc.'\zs\%(::\|\.\|->\)\ze'.s:idregex)
    if l:pref == '.' || l:pref == '->'
        return 2
    elseif l:pref == '::'
        return 1
    elseif l:suf == '::'
        return 3
    else
        return 0
    endif
endfunction

" vim: set foldmethod=syntax foldlevel=0 :miv "
