# NOTES:


## Airline Tab color changes
- 1) adjust the color palette for edited, but not saved in the command line...
- 2) See if I can write my own that is this good...?
- 3) Add total buffer number?
- 4) Remove hunks? Pair down the mode lenght?

- Can we change tab color / tab symbol based on uncomiited
- Top tab color in normal:
   - 1 color for unsaved changes
   - 1 (color /) symbol for uncommitted changes (use gitgutter for that?) (then) (start small)
   - for unselected tabs, just fade the above symbols / colors. Let
   - write a post on how to do this?!? after I do it...
- top tab color in non-normal modes...

   Things to fix after this:
   - why does hunk info on bottom disappear?
   - why do all the same buffers keep opening?



## TODO: PROCESS TIHIS!!!!

from vimrc
```

hi airline_tabmod
" let g:airline#themes#solarized#palette.inactive.airline_c=['#073642', '#657b83', '0', 11, '']
" Changes file area when in normal mode in othre tabs?
autocmd VimEnter * :highlight airline_c ctermfg=28 ctermbg=16| " :highlight airline_c
" this seems to clobber the bottom one?
autocmd BufEnter * :highlight airline_c ctermfg=28 ctermbg=16| " :highlight airline_c


" Changes file area for each mode !!! in statusline
autocmd BufEnter *
      \ let g:airline#themes#solarized#palette.insert_modified = {
      \ 'airline_c': [ '#000000' , '#5f005f' , 255     , 53      , ''     ] ,
      \ }

" Changes file area for inactivve modified?
autocmd BufEnter *
      \ let g:airline#themes#solarized#palette.inactive_modified = {
      \ 'airline_c': [ '#000000' , '' , 97 , '' , '' ] ,
      \ }

```

```
" hi TabLine      ctermfg=Black  ctermbg=Green     cterm=NONE
" hi TabLineFill  ctermfg=Black  ctermbg=Green     cterm=NONE
" hi TabLineSel   ctermfg=White  ctermbg=DarkBlue  cterm=NONE
autocmd BufEnter * hi clear airline_tabmod
" autocmd BufEnter * hi airline_tabmod ctermfg=White ctermbg=Green cterm=NONE
autocmd BufEnter * hi airline_tabmod ctermfg=White ctermbg=Red cterm=reverse

" Change buffer color based on MODE!!!
" autocmd InsertEnter * hi airline_tabmod ctermfg=Red ctermbg=White cterm=reverse
autocmd InsertEnter * hi airline_tabmod cterm=bold ctermfg=15 ctermbg=3 gui=bold guifg=#fdf6e3 guibg=#b58900
" autocmd VisualEnter * hi airline_tabmod cterm=bold ctermfg=15 ctermbg=3 gui=bold guifg=#fdf6e3 guibg=#b58900
autocmd InsertLeave * hi airline_tabmod ctermfg=Red ctermbg=White cterm=NONE
" https://stackoverflow.com/questions/15561132/run-command-when-vim-enters-visual-mode
" this is
" default tab_mod color
" airline_tabmod cterm=bold ctermfg=15 ctermbg=3 gui=bold guifg=#fdf6e3 guibg=#b58900

" TODO: Ask them for this...
" https://github.com/vim-airline/vim-airline/blob/a914cfb75438c36eefd2d7ee73da5196b0b0c2da/autoload/airline/highlighter.vim
"
" autocmd BufEnter * let g:airline#themes#solarized#palette.inactive.airline_c=['#657b83' , '#073642', '0', 11, '']
" autocmd BufEnter * let g:airline#themes#solarized#palette.inactive.airline_c=['#657b83' , '#073642', '5', 3, '']
" autocmd BufEnter * let g:airline#themes#solarized#palette.inactive.airline_c=['White' , 'Red', '0', 11, '']

" inactive_modified.airline_c

autocmd VimEnter *
   \ let g:airline#themes#solarized#palette.tabline = {
   \    'airline_tabmod':       ['#f8f8f8','#780000',231,88,''],
   \    'airline_tabmod_unsel': ['#dddddd','#463030',231,52,''],
   \ } | :AirlineRefresh

" let g:airline#themes#solarized#palette.tabline.airline_tab = ['#eee8d5', '#657b83', 7, 11, '']
autocmd VimEnter * let g:airline#themes#solarized#palette.tabline.airline_tab = ['red', '#657b83', 7, 11, ''] | :AirlineRefresh
```


 List other implied files
