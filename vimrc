" if a .vimrc file exists, vim will start in nocompatible mode

set encoding=utf-8

scriptencoding utf-8

" handy variables for OS checks
if has('win32') || has('dos32')
    let s:win = 1
    let s:dos = has('dos32')
elseif has('unix')
    let s:win = 0
    let s:dos = 0
endif

" force using of English locale
if s:win
    language english
else
    language en_US.utf-8
endif

" use comma key as both <leader> and <localleader>
let mapleader = ','
let maplocalleader = ','

let $MYVIMRC=$HOME.'/.vim/vimrc'

if s:win
    set packpath^=~/.vim
    set packpath+=~/.vim/after
endif

if has('gui_running')
    " use 256 colors in :terminal
    let $TERM = 'xterm-256color'
endif

" ==============================================================================
" for plugins

if &loadplugins == 1
    " plugin settings
    set runtimepath+=~/.vim/rcs
endif

" ==============================================================================
" look&feel

" fill closed fold line with spaces
set fillchars-=fold:-

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
    if s:win
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
    if !s:dos
        colorscheme lucius
    endif
endif

" inform Vim about terminal color scheme
set background=dark

" window size (will only make it bigger)
if &columns < 85
    set columns=85
endif

" customize tab line
set tabline=%!libui#tabs#TabLine()

" show tab line always
set showtabline=2

" don't pause after <esc>
set ttimeoutlen=0

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
augroup MyEnter
    autocmd! BufReadPost,BufEnter,BufWinEnter,WinEnter  *
                \ if &filetype == 'qf' |
                \ elseif &filetype == 'vifm-cmdedit' |
                \ elseif &filetype == 'vifm-edit' |
                \ elseif bufname("%") == '__TagBar__' |
                \ elseif !&modifiable |
                \ elseif &readonly |
                \ else |
                \     nnoremap <buffer> <expr> <cr> MyEnter() |
                \ endif
augroup end
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

nnoremap <expr> A libedit#adva#AdvancedA()

" ------------------------------------------------------------------------------
" text paste motion

" replace text captured by a {motion} with contents of a register
nnoremap <silent> cp :let g:substitutemotion_reg = v:register
              \ <bar> set opfunc=libedit#subm#SubstituteMotion<CR>g@

" ------------------------------------------------------------------------------
" expand "{," as "{\n}"

inoremap <silent> , <c-r>=<SID>ExpandBracket()<cr>
function! s:ExpandBracket()
    let l:line = getline('.')
    let l:col = col('.') - 2
    if '{' == l:line[l:col]
        " move existing code between the braces
        if l:col == len(l:line) - 1
            return "\<esc>o}\<esc>\"_O"
        else
            return "\<cr>\<esc>o}\<esc>k^"
        endif
    endif
    return ','
endfunction

inoremap <silent> : <c-r>=<SID>ExpandBracketWithSemicolon()<cr>
function! s:ExpandBracketWithSemicolon()
    let l:line = getline('.')
    let l:col = col('.') - 2
    if '{' == l:line[l:col]
        return "\<bs>{\<esc>o};\<esc>\"_O"
    endif
    return ':'
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
if executable('par')
    set formatprg=par\ -w80\ T2\ \|\ sed\ 's/\ \ /\\t/g'
    " set formatprg="iconv -f UTF-8 -t WINDOWS-1251 |"
    "             \."par -w80 |"
    "             \."iconv -f WINDOWS-1251 -t UTF-8"
endif

" keys to insert empty lines above/below current line in normal mode
nnoremap <leader>f o<esc>
nnoremap <leader>F O<esc>

" ==============================================================================
" programming

" ------------------------------------------------------------------------------
" custom tag jumps

" on each next <c-]> press jumps to next tag with same name
nnoremap <silent> <c-]> :silent! call <SID>CallTagJump()<cr>

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

augroup libprj
    autocmd! BufEnter,BufWinEnter,WinEnter *
           \ call libprj#prj#Do('.in.vim')
    autocmd! BufLeave,BufWinLeave,WinLeave,BufDelete *
           \ call libprj#prj#Do('.out.vim')
