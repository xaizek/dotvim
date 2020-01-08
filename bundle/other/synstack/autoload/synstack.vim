" dumps syntax stack for element under the cursor
function! synstack#SynStack()
    for id in synstack(line('.'), col('.'))
        echo synIDattr(id, 'name')
    endfor
endfunction