## Short TODO LIST:
 - fix markdown folding text. Just use my own, and remove the plugin
 - Add this: https://github.com/tpope/vim-repeat (allows you to repeat other motions with . (like searches))
 - fix t, insert modes in visual mode...
   fix t in normal mode too? swap with ctrl?
   fix the surround motions
   make MRU be local project only...

## BUFFER COLOR: Change buffer changed color (see email
## Edit:
 - <leader>e send dotfiles/vimrc to fzf

## SCROLLING:
 - Allow small scroll while keeping cursor in place (good for PS)
 Make key for "CLOSE" current window. instead of having to jump to the other.
 'q' should always do that... In all kinds of windows (help, location, etc)
 one...
## UNDO: Add keystroke / command for clearing undo history - add undo visualizer plugin...
   - add an undo stage limit... 100?!?


## FOLDS: Add custom folds to this file with  pattern?
 Change buffer modified color? (have buffer share mode color?)
 C-Z to undo in insert mode? (esc too?)
 C-U
 Replace nerdtree with find/tree + fzf?
 - Remove 1 line folds
 - Troubleshoot why some are missing
## FZF:
 - Combine all fzf modes with tab like ctrl p had. cycle modes like ctrl-p
 - Maybe denite? Or combine the 2? basically enter FIND mode
## Search:
   - on insert wipe highlidht
   https://vi.stackexchange.com/questions/10407/stop-highlighting-when-entering-insert-mode
   - fix live search to include the index count. on incsearch.vim I don't want to have to use
   all these plugins to use orthogonal functionality
