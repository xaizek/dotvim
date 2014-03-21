" if a .vimrc file exists, vim will start in nocompatible mode

set encoding=utf-8

scriptencoding utf-8

" force using of English locale
if has('win32') || has('dos32')
    language english
else
    language en_US.utf-8
endif

" use comma key as <leader>
let mapleader=','

let $MYVIMRC=$HOME.'/.vim/vimrc'

" ==============================================================================
" for Pathogen plugin

if &loadplugins == 1
    filetype off
    execute pathogen#infect('bundle/*/{}')
endif

" ==============================================================================
" look&feel

" enable line numbers
set number
" number of columns for line number
set numberwidth=5

" less blinking
set lazyredraw

" show matches on command-line completion
set wildmenu

" enable syntax highlighting
if !exists("syntax_on")
    syntax on
endif

" use incremental search
set incsearch

" enable search results highlight (if search register isn't empty)
if @/ == ''
    set hlsearch
endif

" change cursor color on entering/leaving insert mode
" colors are from lucius color scheme
autocmd InsertLeave * hi Cursor guibg=#a3e3ed
autocmd InsertEnter * hi Cursor guibg=#ff0000

if has("gui_running")
    " font
    if has('win32')
        set guifont=Lucida_Console:h10:cRUSSIAN::
        if &lines < 50
            set lines=50
        endif
    else
        "set guifont=Andale\ Mono\ 12
        set guifont=Inconsolata\ 10.5
        if &lines < 62
            set lines=62
        endif
    endif

    " use different background color in insert mode
    "autocmd InsertEnter * &background="0x000000"

    " color schemes (good ones for gui: xoria256, lucius, navajo-night)
    colorscheme lucius

    " copy selection (a), show Vim icon (i), console dialogs (c)
    set guioptions=aic
else
    " enable mouse support
    set mouse="a"

    " color schemes (good ones for terminal: darkblue, desert, pablo, slate)
    if !has('dos32')
        colorscheme lucius
    endif
endif

" window size (will only make it bigger)
if &columns < 85
    set columns=85
endif

" tab line and tab labels
function! MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        " select the highlighting
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif

        " set the tab page $1(for mouse clicks)
        let s .= '%' . (i + 1) . 'T'

        " the label is made by MyTabLabel()
        let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'

    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999XX'
    endif

    return s
endfunction

function! MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let l = expand('#'.buflist[winnr - 1].':t')
    if l == ""
        let l = "No Name"
    endif
    if getbufvar(buflist[winnr - 1], "&modified")
        let l .= ' [+]'
    endif
    if len(buflist) > 1
        let l = len(buflist).'w '.l
    endif
    return '['.a:n.':'.l.']'
endfunction
set tabline=%!MyTabLine()

" show tab line always
set showtabline=2

" don't use conceal feature in cpp and c files
autocmd FileType cpp,c set concealcursor=in|set conceallevel=0

" preserve window view (to do not reset relative top line and relative position
" of the cursor) when switching buffers (see tip 1375 on Vim Wiki)
" autocmd BufLeave * if !&diff | let b:winview = winsaveview() | endif
" autocmd BufEnter * if exists('b:winview') && !&diff | call winrestview(b:winview) | endif

" ==============================================================================
" editing and formatting

" ------------------------------------------------------------------------------
" modification for Enter key in normal mode

" break current line into two on Enter key (except some windows)
autocmd BufReadPost,BufEnter,BufWinEnter,WinEnter  *
            \ if &filetype == 'qf' |
            \ elseif &filetype == 'vifm-cmdedit' |
            \ elseif bufname("%") == '__TagBar__' |
            \ elseif !&modifiable |
            \ elseif &readonly |
            \ else |
            \     nmap <buffer> <expr> <cr> MyEnter() |
            \ endif
function! MyEnter()
    if &filetype == 'qf'
        return "\<cr>"
    elseif bufname("%") == '__TagBar__'
        return "\<cr>"
    elseif !&modifiable
        return "\<cr>"
    elseif &readonly
        return "\<cr>"
    else
        return "i\<cr>\<esc>"
    endif
endfunction

" ------------------------------------------------------------------------------
" improved A normal mode key

nmap <expr> A MyA()
nnoremap ZA A
function! MyA()
    let l:prev_indent = indent(line('.') - 1)
    let l:indent_diff = l:prev_indent - indent(line('.'))
    let l:is_empty = len(getline('.')) == 0
    if l:indent_diff >= 0 && l:is_empty
        return 'ddko'
    elseif l:is_empty
        return 'I'
    else
        return 'ZA'
    endif
endfunction

