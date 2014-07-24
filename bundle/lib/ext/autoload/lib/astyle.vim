function! lib#astyle#FormatFile(path)
    let l:prefix = has('win32') ? 'start /b ' : ''
    execute "silent !".l:prefix."astyle --indent=spaces=4
                                      \ --convert-tabs
                                      \ --add-brackets
                                      \ --brackets=stroustrup
                                      \ --align-pointer=type
                                      \ --pad-header
                                      \ --indent-namespaces
                                      \ --indent-switches
                                      \ --indent-preprocessor ".path
endfunction
