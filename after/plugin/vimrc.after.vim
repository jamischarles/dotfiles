" plugin stuff. For now, let's prefer to place specific overrides in the
" after/plugin folder
"
" THIS file will run AFTER all plugins, and AFTER all the plugin files in the
" /after folder. So it'll override those

"" STATUSLINE on top fixes... - Trying it out for a week...: TODO: Turn these
" off for PS work

"
if ! exists("is_ps")
	" Lots of experimental UI fixes that shouldn't apply to PS theme
	let g:gitgutter_sign_column_always = 1
	set nonumber " try this out"
	" make line
	hi LineNr ctermfg=black ctermbg=8
	set laststatus =0
	set showtabline =0 " hide tabline. Try it out, or hook it to a command

endif


" EXP Function to show it on tab, then show it after switching buffers
function! HideTabLine(...) "Optional args
	set showtabline =0
endfunction

" Show the tabs, and only hide them after "show" hasn't been called in x time
function! ShowTabLine(...) " Optional args. https://vi.stackexchange.com/questions/240/vimscript-optional-arguments
	let arg_length = a:0

	if exists("g:tab_hide_timer")
		call timer_stop(g:tab_hide_timer)
	endif

	" if FORCE is set, then don't autohide after delay
	" if (arg_length == 0)
	if (g:tab_hiding_enabled == 1)
		let g:tab_hide_timer = timer_start(2000, 'HideTabLine') " Async timer
	endif

	set showtabline =2
endfunction

if ! exists("is_ps")
	" by default, turn on tab hiding
	" let g:tab_hiding_enabled=1
	let g:tab_hiding_enabled=0

	command! ShowTabLine let g:tab_hiding_enabled=0 | :call ShowTabLine()
	command! HideTabLine let g:tab_hiding_enabled=1 | :call HideTabLine()

	autocmd BufEnter * :call ShowTabLine()
endif
" set foldcolumn=1 " left side spacing
" hi FoldColumn ctermbg=8

"I think I like having is just blend in...
" make number column wider
" set numberwidth =2
"
" TODO:
" Color tab for modified
" run iterm as its own chrome window?
" Simpler status / tablines

" END STATUSLINE

"" COLEMAK FIXES
" gi should be gs for us since we use 's' for insert
" Goes to the last insertion point and gets in insert mode
nmap gs gi
nmap g. gi

" restore delete INNER functinoality. I now want some of the original stuff
" back from vim. and this is one of them
" http://learnvimscriptthehardway.stevelosh.com/chapters/15.html (Op pending mappings
" https://vi.stackexchange.com/questions/2543/how-can-i-map-dcountd
" nnoremap di dr Did not work :{}

" vim-colemak gets word, eow keys wrong. Swap them.
" TRY without. See what happens
nnoremap y e|xnoremap y e|onoremap y e|
nnoremap Y E|xnoremap Y E|onoremap Y E|
nnoremap u w|xnoremap u w|onoremap u w|
nnoremap U W|xnoremap U W|onoremap U W|


" PASTE should NOT chante the paste buffer (I should be able to paste 6 times
" check .vimrc.after
" w/o having the previously replaced content show up now...
"https://superuser.com/questions/321547/how-do-i-replace-paste-yanked-text-in-vim-without-yanking-the-deleted-lines
vnoremap v :<C-U>let @p = @+<CR>gvp:let @+ = @p<CR>
vnoremap V :<C-U>let @p = @+<CR>gvp:let @+ = @p<CR>

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
"


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
if ! exists("is_ps")
	highlight! link SignColumn NONE
	highlight SignColumn ctermbg=red

	highlight GitGutterAdd ctermfg=28 guifg=darkgreen
	highlight GitGutterChange ctermfg=100 guifg=darkyellow
	highlight GitGutterDelete ctermfg=red guifg=darkred
	highlight GitGutterChangeDelete ctermfg=yellow guifg=darkyellow

	" https://github.com/altercation/vim-colors-solarized/blob/master/colors/solarized.vim#L285
	highlight SignColumn ctermbg=8
endif
