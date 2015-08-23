syn keyword cppOperator      alignof
syn keyword cppType          char16_t char32_t decltype
syn keyword cppStorageClass  constexpr thread_local
syn keyword cppConstant      nullptr
syn keyword cppStatement     static_assert

hi link cppConstant          Constant

hi link cErrInParen NONE
if exists("c_no_curly_error")
    syn match	cppErrInParen	display contained "^^<%\|^%>"
elseif exists("c_no_bracket_error")
    syn match	cppErrInParen	display contained "<%\|%>"
else
    syn match	cppErrInParen	display contained "<%\|%>"
endif
hi link cppErrInParen cError

" See: https://github.com/vim-jp/vim-cpp/pull/14
" A C++11 raw-string literal. It tries to follow 2.14.5 and 2.14.5.2 of the
" standard.
syn region cppRawString
  \ matchgroup=cppRawDelim
  \ start=+\%(u8\=\|[LU]\)\=R"\z(\%([ ()\\\d9-\d12]\@![\d0-\d127]\)\{,16}\)(+
  \ end=+)\z1"+
  \ contains=@Spell
hi link cppRawDelim cFormat
hi link cppRawString String
