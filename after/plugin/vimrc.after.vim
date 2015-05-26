" This is for things that HAVE to be loaded after the plugins. This is kind of
" a catch-all similar to what Janus is using. TODO: Consider moving all the
" .vimrc stuff in here, and just make sure that it gets loaded after the
" plugin stuff. For now, let's prefer to place specific overrides in the
" after/plugin folder
"
" THIS file will run AFTER all plugins, and AFTER all the plugin files in the
" /after folder. So it'll override those
"
" COLEMAK FIXES
" gi should be gs for us since we use 's' for insert
" Goes to the last insertion point and gets in insert mode
nmap gs gi


" vim-colemak gets word, eow keys wrong. Swap them.
" TRY without. See what happens
nnoremap y e|xnoremap y e|onoremap y e|
nnoremap Y E|xnoremap Y E|onoremap Y E|
" Use camelCaseMotion instead of this one
" nnoremap u w|xnoremap u w|onoremap u w|

nnoremap U W|xnoremap U W|onoremap U W|

