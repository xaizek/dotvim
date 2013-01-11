" Vim filetype plugin file for changelogs.
" Remaps [[ and ]] keys to go to next and previous section appropriately.
" Maintainer:   xaizek
" Last Change:  11 Jan 2013

nnoremap <silent><buffer> [[ :call <SID>GoToSection(0)<cr>
nnoremap <silent><buffer> ]] :call <SID>GoToSection(1)<cr>

" Moves cursor to next or previous section depending on value of the
" searchForward argument.
function! <SID>FindBegin(searchForward)
    let l:backwardFlag = a:searchForward ? '' : 'b'
    let l:position = search('^\S', 'nW'.l:backwardFlag)
    if l:position == 0
        let l:position = a:searchForward ? line('$') : 1
    endif
    call cursor(l:position, 1)
endfunction
