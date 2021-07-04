" dumps syntax stack for element under the cursor
function! synstack#SynStack()
    for l:id in synstack(line('.'), col('.'))
        let l:linked = synIDtrans(l:id)
        if l:linked == l:id
            echo synIDattr(l:id, 'name')
        else
            echo synIDattr(l:id, 'name') '->' synIDattr(l:linked, 'name')
        endif
    endfor
endfunction
