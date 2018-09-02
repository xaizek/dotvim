" use builtin functions to query lists of files
let g:inccomplete_findcmd = ''

" never add close bracket on completion
let g:inccomplete_addclosebracket = ''

" complete directory names
let g:inccomplete_showdirs = 1

" use b:clang_user_options for ""-completion
let g:inccomplete_localsources = [ 'relative-paths', 'clang-buffer' ]
