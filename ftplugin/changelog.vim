" Vim filetype plugin file for changelogs.
" Remaps [[ and ]] keys to go to next and previous section appropriately.
" Maintainer:   xaizek
" Last Change:  08 Oct 2015

nnoremap <silent><buffer> [[ :call cursor(<SID>GoToSection(0), 1)<cr>
nnoremap <silent><buffer> ]] :call cursor(<SID>GoToSection(1), 1)<cr>
vnoremap <silent><buffer> [[ <esc>:let t = <SID>GoToSection(0)
                           \\| exec 'normal' 'gv'.t.'gg'<cr>
vnoremap <silent><buffer> ]] <esc>:let t = <SID>GoToSection(1)
                           \\| exec 'normal' 'gv'.t.'gg'<cr>

" Moves cursor to next or previous section depending on value of the
" searchForward argument.
function! s:GoToSection(searchForward)
    let l:backwardFlag = a:searchForward ? '' : 'b'
    let l:position = search('^\S', 'nW'.l:backwardFlag)
    if l:position == 0
        let l:position = a:searchForward ? line('$') : 1
    endif
    return l:position
endfunction