## Marks: - fix the fact that marks stay after close
   - change shift bs to be ` in all modes? Verify fixed in vim-signature

 TODO TextObjects: Make some more for JS, install comment one... etc.
 TODO Folding: remap [[ ]] to navigate the folds
   - add zebra striping / INCREASE CONTRAST
   - need to easily be able to jump to the next method / class / func
   - fix folds to auto fold 2 levels but load open
   - add folds to vimrc
 Map git keys to ctrl+ (like leeader p,r etc)
 Try to swatch swap O for : again (messes me up in insert mode. Use execute
 in command? (look at learnvimscript the hard way)
 Turn on alt for another layer of keys.
 CTAGS: Improve btags output... Closer to ctags...
 YANK RING?
 Think about going back to u, y, x, d as much as possible. Would love to get
 Maybe use ctrl for a lot of these... c-u c-y c-p
 back to natural language.
 Fix smooth scroll (don't go past the bottom of the line.
 " even normal ctrl scroll goes too far :{
 FIX: ZOOM WINDOW
 FIX: smarter swap warning (or at least force :e)? Use plugin that guy
 wrote? auto-swap?
 FIX t (till) in normal mode...
 FIX TAGBAR for classes. Why not nested? Remove node_modules.
 We can use that to show file outline if it shows up properly.
 Figure out how not to overwrite when buffer is open? Add warning?

 Find replacement for moving lines up and down... use it all the time. Cut
 from x line and paste somewhere else.
 Fix scroll highlight

 Q: p for paste again?

 Disable cpaps repeat?
 Remap <leader>f to <ctrl>-f and use that for a file buffer or ctrl T or
 something...

 - Turn on zoom window again?

 - fix inline anzu (fix *#/ as well)
 - turn on yankring / yankstack, or disable delete wiping yank history
 - have nvim use fish for terminal?

 - add key for btags MONEY, and / or add it to denite
 - fix tagbar exit with leader tab. Add toggle key? (turn it off for certain
   files to aviod being slow...)
 - integrate ripgrep with fzf. Maybe full / partial screen takeover... Goal
   is to easily see all the results of your search. Both in same file and
   across buffers / files.
   (LEADER-F maybe?)



###############################3
 PLUGINS to consider - https://vimawesome.com/
 https://vi.stackexchange.com/questions/12250/is-there-vim-plugin-that-can-show-keystroke-maps-or-abbreviations-for-command-af

 Grep for all things https://github.com/mhinz/vim-grepper
 Sane buffer deletion https://github.com/mhinz/vim-sayonara
 Git status https://github.com/mhinz/vim-signify

https://github.com/mhinz/vim-startify/blob/master/README.md (start screen MRU
etc)... ***
https://vimawesome.com/plugin/abolish-vim (rename vars )
https://vimawesome.com/plugin/ferret (find)
https://vimawesome.com/plugin/searchcomplete
https://vimawesome.com/plugin/indexedsearch
http://vimcasts.org/blog/2013/02/habit-breaking-habit-making/ READ ***
https://github.com/takac/vim-hardtime (block basic movements) ***
https://github.com/ryanoasis/vim-devicons (add glyphs to fonts)
https://github.com/ddrscott/vim-side-search/blob/master/README.md (side
search)
https://vimawesome.com/plugin/vim-sneak (motion)
 https://github.com/metakirby5/codi.vim Interactive REPL
##########################3


 look at this: https://github.com/clvv/fasd
 - integrate unite / denite...
 - add window zoom back in...

 - think about more sensible general purpose shortcuts
   or commands for many things. leader-r doesn't make
   much sense. I need more senisble eaiser to remimber stuff

## HELP Section:
 - :h [topic]
 - C-] on link will take you there. Ctrl-t will return

## VARIABLES:
 - :h internal-variables

## DEBUGGING:
 - https://vi.stackexchange.com/questions/7722/how-to-debug-a-mapping debug
   mapping
 - Show variables in global, buffer, etc - :let g: :let :b etc...  https://codeyarns.com/2010/11/26/how-to-view-variables-in-vim/ ##############################

## QUICK KEYS:,###################
 ~/.vim/after/plugin/ - is where several things are placed that must be
 applied after this file

 Unassigned keys <leader> \ leader j
 Reassign git leader keys to ctrl?

## Philosophy:
 - use leader for frequent and very important stuff. Actions as it were.
   user straight keys when you're in the flow of someting and it's more in
   context.
 - Use ctrl+ for infrequent actions, and / or if it's an escalation.
   Letter -> shift+letter -> ctrl+letter

 Embrace modes! That's really the key I think. Think about how modes differ
 and how you can use context and modifier keys to work in your advantage. ie:
 Having numbers disabled / inverted in N mode makes complete sense if you never jump to
 line num.

 Try to stick with native vim stuff and learn that as much as possible. Avoid
 plugins that modify original behavior and remap strokes. Try instead to use
 plugins that enhance or make them more clear (like smooth scrolling etc).

 Try to use normal mappings and letters as much as possible. This will make
 it easier to switch to normal vim and back...

 - TODO: Use ctrl+ for more stuff. Consider moving some of the leader keys
   there. Either group classes of things (like nav), or move them by
   frequency used... After using them I can usually feel how nice or awkward
   they are...

## DEBUGGING: ********************************
 http://inlehmansterms.net/2014/10/31/debugging-vim/
 https://stackoverflow.com/questions/12213597/how-to-see-which-plugins-are-making-vim-slow
 List user defined commands - :command
 Show last defined command place -  :verbose command [cmdName]
 Show buffer vars - :let b:       https://codeyarns.com/2010/11/26/how-to-view-variables-in-vim/
 Debug mappings - :verbose map [mapping]     https://vi.stackexchange.com/questions/7722/how-to-debug-a-mapping/7723
 Filetype mappings - https://stackoverflow.com/questions/6133341/can-you-have-file-type-specific-key-bindings-in-vim

## NAVIGATION: ********************************
 TODO:
 - Learn text objects. Especially inside visual mode
 Find on line - f/F then ;/, to forward/backward (t) does minus one
 Last insertion point / edit - `.   (TODO: Make it g. ?)
 Last insertion point - gs
 Last selection ga
 Last normal point (when closing the file) -  `"
 Last insert point (when closing the file) - `^
 Previous jump - Ctrl-o (cycles back in history)
 Jump 5 lines ahead / back -  5+/-
 last 2 jump points? -  `' (jump back) ***
 Next METHOD - [m  ***
 Next BLANK line - {}

 TODO:
 - Consider making these ctrl-LHM
 H M B - Cursor to TOP MIDDLE BOTTOM of current screen. No scroll.

## Marks: http://vim.wikia.com/wiki/Using_marks
 mx - set mark x (uppercase mark can be retrieved across files).
 dmx - delete marx (mx mx will set/delete)
 m<space> - remove all marks from file
 m/ - show all tags in current file
 Phantom marks? https://github.com/kshenoy/vim-signature/issues/72

## Folding: http://vim.wikia.com/wiki/folding
 TODO:
 - Fix vim origami if I need it. Currently I don't. Need to map the
 autoload fns directly to get it to work with my mappings.
 https://stackoverflow.com/questions/5074191/vim-fold-top-level-folds-only
 http://learnvimscriptthehardway.stevelosh.com/chapters/48.html

 10jF - Create fold for next 10 lines
 Toggle fold - ja
 jn je - next / previous fold
 jd je - delete folds (current / all)
 jo jc - open / close fold
 jj je - next / previous fold
 jM jr - Open / Close all folds
 Make visual block a fold - jf
 Q: How to add fold with level? 1jf?
 Q: How to add fold at end of screen (certain colum)?


 Motions all over the screen (easy motion type)
 https://github.com/easymotion/vim-easymotion
 https://vimawesome.com/plugin/vim-sneak

 Jumping on same line (use 2 letters with f) ***
 https://github.com/goldfeld/vim-seek  https://vimawesome.com/plugin/clever-f-vim (better f)
 https://vimawesome.com/plugin/smartword (smarter word WORD)

 Custom Motions: https://vimawesome.com/plugin/countjump , https://github.com/okcompute/vim-javascript-motions
 Smart jumps (halfway points etc): https://github.com/jayflo/vim-skip , https://github.com/mikezackles/Bisect

 Smooth scrolling https://vimawesome.com/plugin/comfortable-motion-vim (for
 G)?

 TODO:
 Challenge - Use vim-hardline to learn better nav
 Challenge - Stop using nerdvim.
 Challenge - Turn off tab switching. Use marks / jumps instead.
 https://dockyard.com/blog/2014/04/10/vim-on-your-mark.


## COPY PASTE: management######################
 :reg lists all registers
 "2v - paste the 2nd register
 p - paste after cursor
 P - paste before cursor
 ga - go to last selection
 " These below replace the ctrl moving code I had before...
 <space>v will insert a space and THEN paste it... SWEET

## SELECTION COMMANDS:
 :125y  - copy line 125 AMAZING
 :125t2 - copy line 125 to below line 2
 :125t. - copy line 125 to below cursor
 :130m. - move 130 to below cursor
 :130d - delete 130 from where you are. AMAZING.
 "
 :8,10TComment - Run TComment command on lines 8-10
 https://stackoverflow.com/questions/15069613/how-to-copy-by-specifying-line-numbers-in-vi

 TODO: make 125 insert, 125 o work
 TODO: Consider turning upy back on for the default actions...?

## TEXT OBJECTS: **********************
 https://github.com/glts/vim-textobj-comment
 https://github.com/kana/vim-textobj-user *** define your own


## WORD WRAPPIN: *********************
 Wrap, delete quotes, etc - ds* delete surrounding *, w** wrap [modifier] with *, cs** change surrounding a with b
 dst - Delete surrounding Tag - dst
 ds( delete surrounding (
 cs"' change surrounding "
 cst - Change surrounding Tag - cst<em>


## BUFFER Managment: **************************
 :CtrlPBufTag[All] - Search for a tag within all listed buffers
 <leader>b - Search currently open buffers
 :BufOnly - Close others

## WINDOW MANAGMENT: ************************
 :Close - Close current window
 <leader>o - close other windows
 <leader>q - close buffer and/or window

 Max out the height of the current split
 -  - Bigger vsplit
 _  - Smaller vsplit
 <leader>-  - Max split
 <leader>_  - Min Split
 <leader>=  - EQ Split window (kill mappings we don't use



## FIND FUNCTION DEFINITIONS ***************
 gf - go file
 gd - go definition (same file)

 COLUMN SELECT Ctrl-V

 CLOSE all other windows - <leader>o

 RESUME Search - //

 OPEN URL IN BROWSER - gx   (consider mapping to gb) - http://stackoverflow.com/questions/9458294/open-url-under-cursor-in-vim-with-browser

## GIT ********************************
 Cheatsheet - https://gist.github.com/dialelo/5902072
 :Gedit develop:public/js/view/transfer/page/enter.js - open this file in github
 Gtabedit HEAD^:public/templates/transfer/index.dust
 :Gvsplit


 :Gstatus - then use '-' to stage/unstage files. 'p' to stage hunks.
 :Gvdiff  - Vertical diff
 :gd
 :gco - reset file (git checkout)

 [h - next hunk (next git change)
 ]h - previous hunk
 <leader>fc - Find conflict

 TODO: Move these to ctrl? since they aren't used that often?
 <leader>p GitGutterPreviewHunk
 <leader>s GitGutterStageHunk
 <leader>r GitGutterRevertHunk

 in DIFF:
   :diffget - Get change from the other window.
   :diffput - Push change to the other window.


 :imap    See the current insert mappings
 :verbose imap <tab>   See what's currently mapped to tab in insert mode

## BREW INSTALLATIONS...
 brew install diff-so-fancy (better than npm)
 Global NPM installs
 https://github.com/stevemao/diff-so-fancy
 or brew?

 brew install colordiff
 - https://github.com/universal-ctags/homebrew-universal-ctags

 Good Fonts:
 Inconsolata is best for presentations.



 - Menlo best for coding

 - meslo is fork with better line spacing

