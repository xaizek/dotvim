" default options
if !has('win32')
    let g:clang_user_options = '-I/usr/local/include/'
    let g:clang_user_options .= ' -I/usr/lib64/gcc/x86_64-slackware-linux/4.8.2/include/'
    let g:clang_user_options .= ' -I/usr/include/c++/4.8.2/x86_64-slackware-linux/'
    let g:clang_user_options .= ' -I/usr/include/c++/4.8.2/'
endif

" popup Quickfix window on errors
let g:clang_complete_copen = 1

" enable autocompletion
let g:clang_complete_auto = 0

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
let g:clang_library_path = '/usr/local/lib/'

" conceal some odd parts of snippets
"let g:clang_conceal_snippets = 1

" check syntax on <leader>Q
nnoremap <silent> <leader>Q :call g:ClangUpdateQuickFix()<cr>

" toggle autocompletion on <leader>q
" nnoremap <silent> <leader>q :let g:clang_complete_auto=!g:clang_complete_auto<cr>