" ------------------------------------------------------------------------------
" expand double { ("{{") as {<cr>}

inoremap <silent> { <c-r>=<SID>ExpandBracket()<cr>
function! s:ExpandBracket()
    let l:line = getline('.')
    let l:col = col('.') - 2
    if '{' == l:line[l:col]
        return "\<esc>o}\<esc>\"_O"
    endif
    return '{'
endfunction

" ------------------------------------------------------------------------------

" use unix-style eol by default
set fileformats=unix,dos

" tune backspace behaviour (indents, line start/end)
set backspace=indent,start,eol

" to make cursor pass line borders
set whichwrap=b,s,<,>,[,],l,h

" virtual editing mode
set virtualedit=all

" dollar sign for c-like commands in normal mode
set cpoptions+=$

" ignore special keys in insert mode (arrow keys, etc.) for faster leaving it
" with escape in console vim
set noesckeys

" reformat paragraph when any of its lines has been changed
" set formatoptions+=a

" remove a comment leader when joining lines
set formatoptions+=j

" go through graphical lines, not text lines
nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk

" use external command for formatting paragraphs
set formatprg=par\ -w80\ T2\ \|\ sed\ 's/\ \ /\\t/g'
"set formatprg="iconv -f UTF-8 -t WINDOWS-1251 |"
"            \."par -w80 |"
"            \."iconv -f WINDOWS-1251 -t UTF-8"

" keys to insert empty lines above/below current line in normal mode
nmap <leader>f o<esc>
nmap <leader>F O<esc>

" ==============================================================================
" programming

" ------------------------------------------------------------------------------
" for Python

" highlight more things for Python-scripts
let g:python_highlight_all=1

" ------------------------------------------------------------------------------
" for Java

autocmd Filetype java setlocal omnifunc=javacomplete#Complete

" ------------------------------------------------------------------------------
" some useful abbreviations for c and c++

autocmd FileType c,cpp execute
            \ 'iabbrev <buffer> #d #define'
autocmd FileType c,cpp execute
            \ 'iabbrev <buffer> #i #include'
autocmd FileType c,cpp execute
            \ 'iabbrev <buffer> #p #pragma'

" ------------------------------------------------------------------------------
" custom tag jumps

" on each next <c-]> press jumps to next tag with same name
nmap <silent> <c-]> :silent! call <SID>CallTagJump()<cr>

function! <SID>CallTagJump()
    if &ft == 'help'
        let l:word = expand('<cWORD>')
        let l:word = substitute(l:word, '[^\|]*|\?\([^\|]\+\)|\?[^\|]*',
                    \ '\1', '')
    else
        let l:word = expand('<cword>')
    endif
    call <SID>TagJump(l:word)
endfunction

function! <SID>TagJump(tg)
    if !exists('b:lasttag') || b:lasttag != a:tg
        let b:lasttag = a:tg
        let b:tagjumped = 0
    endif
    if b:lasttag == a:tg
        let b:tagjumped = b:tagjumped + 1
    endif
    let l:filename = expand('%:p')
    let l:linenum = line('.')
    try
        execute 'silent '.b:tagjumped.'tag '.a:tg
    catch 'E434'
        let b:tagjumped = 1
        execute 'silent '.b:tagjumped.'tag '.a:tg
    endtry
    if expand('%:p') == l:filename && line('.') == l:linenum
        let b:tagjumped = b:tagjumped + 1
        try
            execute 'silent '.b:tagjumped.'tag '.a:tg
        catch 'E434'
            let b:tagjumped = 1
            execute 'silent '.b:tagjumped.'tag '.a:tg
        endtry
    endif
    call cursor(line('.'), match(getline('.'), a:tg) + 1)
endfunction

" ------------------------------------------------------------------------------
" some kind of projects

autocmd BufEnter,BufWinEnter,WinEnter * call <SID>PrjDo('.in.vim')
autocmd BufLeave,BufWinLeave,WinLeave,BufDelete * call <SID>PrjDo('.out.vim')

function! <SID>PrjDo(scrfile)
    let l:scr = findfile(a:scrfile, '.;')
    if !empty(l:scr) && filereadable(l:scr)
        execute 'source '.escape(l:scr, ' ')
    endif
endfunction

function! GetProjectRoot()
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

" ------------------------------------------------------------------------------

" for curly braces
"autocmd BufReadPost * :call <SID>SetAutoBrackets()
"function! <SID>SetAutoBrackets()
    "if &syntax != ''
        "imap <expr> <cr> <SID>PutAutoBracket()
    "endif
"endfunction
"function! <SID>PutAutoBracket()
    "if getline(".")[col(".") - 2] == '{'
                "\ && indent(line(".") + 1) <= indent(line("."))
                "\ && len(getline(line(".") + 1)) > 0
        "return "\<cr>}\<esc>O"
    "else
        "return "\<cr>"
    "endif
"endfunction

" imap <c-space> <c-x><c-u>

" rename operations on <leader>r
nmap <leader>rr mr:silent! %s/\C\<<c-r><c-w>\>//g\|normal 'r<left><left><left>
            \<left><left><left><left><left><left><left><left><left>
nmap <leader>rf :silent! call ExecInFuncBody('s/\C\<<c-r><c-w>\>//g')<left>
            \<left><left><left>
nmap <leader>rt :silent! tabdo %s/\C\<<c-r><c-w>\>//g<left><left>
nmap <leader>rb :silent! bufdo %s/\C\<<c-r><c-w>\>//g<left><left>

" show/hide QuickFix window
"nmap <leader>c :copen<cr>
"nmap <leader>cc :cclose<cr>

" autocompletion preferences (menu even for one element and increment
" completion)
set completeopt=menuone,longest

" extends directory for tags file search (from current to root)
set tags=tags;/

" set showfulltag " cause some odd information appear

" save indentation when going to next line
set autoindent

" indentation rules
set cinoptions=g0,(0,W4

" run astyle on current file on ,a
if has('win32')
    nmap <silent> ,a :execute "silent !start /b astyle --indent=spaces=4
            \ --convert-tabs
            \ --add-brackets --brackets=stroustrup --align-pointer=type
            \ --pad-header --indent-namespaces --indent-switches
            \ --indent-preprocessor ".expand('%')<cr>:e<cr>
else
    nmap <silent> ,a :execute "silent !astyle --indent=spaces=4
            \ --convert-tabs
            \ --add-brackets --brackets=stroustrup --align-pointer=type
            \ --pad-header --indent-namespaces --indent-switches
            \ --indent-preprocessor ".expand('%')<cr>:e<cr>
endif

" for automatic tags regeneration on file write
autocmd! BufWritePost *.c,*.cpp,*.h,*.hpp call <SID>UpdateTags(expand('%'))
function! <SID>UpdateTags(changedfile)
    " don't try to write to non-accessible directories, e.g. to fugitive:///...
    if filewritable(expand('%:p:h')) != 2
        return
    endif

    let l:tags = findfile('tags', '.;')
    if l:tags != ''
        let l:tagsfile = fnamemodify(l:tags, ':p')
        let l:srcdir = fnamemodify(l:tagsfile, ':h')

        let l:olddir = getcwd()
        execute 'silent! lcd '.escape(l:srcdir, ' ')

        if empty(readfile(l:tagsfile))
            let l:pathtoscan = l:srcdir
        else
            if has('win32')
                let l:pathtoscan = l:olddir[2 + strlen(l:srcdir) - 1:]
            else
                let l:pathtoscan = l:olddir[strlen(l:srcdir) + 1:]
            endif
        endif

        if has('win32')
            execute 'silent !start /b ctags -R -a --c++-kinds=+p '
                        \.'--tag-relative=yes --fields=+iaS --extra=+q '
                        \.l:pathtoscan
        else
            call system('ctags -R -a --tag-relative=yes -f '
                        \.shellescape(l:tagsfile)
                        \.' --c++-kinds=+p --fields=+iaS --extra=+q '
                        \.l:pathtoscan
                        \.'&')
        endif
        execute 'silent! lcd '.escape(l:olddir, ' ')
    endif
endfunction

" search for word under the cursor in all c and cpp files of current directory
nnoremap <leader>g :execute 'vimgrep /\C\<'.expand('<cword>').'\>/' GetProjectRoot().'/**/*.c' GetProjectRoot().'/**/*.cpp \| cw'<cr>
nnoremap <leader>G :execute 'vimgrep /\C\<'.expand('<cword>').'\>/' GetProjectRoot().'/**/*.h' GetProjectRoot().'/**/*.hpp \| cw'<cr>
vnoremap <leader>g :<c-u>execute 'vimgrep /\C\<'.@*.'\>/' GetProjectRoot().'/**/*.c' GetProjectRoot().'/**/*.cpp \| cw'<cr>
vnoremap <leader>G :<c-u>execute 'vimgrep /\C\<'.@*.'\>/' GetProjectRoot().'/**/*.h' GetProjectRoot().'/**/*.hpp \| cw'<cr>
nnoremap <leader><leader>g :execute 'vimgrep /\C'.expand('<cword>').'/' GetProjectRoot().'/**/*.c' GetProjectRoot().'/**/*.cpp \| cw'<cr>
nnoremap <leader><leader>G :execute 'vimgrep /\C'.expand('<cword>').'/' GetProjectRoot().'/**/*.h' GetProjectRoot().'/**/*.hpp \| cw'<cr>
vnoremap <leader><leader>g :<c-u>execute 'vimgrep /\C'.@*.'/' GetProjectRoot().'/**/*.c' GetProjectRoot().'/**/*.cpp \| cw'<cr>
vnoremap <leader><leader>G :<c-u>execute 'vimgrep /\C'.@*.'/' GetProjectRoot().'/**/*.h' GetProjectRoot().'/**/*.hpp \| cw'<cr>
command! -nargs=1 -bang LookUp call s:LookUp(<q-args>, <q-bang>)

function! s:LookUp(what, with_bang)
    if a:with_bang == '!'
        let l:pattern = '\C\<'.a:what.'\>'
    else
        let l:pattern = '\C'.a:what
    endif
    try
        execute 'vimgrep /'.l:pattern.'/' s:IfAny(GetProjectRoot().'/**/*.c') s:IfAny(GetProjectRoot().'/**/*.cpp')
    catch 'E480'
        redraw
        echohl WarningMsg
        echomsg 'Nothing matching '.l:pattern.' was found.'
        echohl None
        return
    endtry
    cwindow
endfunction

function! s:IfAny(glob)
    if !empty(glob(a:glob))
        return a:glob
    endif
    return ''
endfunction

" introduce variable
nnoremap <leader>v O<c-r>.<space>=<space><c-r>";<esc>I

" ==============================================================================
" plugins

" ------------------------------------------------------------------------------
" SuperTab

let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = '<c-x><c-o>'

" ------------------------------------------------------------------------------
" ProtoDef

let g:disable_protodef_sorting = 1

" ------------------------------------------------------------------------------
" XPTemplate

" disable bracket autocompletion
let g:xptemplate_brace_complete=''

" ------------------------------------------------------------------------------
" inccomplete

if has('win32')
    let g:inccomplete_findcmd = 'e:/cygwin/bin/find'
endif

let g:inccomplete_findcmd = ''

let g:inccomplete_addclosebracket = ''

let g:inccomplete_showdirs = 1

" ------------------------------------------------------------------------------
" qthelp

if has('win32')
    let g:qthelp_browser = 'start '
                         \.'e:\programs\internet\Mozilla Firefox\firefox.exe'
else
    let g:qthelp_browser = 'firefox'
endif

" show help on Qt classes
nmap <silent> <leader>q :QHelpOnThis<cr>

" ------------------------------------------------------------------------------
" Gundo

nmap <f12> :GundoToggle<cr>

" show preview in the bottom
let g:gundo_preview_bottom=1

" ------------------------------------------------------------------------------
" clang_complete

" default options
if !has('win32')
    let g:clang_user_options = '-I/usr/local/include/'
endif

" popup Quickfix window on errors
let g:clang_complete_copen = 1

" enable autocompletion
let g:clang_complete_auto = 1

" complete macros
let g:clang_complete_macros = 1

" complete patterns
let g:clang_complete_patterns = 1

" sort completion matches in alphabetical order
let g:clang_sort_algo = ''

" use snippets
let g:clang_snippets = 1

" automatically select current match in the completion menu
let g:clang_auto_select = 1

" use clang library
let g:clang_use_library = 1

" specify path to clang library
let g:clang_library_path = $HOME.'/bin/'

" conceal some odd parts of snippets
"let g:clang_conceal_snippets = 1

" check syntax on <leader>Q
nmap <silent> <leader>Q :call g:ClangUpdateQuickFix()<cr>

" toggle autocompletion on <leader>q
nmap <silent> <leader>q :let g:clang_complete_auto=!g:clang_complete_auto<cr>

" ------------------------------------------------------------------------------
" TagList
"
" show TagList window at right
" let Tlist_Use_Right_Window=1
"
" omit odd empty lines
" let Tlist_Compact_Format=1
"
" close Vim, when only TagList window left
" let Tlist_Exit_OnlyWindow=1
"
" hide folds on buffer change
" let Tlist_File_Fold_Auto_Close=1
"
" capture focus on popup TagList
" let Tlist_GainFocus_On_ToggleOpen = 1
"
" don't show tree
" let Tlist_Enable_Fold_Column=0
"
" sort by alphabetically
" let Tlist_Sort_Type = "name"
"
" show taglist on ,t
" map <leader>t :TlistToggle<cr>
"
" ------------------------------------------------------------------------------
" TagBar

" expand window when it's needed
let g:tagbar_expand = 1

" omit odd empty lines
let g:tagbar_compact = 1

" capture cursor on popup
let g:tagbar_autofocus = 1

" close TagBar after tag was selected
"let g:tagbar_autoclose = 1

" map tagbar toggle on ,t
nmap <leader>t :TagbarToggle<cr>

" ------------------------------------------------------------------------------
" FSwitch

" autocommands to setup settings for different file types
augroup fswitch
    autocmd!
    autocmd! BufEnter,BufRead *.h let b:fswitchdst = 'c,cpp'
                              \ | let b:fswitchlocs = '.'
    autocmd! BufEnter,BufRead *.c let b:fswitchdst = 'h'
                              \ | let b:fswitchlocs = '.'
    autocmd! BufEnter,BufRead *.hpp let b:fswitchdst = 'cpp'
                              \ | let b:fswitchlocs = '.'
    autocmd! BufEnter,BufRead *.cpp let b:fswitchdst = 'hpp,h'
                                \ | let b:fswitchlocs = '.'
    autocmd! BufEnter,BufRead *.xaml let b:fswitchdst = 'xaml.cs'
                              \ | let b:fswitchlocs = '.'
    autocmd! BufEnter,BufRead *.xaml.cs let b:fswitchdst = 'xaml'
                              \ | let b:fswitchfnames = '/\.xaml//'
                              \ | let b:fswitchlocs = '.'
augroup end

" switch to the file and load it into the current window
nmap <silent> <Leader>of :FSHere<cr>

" in current window
nmap <silent> <Leader>oo :FSHere<cr>
" in a new tab
nmap <silent> <Leader>ot :call FSwitch('%', 'tabedit')<cr>

" switch to the file and load it into the window on the right
nmap <silent> <Leader>ol :FSRight<cr>

" switch to the file and load it into a new window split on the right
nmap <silent> <Leader>oL :FSSplitRight<cr>

" switch to the file and load it into the window on the left
nmap <silent> <Leader>oh :FSLeft<cr>

" switch to the file and load it into a new window split on the left
nmap <silent> <Leader>oH :FSSplitLeft<cr>

" switch to the file and load it into the window above
nmap <silent> <Leader>ok :FSAbove<cr>

" switch to the file and load it into a new window split above
nmap <silent> <Leader>oK :FSSplitAbove<cr>

" switch to the file and load it into the window below
nmap <silent> <Leader>oj :FSBelow<cr>

" switch to the file and load it into a new window split below
nmap <silent> <Leader>oJ :FSSplitBelow<cr>

" ------------------------------------------------------------------------------
" utl

let g:utl_cfg_hdl_mt_text_directory="!Thunar '%p'"
let g:utl_cfg_hdl_mt_image_djvu="!exo-open '%p'"

" ------------------------------------------------------------------------------
" vifm

if has('win32')
    let g:vifm_term = ''
    let g:vifm_exec = 'e:/projects/vifm/src/vifm.exe'
    let g:vifm_exec_args = '--select'
else
    let g:vifm_term = 'xterm -maximized -e'
endif

" ------------------------------------------------------------------------------
" linediff

nmap <leader>d :Linediff<cr>
nmap <leader>D :LinediffReset<cr>
vmap <leader>d :Linediff<cr>
vmap <leader>D :LinediffReset<cr>

" ------------------------------------------------------------------------------
" commentary

xmap gc  \\
nmap gc  \\
nmap gcc \\\

" ------------------------------------------------------------------------------
" neocomplcache

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" ------------------------------------------------------------------------------
" SingleCompile

nmap <f9> :call <SID>CSWrapper('SCCompile')<cr>
nmap <s-f9> :call <SID>CSWrapper('SCCompileRun')<cr>
function! <SID>CSWrapper(SCCommand)
    if !exists('b:SCAF') || b:SCAF == ''
        execute ':'.a:SCCommand
    else
        execute ':'.a:SCCommand.'AF '.b:SCAF
    endif
endfunction

nmap <m-s-f9> :call SingleCompile#Run()<cr>

autocmd BufReadPost,BufWritePre *.c,*.cpp,*.java call <SID>ReadSCAF()
" SCAF - SingleCompileAdditionalFlags
function! <SID>ReadSCAF()
    let l:first_line = getline(1)
    let l:directive = matchstr(l:first_line, 'SCAF:\s*.*$')
    if l:directive == ''
        let b:SCAF = ''
        return
    endif

    let b:SCAF = substitute(l:directive, '^SCAF:\s*', '', '')
endfunction

" ------------------------------------------------------------------------------
" NERDTree

" map NERDTree toggle
nmap <leader>n :NERDTreeToggle<cr>

" don't use NERDTree as file manager
let g:NERDTreeHijackNetrw=0

" ------------------------------------------------------------------------------
" netrw

" patterns of files that should be ignored by netrw
let g:netrw_list_hide='^.*\.un\~$,^.*\.swp$'

" default view - tree
let g:netrw_liststyle=3

" open file in previous buffer
"let g:netrw_browse_split=4

" preview in a vertival split
let g:netrw_preview=1

" ------------------------------------------------------------------------------
" pydiction

let g:pydiction_location = '/home/xaizek/.vim/bundle/pydiction/pydiction.py'

" ------------------------------------------------------------------------------
" ultisnips

" configure shortcuts
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" configure snippets directory name
let g:UltiSnipsSnippetDirectories=["ultisnips"]

" ------------------------------------------------------------------------------

" ==============================================================================
" misc

" run terminal emulator in the current directory
if has('win32')
    map <leader>T :!start bash<cr>
else
    map <leader>T :!xterm &<cr><cr>
endif

" run vifm in the current directory
if has('win32')
    map <leader>V :!start vifm %:p<cr>
else
    map <leader>V :silent !xterm -e "vifm '%:p:h'" &<cr>
endif

" clears marks
nmap <leader>m
            \ :call setqflist([])\|doautocmd QuickFixCmdPost * make\|cwindow<cr>

" automatically reread file changed by external application
set autoread

" extended capacities of %
runtime macros/matchit.vim

" make some messages a bit shorter and ignore the fact that file is already
" opened in another instance of Vim
set shortmess+=atIA

" show in vim help on K key
set keywordprg=

" ignore some not useful matches on command-line completion
set wildignore=*.~cpp,*.~hpp,*.~h,*.obj,*.swp,*.o,*.hi,*.exe,*.un~,*.class,*.d,
              \tags,a.out

" persistant undo
set undofile

set ttyfast

" don't force buffer unload on buffer switching
set hidden

" more colours in a terminal
set t_Co=256

" don't put header files to the back of wild menu list
set suffixes-=.h

" don't jump when one types brackets
set noshowmatch

" don't reset cursor position on some of motions (e.g. G, gg) to the beginning
" of a line
set nostartofline

" automatically write buffer on some commands
set autowrite

" create backup copies
set backup
set backupdir=~/.vim/bak/,.,~/tmp,~/

" don't break lines on input automatically
set textwidth=0

" show status bar always
set laststatus=2

" status bar customization
" bufname[modified][readonly][preview]
set statusline=%-20(%t%m%r%w%)
" |[ff][fenc][ft]
set statusline+=\|\%23([%{&ff}][%{&fenc}]%y%)
" |char[hexchar] \[vcol-\]col,line/total lines
set statusline+=\ \|\ %4(%b%)[%6(0x%B%)]%=%c%V,%l/%L
" |percentage of file
set statusline+=\ \|%10p%%

" break lines on whitespace
set linebreak

" highlight current line
set cursorline

" toggle spell checking for current buffer
nmap <silent> <leader>s :call <SID>ToggleSpell()<cr>

" highlight current word (case sensitive)
nnoremap <silent> <leader>l :call <SID>Highlight('let @/="\\C\\<', expand('<cword>'), '\\>"') \| setlocal hls<cr>
nnoremap <silent> <leader>L :call <SID>Highlight('let @/="\\<', expand('<cword>'), '\\>"') \| setlocal hls<cr>
nnoremap <silent> <leader><leader>l :call <SID>Highlight('let @/="\\C', expand('<cword>'), '"') \| setlocal hls<cr>
nnoremap <silent> <leader><leader>L :call <SID>Highlight('let @/="', expand('<cword>'), '"') \| setlocal hls<cr>
vnoremap <silent> <leader>l :<c-u>call <SID>Highlight('let @/="\\C', @*, '"') \| setlocal hls<cr>
vnoremap <silent> <leader>L :<c-u>call <SID>Highlight('let @/="', @*, '"') \| setlocal hls<cr>
vnoremap <silent> <leader><leader>l :<c-u>call <SID>Highlight('let @/="\\C', @*, '"') \| setlocal hls<cr>
vnoremap <silent> <leader><leader>L :<c-u>call <SID>Highlight('let @/="', @*, '"') \| setlocal hls<cr>

function! s:Highlight(before, what, after)
    if empty(a:what)
        echohl WarningMsg | echo 'No string under the cursor.' | echohl None
        return
    end

    let l:escapedWord = escape(a:what, '()[]~')
    " Need to do this again because it will be used inside double quoted string
    let l:escapedWord = escape(l:escapedWord, '\')
    execute a:before.l:escapedWord.a:after
    echo 'Highlighting: '.a:what
endfunction

" increase history size
set history=10000

" correct encoding detection
set fileencodings=ucs-bom,utf-8,default,cp1251,cp866

" start window scrolling before reaching its border
set scrolloff=4

" show partially entered commands
set showcmd

" set slepp check languages
set spelllang=ru,en

" show at most 20 suggestions on z=
set spellsuggest+=20

" by default display new window to the right on splitting
set splitright

" by default display new window below on splitting
set splitbelow

" smart indentation
filetype plugin indent on

" correct Y key
nmap Y y$

" map _= to buffer indentation
nmap <silent> _= :call <SID>PreserveAndRun('normal gg=G')<cr>

" map _$ to removing all ending whitespaces
nmap <silent> _$ :call <SID>PreserveAndRun('%s/\s\+$//e')<cr>

" use Ctrl-N/P to switch between tabs
nnoremap <c-n> gt
nnoremap <c-p> gT

" show/hide folds on space
nnoremap <space> za

" toggle line wrapping on <leader>w
nmap <leader>w :set wrap!<cr>

" automatically reread Vim's configuration after writing it
autocmd! BufWritePost $MYVIMRC source $MYVIMRC

" use current file's directory as working directory
" set autochdir
autocmd BufEnter,BufWinEnter *
            \ if &filetype != 'fugitiveblame' | silent! execute 'lcd' fnamemodify(expand('<afile>'), ':p:h') | endif

" create tags on Shift-F12 key
if has('win32')
    map <silent> <s-f12> :exe ":silent !start /b ctags -R -a --c++-kinds=+p
                \ --fields=+iaS --extra=+q ."<cr>
else
    map <silent> <s-f12> :exe ":silent !ctags -R -a --c++-kinds=+p
                \ --fields=+iaS --extra=+q ."<cr>
endif

" for TODO list
map <silent><f8> :vimgrep /fixme\\|todo\\|FIXME\\|TODO\\|FIXIT\\|fixit/j
            \*.c *.cpp *.h *.hpp<cr>:cw<cr>

" quick date and time pasting
iabbrev td <c-r>=strftime("%H:%M %d.%m.%Y")<cr>
iabbrev dt <c-r>=strftime("%d.%m.%Y %H:%M")<cr>
iabbrev dd <c-r>=strftime("%d.%m.%Y")<cr>

" swap ' and ` keys
nnoremap ' `
nnoremap ` '

" map ,h to search highlight toggle
nmap <silent> <leader>h :call <SID>ToggleHlsearch()<cr>
" these lines are needed for highlight enabling
nnoremap ,* *
nmap * :set hlsearch<cr>,*
nnoremap ,# #
nmap # :set hlsearch<cr>,#

" smart case policy on search
set ignorecase
set smartcase

" jj - <esc>
imap jj <esc>
" cmap jj <c-c>
smap jj <esc>

" don't loose selection in visual mode on < and >
vnoremap < <gv
vnoremap > >gv

" show Vim how to read doc-files
autocmd BufReadPre *.doc,*.DOC set ro
autocmd BufReadPost *.doc,*.DOC silent %!antiword -m cp1251.txt "%"

" directory where to store swap files
let s:swap_dir = $HOME.'/.vim/swap/'
execute 'set directory='.s:swap_dir.'/'
" ensure it exists
if !isdirectory(s:swap_dir)
    call mkdir(s:swap_dir)
endif

" directory where to store persistent undo files
let s:undo_dir = $HOME.'/.vim/undo'
execute 'set undodir='.s:undo_dir.',.'
" ensure it exists
if !isdirectory(s:undo_dir)
    call mkdir(s:undo_dir)
endif

" go to last editing place on file open (unless git commit message is edited)
autocmd BufReadPost *
     \  if line("'\"") > 1
     \          && line("'\"") <= line("$")
     \          && &filetype != 'gitcommit'
     \          && &filetype != 'gitrebase'
     \|     execute "normal! g`\""
     \| endif

" copy&paste to system's clipboard
nmap <leader>y "+y
nmap <leader>Y "+Y
nmap <leader>p "+p
" conflicts with ProtoDef plugin
" nmap <leader>P "+P

" to edit command line in a buffer
set cedit=<c-g>

" some shortcuts
map <leader>1 :tab drop $MYVIMRC<cr>
map <leader>2 :tab drop $HOME/.vim/crib.txt<cr>
map <leader>3 :tab drop $HOME/.vim/useful.txt<cr>
map <leader>0 :tab drop $HOME/.vifm/vifmrc<cr>

" edit visual selection in new tab
xmap ,t y:tabe<cr>Vp

" some additional paths for file searches
if has('win32')
    set path+=E:/programming/compilers/MinGW/include/
else
    set path+=/usr/local/include
"    set path+=/mnt/data/X-files/Prj(MK)/
"    set path+=/mnt/data/X-files/Prj(MK)/stdclib/inc/
endif

" line movement commands (up and down)
nnoremap <a-j> mz:m+<cr>`z==
nnoremap <a-k> mz:m-2<cr>`z==
inoremap <a-j> <esc>:m+<cr>==gi
inoremap <a-k> <esc>:m-2<cr>==gi
vnoremap <a-j> :m'>+<cr>gv=`<my`>mzgv`yo`z
vnoremap <a-k> :m'<-2<cr>gv=`>my`<mzgv`yo`z

" for handy binary files editing
if &binary
    augroup Binary
        autocmd!
        autocmd BufReadPre  * let &bin=1
        autocmd BufReadPost * if &bin | %!xxd
        autocmd BufReadPost * set ft=xxd | endif
        autocmd BufWritePre * if &bin | %!xxd -r
        autocmd BufWritePre * endif
        autocmd BufWritePost * if &bin | %!xxd
        autocmd BufWritePost * set nomod | endif
    augroup END
endif

autocmd BufEnter,BufWinEnter,WinEnter * :call <SID>SetParams()
function! <SID>SetParams()
    if search('^[^a-z]*vim: .*colorcolumn=', 'nw') != 0
        return
    endif
    let l:nocc = ['', 'gitrebase', 'gitcommit', 'qf', 'help', 'git']
    if index(l:nocc, &filetype) == -1
        " vertical border after 80 column
        set colorcolumn=81
    else
        " no vertical border
        set colorcolumn=0
    endif
endfunction

" ==============================================================================
" tabulation and indentation

" replace tabulation characters with spaces
set expandtab

" size of a real tabulation characters in spaces
set tabstop=4

" number of spaces inserted for tabulation replacement
set softtabstop=4

" show tabulation characters as a period and trailing whitespace as a dot
" also make it clear whether horizontal scroll is needed
set list
set listchars=tab:.\ ,trail:·
set listchars+=precedes:<,extends:>

" width of a shift for normal, visual and selection modes
set shiftwidth=4

" ==============================================================================
" work with Cyrillic symbols

" this is needed for normal work with non-English languages in insert mode
set keymap=russian-jcukenwin
" latin layout by default in insert mode
set iminsert=0
" use latin layout by default for search
set imsearch=0
" switch layout on Ctrl-L key
inoremap <c-l> <c-^>

" for work of normal mode commands
if has('win32')
    language ctype Russian_Russia.1251
else
    language ctype ru_RU.utf-8
endif

" ==============================================================================
" folding

" use syntactic folding for vim-script
let g:vimsyn_folding = 'f'

" for normal folding
" set foldmethod=syntax
" set foldnestmax=1
" set foldexpr=getline(v:lnum)=~'^[a-zA-Z_][a-zA-Z_0-9]*\s*[a-zA-Z_][a-zA-Z_0-9]'
" \&&getline(v:lnum+1)=~'^{'?'>1':getline(v:lnum)=~'^}'?'s1':'-1'

" close folds automatically
" set foldclose=all

" ==============================================================================
" misc commands and functions

if !exists(":DiffOrig")
  command DiffOrig set noautowrite | vert new | set bt=nofile | r # | 0d_
              \ | diffthis | wincmd p | diffthis | set autowrite
endif

" if current buffer is empty, performs search of file named .src_template from
" current directory up and loads its contents into the buffer
function! AddBasicTemplate()
    let l:empty_buffer = line2byte(line('$') + 1) == -1
    if !l:empty_buffer
        return
    endif

    " add file template
    let l:template = findfile('.src_template', '.;')
    if !empty(l:template)
        let l:file = readfile(l:template)
        call append(0, l:file)
    endif

    call cursor(line('$')/2 + 1, 0)
endfunction

function! Center()
    se splitright!
    vsplit empty
    setlocal nonumber
    exe "normal \<c-w>w"
    se splitright!
    vsplit empty
    setlocal nonumber
    exe "normal \<c-w>b"
    exe "normal \<c-w>h"

    " find longest line
    " add a split to the left so that current window become centered
endfunction

function! AddHeaderGuard()
    let l:line = line('.')
    let l:filename = toupper(expand("%:t:r"))
    let l:fileext = toupper(expand("%:t:e"))
    let l:was_empty = line2byte(line('$') + 1) == -1

    if strlen(l:filename) == 0
        return
    endif

    let l:header_guard = "__".l:filename."_".l:fileext."__"

    call append(0, "#ifndef ".l:header_guard)
    call append(1, "#define ".l:header_guard)
    call append(2, '')
    if l:was_empty
        call append(3, '')
    endif

    let l:last_line = line('$')
    call append(l:last_line, "#endif // ".l:header_guard)
    " call append(l:last_line, "#endif")

    call cursor(l:line + 3, 0)
endfunction

function! AddHeaderAndFooter()
    let l:line = line('.')

    " add file header
    let l:header = findfile('.src_header', '.;')
    if !empty(l:header)
        let l:file = readfile(l:header)
        let l:line += len(l:file)
        call append(0, l:file)
    endif

    " add file footer
    let l:footer = findfile('.src_footer', '.;')
    if !empty(l:footer)
        call append(line('$'), readfile(l:footer))
    endif

    call cursor(l:line, 0)
endfunction

function! AddSpaces()
    "silent execute '%s/){\([^}]*\)/) {\1/'
    silent execute '%s/){/) {/'
    silent execute '%s/else{/else {/'
    silent execute '%s/enum{/enum {/'
    silent execute '%s/union{/union {/'
    silent execute '%s/struct{/struct {/'
endfunction

" runs command preserving current cursor position and search register content
function! <SID>PreserveAndRun(cmd)
    let l:ncol = col('.')
    let l:nline = line('.')
    let l:search = @/
    execute a:cmd
    let @/ = l:search
    call cursor(l:nline, l:ncol)
endfunction

function! ReformatParagraphs()
    " remove end of lines
    silent execute '%s/\(\S\)\n\(\S\)/\1 \2/'
    " and contiguous spaces
    silent execute '%s/ \{2,\}/ /g'
endfunction

function! <SID>ToggleHlsearch()
    set hlsearch!
    if &hlsearch
        echo 'Search results highlighting is ON'
    else
        echo 'Search results highlighting is OFF'
    endif
endfunction

function! <SID>ToggleSpell()
    setlocal spell!
    if &l:spell
        echo 'Spell checking is ON'
    else
        echo 'Spell checking is OFF'
    endif
endfunction

" runs command passing function body limits as a range
function! ExecInFuncBody(cmd)
    let l:openbracket = search('^{', 'nW')
    let l:closebracket = search('^}', 'nW')
    if l:closebracket < l:openbracket || l:openbracket == 0
        let l:openbracket = search('^{', 'nbW')
    elseif l:openbracket > line('.')
        let l:openbracket = line('.')
    endif
    call <SID>PreserveAndRun(l:openbracket.','.l:closebracket.a:cmd)
endfunction

" determines number of lines in function body
function! GetFuncBodySize()
    let l:limits = GetFuncBodyLimits()
    return l:limits[1] - l:limits[0]
endfunction

" returns function body limits
function! GetFuncBodyLimits()
    let l:openbracket = search('^{', 'nW')
    let l:closebracket = search('^}', 'nW')
    if l:closebracket < l:openbracket || l:openbracket == 0
        let l:openbracket = search('^{', 'nbW')
    elseif l:openbracket > line('.')
        return [0, 0]
    endif
    return [l:openbracket, l:closebracket]
endfunction

function! ToUnix()
    edit ++ff=dos
    set ff=unix
    w
endfunction

function! GetIncludesIn(file)
    let l:lines = readfile(a:file)

    let l:startLine = -1
    let l:endLine = -1

    let l:i = 0
    for l:line in l:lines
        if l:line =~# &include
            if l:startLine == -1
                let l:startLine = l:i
                let l:endLine = l:i
            else
                let l:endLine = l:i
            endif
        endif
        let l:i += 1
    endfor

    if l:startLine != -1
        while l:startLine > 0 && !empty(l:lines[l:startLine - 1])
            let l:startLine -= 1
        endwhile
        while l:endLine < len(l:lines) - 1 && !empty(l:lines[l:endLine + 1])
            let l:endLine += 1
        endwhile
        return l:lines[l:startLine :l:endLine]
    else
        return []
    endif
endfunction

" ==============================================================================
" don't let me use "wrong" keys

imap <silent> <up>       <nop>
imap <silent> <down>     <nop>
imap <silent> <left>     <nop>
imap <silent> <right>    <nop>
imap <silent> <home>     <nop>
imap <silent> <end>      <nop>
imap <silent> <pageup>   <nop>
imap <silent> <pagedown> <nop>
imap <silent> <c-home>   <nop>
imap <silent> <c-end>    <nop>
imap <silent> <del>      <nop>
nmap <silent> <up>       <nop>
nmap <silent> <down>     <nop>
nmap <silent> <left>     <nop>
nmap <silent> <right>    <nop>
nmap <silent> <home>     <nop>
nmap <silent> <end>      <nop>
nmap <silent> <pageup>   <nop>
nmap <silent> <pagedown> <nop>
nmap <silent> <c-home>   <nop>
nmap <silent> <c-end>    <nop>
nmap <silent> <del>      <nop>
vmap <silent> <up>       <nop>
vmap <silent> <down>     <nop>
vmap <silent> <left>     <nop>
vmap <silent> <right>    <nop>
vmap <silent> <home>     <nop>
vmap <silent> <end>      <nop>
vmap <silent> <pageup>   <nop>
vmap <silent> <pagedown> <nop>
vmap <silent> <c-home>   <nop>
vmap <silent> <c-end>    <nop>
vmap <silent> <del>      <nop>

" ==============================================================================
" load machine specific local set of settings

let s:vimrc_local_path = $HOME . '/.vimrc_local'
if filereadable(s:vimrc_local_path)
    execute "source" s:vimrc_local_path
endif
unlet s:vimrc_local_path

" ==============================================================================
" experiments and tests

let g:pymode_syntax=1

map [[ ][%0

" vim: set textwidth=80 syntax+=.autofold :
