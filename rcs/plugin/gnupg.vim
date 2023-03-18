" prever use of gpg2, otherwise there is no communication with gpg-agent
if executable('gpg2')
    let g:GPGExecutable = 'gpg2 --trust-model always'
endif
