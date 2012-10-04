let s:filename = expand('<afile>')
let s:name = fnamemodify(s:filename, ':t:r')

0put = 'public class '.s:name
1put = '{'
%put = '}'
normal GkA
