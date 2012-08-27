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
