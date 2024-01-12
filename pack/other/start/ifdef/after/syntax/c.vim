" /usr/share/vim/vim91/syntax/cpp.vim contains:
"
"     " inform C syntax that the file was included from cpp.vim
"     let b:filetype_in_cpp_family = 1
"
"     " Read the C syntax to start with
"     runtime! syntax/c.vim
"     unlet b:current_syntax
"     unlet b:filetype_in_cpp_family
"
" Updating `set syntax` in this case isn't necessary and is harmful as some
" kind of recursion seems to kick in resulting in:
"
"     E108: No such variable: "b:filetype_in_cpp_family"

if !exists('b:filetype_in_cpp_family') && &syntax !~ '\.ifdef'
    set syntax+=.ifdef
endif
