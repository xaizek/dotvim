" adds a space after C keywords
function! lib#spaces#AddSpaces()
    "silent execute '%s/){\([^}]*\)/) {\1/'
    silent execute '%s/){/) {/'
    silent execute '%s/else{/else {/'
    silent execute '%s/enum{/enum {/'
    silent execute '%s/union{/union {/'
    silent execute '%s/struct{/struct {/'
endfunction
