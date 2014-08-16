if has('win32')
    let g:vifm_term = ''
    let g:vifm_exec = 'e:/projects/vifm/src/vifm.exe'
    let g:vifm_exec_args = '--select'
else
    let g:vifm_term = 'xterm -maximized -e'
endif
