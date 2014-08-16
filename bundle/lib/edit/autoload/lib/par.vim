" join lines of each paragraph and removes adjacent spaces
function! lib#par#ReformatParagraphs()
    " remove end of lines
    silent execute '%s/\(\S\)\n\(\S\)/\1 \2/e'
    " and adjacent spaces
    silent execute '%s/ \{2,\}/ /ge'
endfunction
