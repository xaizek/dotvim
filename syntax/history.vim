if exists('b:current_syntax')
    finish
endif

let b:current_syntax = 'history'

" подсветка временных отметок
syntax match Keyword /\[\(\(\d\d:\d\d \)\?\d\d.\d\d.\d\d\d\d\)\?\]/

" подсветка ошибок (!)
syntax match Error /\(\(\]\s\(\s\s\)\?\)\|\(\s\{18\}\)\)\@<=!.*$/

" подсветка решения ошибок и проблем (=)
syntax match Solved /\(\(\]\s\(\s\s\)\?\)\|\(\s\{18\}\)\)\@<==.*$/

" подсветка todo (?)
syntax match Todo /\(\(\]\s\(\s\s\)\?\)\|\(\s\{18\}\)\)\@<=?.*$/

" подсветка комментариев (#)
syntax match Comment /\(\(\]\s\(\s\s\)\?\)\|\(\s\{18\}\)\)\@<=#.*$/

" подсветка добавлений (+)
syntax match Addition /\(\(\]\s\(\s\s\)\?\)\|\(\s\{18\}\)\)\@<=+.*$/

" подсветка удалений (-)
syntax match Deletion /\(\(\]\s\(\s\s\)\?\)\|\(\s\{18\}\)\)\@<=-.*$/

" подсветка изменений (~)
syntax match Changes /\(\(\]\s\(\s\s\)\?\)\|\(\s\{18\}\)\)\@<=\~.*$/

" определение моих групп
highlight Solved ctermbg=green ctermfg=blue guibg=darkblue guifg=lightred
            \ gui=NONE
highlight Addition ctermfg=darkgreen guifg=darkgreen gui=NONE
highlight Deletion ctermfg=darkred guifg=darkred gui=NONE
highlight Changes ctermfg=magenta guifg=magenta gui=NONE
