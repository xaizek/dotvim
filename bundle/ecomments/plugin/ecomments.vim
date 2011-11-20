" Easy comments

if exists('s:did_load')
    finish
endif

let s:did_load = 1

" join comments {{{

function! JoinWithLeader(count)
    let l:leaderText = matchstr(&comments,'\(^\|,\):\zs.\{-1,}\ze\(,\|$\)')
    if l:leaderText == ''
        execute 'normal! '.a:count.'J'
        return
    endif

    let l:escapedLeaderText = escape(l:leaderText, '/')
    let l:linecount = a:count
    " default number of lines to join is 1
    if l:linecount < 1
        let l:linecount = 1
    endif
    " clear errmsg so we can determine if the search fails
    let v:errmsg = ''

    " save off the search register to restore it later because we will clobber
    " it with a substitute command
    let l:savsearch = @/

    while l:linecount >= 1
        " do a J for each line (no mappings)
        normal! J
        " remove the comment leader from the current cursor position
        silent! execute 'substitute/\%#\s*\%('.l:escapedLeaderText.'\)\s*/ /'
        " check v:errmsg for status of the substitute command
        if v:errmsg =~ '^E486'
            " just means the line wasn't a comment - do nothing
        elseif v:errmsg != ''
            echo v:errmsg
            echo "Problem with leader pattern for JoinWithLeader()!"
            break
        else
            " a successful substitute will move the cursor to line beginning,
            " so move it back
            normal! ``
            " clean possible space at the and of line
            silent! execute 'substitute/\s*$//'
            " and again
            normal! ``
        endif
        let l:linecount = l:linecount - 1
    endwhile
    " restore the @/ register
    let @/ = l:savsearch
endfunction

nnoremap <silent> J :<C-U>call JoinWithLeader(v:count)<CR>

" }}}
" quick delete comments {{{

function! DeleteComment()
    let l:leaderText = matchstr(&comments,'\(^\|,\):\zs.\{-1,}\ze\(,\|$\)')
    if l:leaderText == ''
        return "\<c-h>"
    endif

    let l:escapedLeaderText = escape(l:leaderText, '/')

    let l:line = getline('.')[:col('.') - 2]
    if l:line !~ l:escapedLeaderText.'\s*$'
        return "\<c-h>"
    endif

    return repeat("\<c-h>", len(matchstr(l:line, l:escapedLeaderText.'\s*$')))
endfunction

inoremap <silent><expr> <backspace> DeleteComment()
inoremap <silent><expr> <c-h> DeleteComment()

" }}}

" vim: set foldmethod=marker foldlevel=0 :miv "
