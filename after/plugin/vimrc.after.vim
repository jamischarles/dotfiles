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
nnoremap u w|xnoremap u w|onoremap u w|
nnoremap U W|xnoremap U W|onoremap U W|


" REMAP COLEMAK presets  more mappings and settings are in
" swap o and ; for normal mode, so we can much easier trigger the vim command,
" and we can still insert on the next line.
" line. Try it out... This is closer to how normal vim works anyway.
" EXPERIMENTAL: If this makes things too weird, I'll have to turn it off
" THIS BROKE lots of shortcuts in weird ways.
" nnoremap o ;
" nnoremap O :
" nnoremap ; o
" nnoremap : O

" Map bottom of screen to B
nnoremap B L|xnoremap B L|onoremap B L

" source $HOME/.vim/vimrc/keys.vimrc " Key bindings for Vim and Vim Plugins

" Textmanip mappings that conflict
"
" nnoremap <C-h> <Plug>(textmanip-move-left)
" xmap <C-h> <Plug>(textmanip-move-left)
" nnoremap <C-i> <Plug>(textmanip-move-right)
"
"

"" Git Gutter Colors
" highlight clear SignColumn

" try these
" highlight jsObject keys as 'Label' https://github.com/pangloss/vim-javascript/issues/138
" hi def link jsObjectKey Label " Type is nice. Use :hi to see all the
" Type is nice. Use :hi to see all the colors...
" remove the hilight link set by gitgutter plugin. Must live in this file so
" it's applied after gitgutter colors
" To troubleshoot hilights use :verbose hi [highligtName]
highlight! link SignColumn NONE
highlight SignColumn ctermbg=red

highlight GitGutterAdd ctermfg=28 guifg=darkgreen
highlight GitGutterChange ctermfg=100 guifg=darkyellow
highlight GitGutterDelete ctermfg=red guifg=darkred
highlight GitGutterChangeDelete ctermfg=yellow guifg=darkyellow

" https://github.com/altercation/vim-colors-solarized/blob/master/colors/solarized.vim#L285
highlight SignColumn ctermbg=8
