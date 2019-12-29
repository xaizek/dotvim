let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = [ '.git' ]
let g:gutentags_cache_dir = $HOME.'/.cache/vim/gutentags/'

let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0

let g:gutentags_ctags_extra_args = [ '--tag-relative=yes', '--fields=+ailmnS' ]

let g:gutentags_ctags_exclude = [
    \ '.git', '.svg', '.hg',
    \ 'release',
    \ 'debut',
    \ 'bin',
    \ 'build',
    \ 'docs',
    \ '.md',
    \ '.rc',
    \ '.bak',
    \ '.zip',
    \ '.pyc',
    \ '.class',
    \ '.cache',
    \ 'tags',
    \ 'cscope.',
    \ '.css',
    \ '.swp', '.swo',
    \ '.bmp', '.gif', '.ico', '.jpg', '.png',
    \ '.rar', '.zip', '.tar', '.tar.gz', '.tar.xz', '.tar.bz2',
    \ '.pdf', '.doc', '.docx', '.ppt', '.pptx',
    \ '.vim',
\]

" clear the cache
" command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')

" possibly interesting options
" g:gutentags_exclude_filetypes
