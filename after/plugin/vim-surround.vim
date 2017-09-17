" Most of these come from vim-surround
" System and vim-surround that conflict and cause delay on 'y'. Just
" disable them entirely
" silent supresses errors - http://stackoverflow.com/questions/16218151/how-do-i-unmap-only-when-a-mapping-exists-in-vim
" I don't think we need these anymore since we disabled them wholesale via
" let g:surround_no_mappings=1

" NM. we still do...
silent! nunmap yO
silent! nunmap yo
silent! nunmap yS
silent! nunmap ys
silent! nunmap ySS
silent! nunmap ySs
silent! nunmap yss

" Unmap s in visual mode because it doesn't make sense and conflicts.
" silent! vunmap s
"
"
" This one has to be in this file to avoid conflict with colemak mapping...
"
" wrap surround? - ws"   WRAP surround WORD with QUOTE. 2nd is a modifier.
" nmap w  <Plug>Ysurround
nmap ws  <Plug>Ysurround

" dst - delete surrounding tag
" remove single surrounding quotes - ds '
nmap ds  <Plug>Dsurround

" CHANGE surround - cs{[ CHANGE SURROUNDING { with [
nmap cs  <Plug>Csurround

" FIXME THIS SOMEHOW :|
" vmap cs <Plug>Vsurround