augroup end

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
nnoremap <leader>rr mr:silent! %s/\C\<<c-r><c-w>\>//g\|normal 'r<left><left>
            \<left><left><left><left><left><left><left><left><left><left>
nnoremap <leader>rf :silent! call ExecInFuncBody('s/\C\<<c-r><c-w>\>//g')<left>
            \<left><left><left>
nnoremap <leader>rt :silent! tabdo %s/\C\<<c-r><c-w>\>//g<left><left>
nnoremap <leader>rb :silent! bufdo %s/\C\<<c-r><c-w>\>//g<left><left>

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

" indentation rules:
"     N-s - do not indent content of namespace
set cinoptions=g0,(0,W4,N-s

" run astyle on current file on ,a
if executable('astyle')
    nnoremap <silent> <leader>a :call libext#astyle#FormatFile(expand('%'))<bar>e<cr>
endif

" get rid of compiler notes and make failure report on :make
let &errorformat = '%-G%.%#:%.%#: note: %m,'
                 \.'%-G%.%#:%.%#:%.%#: note: %m,'
                 \.'%-G%.%#: recipe for target%.%#failed,'
                 \.&errorformat

" search for word under the cursor in all c and cpp files of current directory
nnoremap <leader>g :execute 'vimgrep /\C\<'.expand('<cword>').'\>/' libprj#prj#GetRoot().'/**/*.c' libprj#prj#GetRoot().'/**/*.cpp \| cw'<cr>
nnoremap <leader>G :execute 'vimgrep /\C\<'.expand('<cword>').'\>/' libprj#prj#GetRoot().'/**/*.h' libprj#prj#GetRoot().'/**/*.hpp \| cw'<cr>
vnoremap <leader>g :<c-u>execute 'vimgrep /\C\<'.@*.'\>/' libprj#prj#GetRoot().'/**/*.c' libprj#prj#GetRoot().'/**/*.cpp \| cw'<cr>
vnoremap <leader>G :<c-u>execute 'vimgrep /\C\<'.@*.'\>/' libprj#prj#GetRoot().'/**/*.h' libprj#prj#GetRoot().'/**/*.hpp \| cw'<cr>
nnoremap <leader><leader>g :execute 'vimgrep /\C'.expand('<cword>').'/' libprj#prj#GetRoot().'/**/*.c' libprj#prj#GetRoot().'/**/*.cpp \| cw'<cr>
nnoremap <leader><leader>G :execute 'vimgrep /\C'.expand('<cword>').'/' libprj#prj#GetRoot().'/**/*.h' libprj#prj#GetRoot().'/**/*.hpp \| cw'<cr>
vnoremap <leader><leader>g :<c-u>execute 'vimgrep /\C'.@*.'/' libprj#prj#GetRoot().'/**/*.c' libprj#prj#GetRoot().'/**/*.cpp \| cw'<cr>
vnoremap <leader><leader>G :<c-u>execute 'vimgrep /\C'.@*.'/' libprj#prj#GetRoot().'/**/*.h' libprj#prj#GetRoot().'/**/*.hpp \| cw'<cr>
command! -nargs=1 -bang LookUp call s:LookUp(<q-args>, <q-bang>)

function! s:LookUp(what, with_bang)
    if a:with_bang == '!'
        let l:pattern = '\C\<'.a:what.'\>'
    else
        let l:pattern = '\C'.a:what
    endif
    try
        execute 'vimgrep /'.l:pattern.'/' s:IfAnyFiles(libprj#prj#GetRoot().'/**/*.c') s:IfAnyFiles(libprj#prj#GetRoot().'/**/*.cpp')
    catch 'E480'
        redraw
        echohl WarningMsg
        echomsg 'Nothing matching '.l:pattern.' was found.'
        echohl None
        return
    endtry
    cwindow
endfunction

function! s:IfAnyFiles(glob)
    if !empty(glob(a:glob))
        return a:glob
    endif
    return ''
endfunction

" introduce variable
nnoremap <leader>v O<c-r>.<esc>^m'A<space>=<space><c-r>";<esc>`'=''I

" ==============================================================================
" misc

if !s:win
    " when not on Windows use xterm
    let $TERM_APP = 'xterm'
endif

" run terminal emulator in the current directory
if s:win
    nnoremap <leader>t :!start bash<cr>
else
    nnoremap <leader>t :!$TERM_APP &<cr><cr>
endif

" run vifm in the current directory
if s:win
    nnoremap <leader>V :!start vifm %:p<cr>
else
    nnoremap <leader>V :silent !$TERM_APP -e vifm '%:p:h' &<cr>
endif

" clears error list and marks
nnoremap <silent> <leader>ce : call setqflist([])
                           \\| doautocmd QuickFixCmdPost make
                           \\| cwindow<cr>

" automatically reread file changed by external application
set autoread

" extended capacities of %
runtime macros/matchit.vim

" make some messages a bit shorter and ignore the fact that file is already
" opened in another instance of Vim
set shortmess+=atIA

" show in vim help on K key
set keywordprg=

" builtin grep is good enough, no need to use external tools
set grepprg=internal

" ignore some not useful matches on command-line completion
set wildignore=*.~cpp,*.~hpp,*.~h,*.obj,*.swp,*.o,*.hi,*.exe,*.un~,*.class,*.d
             \,*.gch,tags,a.out

" persistent undo
set undofile

set ttyfast

" don't force buffer unload on buffer switching
set hidden

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

" directory where to store backup files
let s:backup_dir = libcfg#cfg#CreateVimStorageDir('bak')
execute 'set backupdir='.s:backup_dir.'//,.,~/tmp,~/'

" directory where to store swap files
let s:swap_dir = libcfg#cfg#CreateVimStorageDir('swap')
execute 'set directory='.s:swap_dir.'//'

" directory where to store persistent undo files
let s:undo_dir = libcfg#cfg#CreateVimStorageDir('undo')
execute 'set undodir='.s:undo_dir.'/,.'

" don't break lines on input automatically
set textwidth=0

" show status bar always
set laststatus=2

" status bar customization
" bufname[modified][readonly][preview]
set statusline=%-10.60(%{pathshorten(expand('%:p:~'))}%m%r%w%)
" |[ff][fenc][ft]
set statusline+=\ \|\ \%15.23([%{&ff}][%{&fenc}]%y%)
" |char:hexchar
set statusline+=\ \|\ %3.4(%b%):%4.6(0x%02B%)\ 
" filler
set statusline+=%=
" \[vcol-\]col,line/total lines
set statusline+=%c%V,%l/%L
" | percentage of file
set statusline+=\|%3.4(%P%)

" break lines on whitespace
set linebreak

" highlight current line
set cursorline

" toggle spell checking for current buffer
nnoremap <silent> <leader>s :call libcfg#opt#ToggleSpell()<cr>

" highlight current word (case sensitive)
nnoremap <silent> <leader>l :call libview#hl#Highlight('let @/="\\C\\<', expand('<cword>'), '\\>"') \| setlocal hls<cr>
nnoremap <silent> <leader>L :call libview#hl#Highlight('let @/="\\<', expand('<cword>'), '\\>"') \| setlocal hls<cr>
nnoremap <silent> <leader><leader>l :call libview#hl#Highlight('let @/="\\C', expand('<cword>'), '"') \| setlocal hls<cr>
nnoremap <silent> <leader><leader>L :call libview#hl#Highlight('let @/="', expand('<cword>'), '"') \| setlocal hls<cr>
vnoremap <silent> <leader>l :<c-u>call libview#hl#Highlight('let @/="\\C', @*, '"') \| setlocal hls<cr>
vnoremap <silent> <leader>L :<c-u>call libview#hl#Highlight('let @/="', @*, '"') \| setlocal hls<cr>
vnoremap <silent> <leader><leader>l :<c-u>call libview#hl#Highlight('let @/="\\C', @*, '"') \| setlocal hls<cr>
vnoremap <silent> <leader><leader>L :<c-u>call libview#hl#Highlight('let @/="', @*, '"') \| setlocal hls<cr>

" close previously active window
nnoremap <silent> <c-k>o <c-w>p:hide<cr>

" close window to the left/down/up/right
nnoremap <silent> <c-k>h     <c-w>h<c-w>p:<c-r>=winnr('#')<cr>hide<cr>
nnoremap <silent> <c-k><c-h> <c-w>h<c-w>p:<c-r>=winnr('#')<cr>hide<cr>
nnoremap <silent> <c-k>j     <c-w>j<c-w>p:<c-r>=winnr('#')<cr>hide<cr>
nnoremap <silent> <c-k><c-j> <c-w>j<c-w>p:<c-r>=winnr('#')<cr>hide<cr>
nnoremap <silent> <c-k>k     <c-w>k<c-w>p:<c-r>=winnr('#')<cr>hide<cr>
nnoremap <silent> <c-k><c-k> <c-w>k<c-w>p:<c-r>=winnr('#')<cr>hide<cr>
nnoremap <silent> <c-k>l     <c-w>l<c-w>p:<c-r>=winnr('#')<cr>hide<cr>
nnoremap <silent> <c-k><c-l> <c-w>l<c-w>p:<c-r>=winnr('#')<cr>hide<cr>

highlight SecondaryHighlight guibg=lightgreen guifg=black ctermbg=lightgreen ctermfg=black
" swap marking
nnoremap <silent> <leader>m :2match SecondaryHighlight /<c-r>//<cr>
" clear marking
nnoremap <silent> <leader>cm :2match none<cr>

" increase history size (don't make it 10000, Vim becomes slow to start/quit)
set history=1000

" correct encoding detection
set fileencodings=ucs-bom,utf-8,default,cp1251,cp866

" start window scrolling before reaching its border
set scrolloff=4

" show partially entered commands
set showcmd

" set spell check languages
set spelllang=en,ru

" show at most 20 suggestions on z=
set spellsuggest+=20

" by default display new window to the right on splitting
set splitright

" by default display new window below on splitting
set splitbelow

" smart indentation
filetype plugin indent on

" correct Y key
nnoremap Y y$

" map _= to buffer indentation
nnoremap <silent> _= :call <SID>PreserveAndRun('normal gg=G')<cr>

" map _$ to removing all ending whitespaces
nnoremap <silent> _$ :call <SID>PreserveAndRun('%s/\s\+$//e')<cr>

" use Ctrl-N/P to switch between tabs
nnoremap <c-n> gt
nnoremap <c-p> gT

" move tab to [count] tab position, if [count] is present
noremap <expr> gT libaction#CountTabMove()

" show/hide folds on space
nnoremap <space> za

" insert from system clipboard on Shift-Insert (for consistency with terminals)
inoremap <s-insert> <c-r>*
cnoremap <s-insert> <c-r>*

" toggle line wrapping on <leader>w
nnoremap <leader>w :set wrap!<cr>

" automatically reread Vim's configuration after writing it
autocmd! BufWritePost $MYVIMRC source $MYVIMRC

" use current file's directory as working directory
" done in this way because 'autochdir' does't always work
autocmd BufEnter,BufWinEnter,BufRead,BufCreate * call <SID>SetLocalPath()
function! s:SetLocalPath()
    let l:path = fnamemodify(expand('<afile>'), ':p:h')
    " don't change directory on editing certain files
    if &filetype != 'fugitiveblame' &&
        \ l:path !~ glob2regpat('/tmp/bash-fc-*') &&
        \ l:path !~ glob2regpat('/tmp/vifm.*')
        silent! execute 'lcd' l:path
    endif
endfunction

" create tags on Shift-F12 key
if s:win
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

" quick insertion of /* <cursor>. */ comments
iabbrev //* /*. */<c-o>4h

" swap ' and ` keys
nnoremap ' `
nnoremap ` '

" map ,h to search highlight toggle
nnoremap <silent> <leader>h :call libcfg#opt#ToggleHlsearch()<cr>
" automatically enable highlighting of search results on * and #
nnoremap * :set hlsearch<cr>*
nnoremap # :set hlsearch<cr>#

" smart case policy on search
set ignorecase
set smartcase

" don't loose selection in visual mode on < and >
vnoremap < <gv
vnoremap > >gv

" show Vim how to read doc-files
autocmd BufReadPre *.doc,*.DOC set ro
autocmd BufReadPost *.doc,*.DOC silent %!antiword -m cp1251.txt "%"

" go to last editing place on file open (unless git commit message is edited)
autocmd BufReadPost *
     \  if line("'\"") > 1
     \          && line("'\"") <= line("$")
     \          && &filetype != 'gitcommit'
     \          && &filetype != 'gitrebase'
     \|     execute "normal! g`\""
     \| endif

" copy&paste to system's clipboard
nnoremap <leader>y "+y
nnoremap <leader>Y "+Y
nnoremap <leader>p "+p
" conflicts with ProtoDef plugin
" nmap <leader>P "+P

" to edit command line in a buffer (setting 'cedit' to <c-g> makes original
" function of <c-g> unavailable)
cnoremap <c-g> <c-f>

" go to next/previous incremental search match
cnoremap <expr> <tab>
       \ feedkeys(index(['/', '?'], getcmdtype()) >= 0 ? "<c-g>" : "<tab>",
       \          'tn') ? '' : ''
cnoremap <expr> <s-tab>
       \ feedkeys(index(['/', '?'], getcmdtype()) >= 0 ? "<c-t>" : "<s-tab>",
       \          'tn') ? '' : ''

" some shortcuts
nnoremap <leader>1 :tab drop $MYVIMRC<cr>
nnoremap <leader>2 :tab drop $HOME/.vim/crib.txt<cr>
nnoremap <leader>3 :tab drop $HOME/.vim/useful.txt<cr>
nnoremap <leader>0 :tab drop $HOME/.vifm/vifmrc<cr>
nnoremap <leader>- :tab drop $HOME/.vifm/vifmrc_local<cr>

" edit visual selection in new tab
xnoremap ,t y:tabe<cr>Vp

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
    if &colorcolumn != 0
        return
    endif
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
set softtabstop=-1

" width of a shift for normal, visual and selection modes
set shiftwidth=0

" show tabulation characters as a period and trailing whitespace as a dot
" also make it clear whether horizontal scroll is needed
set list
set listchars=tab:.\ ,trail:·
set listchars+=precedes:<,extends:>

" round indentation to multiple of 'shiftwidth'
set shiftround

" ==============================================================================
" work with Cyrillic symbols

" this is needed for normal work with non-English languages in insert mode
set keymap=russian-jcukenwin
" start with latin layout
set iminsert=0
" use 'iminsert' value for search settings
set imsearch=-1
" switch layout on Ctrl-L key
inoremap <c-l> <c-^>
cnoremap <c-l> <c-^><c-l>

" reset to latin layout on entering ('iminsert' can be changed on command-line
" as well) and leaving insert mode
augroup imreset
    autocmd!
    autocmd InsertEnter,InsertLeave * set iminsert=0
augroup end

" for work of normal mode commands
if s:win
    silent! language ctype Russian_Russia.1251
else
    silent! language ctype ru_RU.utf-8
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

function! s:DiffOrig()
    set noautowrite

    try
        let l:ft = &filetype

        leftabove vert new
        set buftype=nofile

        read #
        0delete_

        " set file type here to not do it to an empty buffer
        let &filetype = l:ft

        diffthis
        wincmd p
        diffthis
    finally
        set autowrite
    endtry
endfunction
command! DiffOrig call s:DiffOrig()

" query title of page at URL in the current line (whole line) and insert it one
" line above
command! GetPageTitle call libedit#url#QueryURLTitle()

" convert end of lines in the current buffer to Unix style
command! ToUnix call libedit#eols#ToUnix()

" join lines of each paragraph and removes adjacent spaces
command! ReformatParagraphs call libedit#par#ReformatParagraphs()

" if current buffer is empty, performs search of file named .src_template from
" current directory up and loads its contents into the buffer
function! AddBasicTemplate()
    let l:empty_buffer = line2byte(line('$') + 1) == -1
    if !l:empty_buffer
        return
    endif

    " add file template
    let l:template = findfile('.src_template', '.;')
    if !empty(l:template) && filereadable(l:template)
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
    HeaderguardAdd

    " put cursor between elements of header guard
    call cursor(line('$'), 0)
    call cursor(search('^#endif', 'bcn') - 2, 0)
endfunction

function! HeaderguardName()
    let l:filename = expand("%:t:r")
    let l:fileext = expand("%:t:e")

    let l:prefix = exists('b:project_name') ? b:project_name.'__' : ''
    if exists('b:project_root')
        let l:dir = expand("%:p:h")
        let l:root = fnamemodify(b:project_root, ':p:h')
        while l:dir[:len(l:root) - 1] != l:root
            let l:root = fnamemodify(l:root, ':h')
        endwhile
        let l:relpath = l:dir[len(l:root) + 1:].'/'
        if !empty(l:relpath) && l:relpath != '/'
            let l:prefix .= l:relpath
        endif
    endif
    let l:prefix = substitute(l:prefix, '/\|\\', '__', 'g')
    let l:header_guard = toupper(l:prefix.l:filename.'_'.l:fileext.'__')
    return l:header_guard
endfunction

function! HeaderguardLine3()
    if &l:filetype == 'c'
        return '#endif /* ' . g:HeaderguardName() . ' */'
    else
        return '#endif // ' . g:HeaderguardName()
    endif
endfunction

function! AddHeaderAndFooter()
    let l:line = line('.')

    " add file header
    let l:header = findfile('.src_header', '.;')
    if !empty(l:header) && filereadable(l:header)
        let l:file = readfile(l:header)
        let l:line += len(l:file)
        call append(0, l:file)
    endif

    " add file footer
    let l:footer = findfile('.src_footer', '.;')
    if !empty(l:footer) && filereadable(l:footer)
        call append(line('$'), readfile(l:footer))
    endif

    call cursor(l:line, 0)
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

inoremap <silent> <up>       <nop>
inoremap <silent> <down>     <nop>
inoremap <silent> <left>     <nop>
inoremap <silent> <right>    <nop>
inoremap <silent> <home>     <nop>
inoremap <silent> <end>      <nop>
inoremap <silent> <pageup>   <nop>
inoremap <silent> <pagedown> <nop>
inoremap <silent> <c-home>   <nop>
inoremap <silent> <c-end>    <nop>
inoremap <silent> <del>      <nop>
nnoremap <silent> <up>       <nop>
nnoremap <silent> <down>     <nop>
nnoremap <silent> <left>     <nop>
nnoremap <silent> <right>    <nop>
nnoremap <silent> <home>     <nop>
nnoremap <silent> <end>      <nop>
nnoremap <silent> <pageup>   <nop>
nnoremap <silent> <pagedown> <nop>
nnoremap <silent> <c-home>   <nop>
nnoremap <silent> <c-end>    <nop>
nnoremap <silent> <del>      <nop>
vnoremap <silent> <up>       <nop>
vnoremap <silent> <down>     <nop>
vnoremap <silent> <left>     <nop>
vnoremap <silent> <right>    <nop>
vnoremap <silent> <home>     <nop>
vnoremap <silent> <end>      <nop>
vnoremap <silent> <pageup>   <nop>
vnoremap <silent> <pagedown> <nop>
vnoremap <silent> <c-home>   <nop>
vnoremap <silent> <c-end>    <nop>
vnoremap <silent> <del>      <nop>

" ==============================================================================
" load machine specific local set of settings

let s:vimrc_local_path = $HOME . '/.vimrc_local'
if filereadable(s:vimrc_local_path)
    execute "source" s:vimrc_local_path
endif
unlet s:vimrc_local_path

" ==============================================================================
" experiments and tests

finish

" vim: set textwidth=80 syntax+=.autofold :
