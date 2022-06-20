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

"" COLEMAK FIXES:
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


" PASTE should NOT change the paste buffer (I should be able to paste 6 times
" check .vimrc.after
" w/o having the previously replaced content show up now...
"https://superuser.com/questions/321547/how-do-i-replace-paste-yanked-text-in-vim-without-yanking-the-deleted-lines
vnoremap v :<C-U>let @p = @+<CR>gvp:let @+ = @p<CR>
vnoremap V :<C-U>let @P = @+<CR>gvp:let @+ = @P<CR>
" vnoremap V <Plug>unimpairedBlankDown<CR> :<C-U>let @p = @+<CR>gvp:let @+ = @p<CR>
"
" nmap v <plug>(YoinkPaste_p)

" GENIUS https://stackoverflow.com/questions/3154556/paste-from-clipboard-in-vim-script
" V -> PASTE after current line (wheter single or multi line yank)
nnoremap V :put +<cr>

" command! SmartPaste :call SmartPaste()
"
" " call SmartPaste()
" function! SmartPaste()
" 	" call the paste buffer
" 	echo @p
" 	echo @"
" 	echo stridx(@", "\n")
" 	" if " buffer contains newline
" 	if (stridx(@", "\n") > -1)
" 		" execute 'o p'
" 		gvp
" 		normal! "+p
" 		" https://stackoverflow.com/questions/3154556/paste-from-clipboard-in-vim-script
" 	elseif
"
" 	endif
" 	" echo stridx(@", ^J)
" 	" echo stridx(@", \n)
"   " if NERDTree has focus, go to next window
"   " if exists("b:NERDTree")
"      " echo "Can't navigate on NERDTree"
"   "   " Go to next window
"   "   execute 'wincmd w'
"   " endif
"   "
"   " " Open selected file
"   " execute 'e ' a:e
"
" endfunction

" map cc C

"
"
" How I expect paste to work:
" - V should paste on next line (if normal yank)
" - v should paste inline (if normal yank)
" - v should paste on next line (if C yank - whole line yank)

" For visual block mode remap the append and insert commands to act as I
" expect
" in visual mode T should go to end of line (most useful for visual block edit)
" S should go to beginning of line and insert (still with multi cursor
" working...)
vnoremap T $$A
vnoremap S ^I

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



	highlight GitGutterAdd ctermfg=28 guifg=darkgreen ctermbg=8
	highlight GitGutterChange ctermfg=100 guifg=darkyellow ctermbg=8
	highlight GitGutterDelete ctermfg=red guifg=darkred ctermbg=8
	highlight GitGutterChangeDelete ctermfg=yellow guifg=darkyellow ctermbg=8

	" https://github.com/altercation/vim-colors-solarized/blob/master/colors/solarized.vim#L285
	highlight SignColumn ctermbg=8


	"Signify gutter colors (this is what we're using now...
	"makes the signcolumn not have a separate color
	highlight SignColumn guibg=NONE

	highlight SignifySignAdd ctermfg=28 guifg=darkgreen ctermbg=8
	highlight SignifySignChange ctermfg=100 guifg=darkyellow ctermbg=8
	highlight SignifySignDelete ctermfg=red guifg=darkred ctermbg=8
	" highlight  ctermfg=yellow guifg=darkyellow ctermbg=8
	highlight SignifyLineAdd ctermfg=28 guifg=darkgreen ctermbg=8
	highlight link SignifyLineChange DiffText


	" Signcolumn color changes for CoC and other linters etc...
	" Removes the BG from them for all themes...
	highlight ALEInfo guibg=NONE
	highlight ALEInfoSign guibg=NONE
	highlight ALEError guibg=NONE
	highlight ALEErrorSign guibg=NONE
	highlight ALEWarning guibg=NONE
	highlight ALEWarningSign guibg=NONE



	" Change bg color of the tokyo
	" hi Normal guifg=#a9b1d6 guibg=#1a1b26
	" hi Normal guifg=#a9b1d6 guibg=red

	" Add strikethrough for markdown ~~text~~
	" htmlStrike is for the tildes. mkdStrike is for the inner content
	" highlight MyStrikethrough  gui=strikethrough ctermfg=18 guifg=#262839
	highlight mkdStrike gui=strikethrough ctermfg=18 guifg=#262839
	highlight htmlStrike gui=strikethrough ctermfg=18 guifg=#262839
	" highlight Conceal         guifg=#262839
	" This will manually apply it in each focused window...
	" call matchadd('MyStrikethrough', '\~\~\zs.\+\ze\~\~')
	" call matchadd('Conceal',  '\~\~\ze.\+\~\~', 10, -1, {'conceal':''})
	" call matchadd('Conceal',  '\~\~.\+\zs\~\~\ze', 10, -1, {'conceal':''})

	" Changes the bg color of autocomplete box...  https://github.com/dracula/vim/issues/14
	" hi Pmenu ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#64666d gui=NONE
	" hi PmenuSel ctermfg=NONE ctermbg=24 cterm=NONE guifg=NONE guibg=#204a87 gui=NONE

endif
