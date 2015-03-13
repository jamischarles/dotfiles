" Most of these come from vim-surround
" System and vim-surround that conflict and cause delay on 'y'. Just
" disable them entirely
" silent supresses errors - http://stackoverflow.com/questions/16218151/how-do-i-unmap-only-when-a-mapping-exists-in-vim
silent! nunmap yO
silent! nunmap yo
silent! nunmap yS
silent! nunmap ys
silent! nunmap ySS
silent! nunmap ySs
silent! nunmap yss

