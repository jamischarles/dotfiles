"" BASIC KEY Settings ####################################################

" LEADER: commands. | means new command. This is a hack, but works?
nmap <leader>l :set list!<CR>| " Toggle hidden chars
" nmap <leader>q :call CloseCurrentBufferOrWindow()<CR>
" nmap <leader>o :only<CR>| " CLOSE all other windows.
" nnoremap <leader><leader> <C-^>| " Goto last buffer
nmap qq :close<CR>
nmap <leader><tab> <C-w>w| " Go to next window
nnoremap <leader>w :w<CR>

nnoremap <leader>fr :%s/| " SEARCH/REPLACE
" nnoremap <leader>ef <C-w>v<C-w>l<C-w>L:e ~/.config/fish/config.fish<cr>| " Open fish config
" nnoremap <leader>ev <C-w>v<C-w>l<C-w>L:e ~/.vimrc<cr>| " Open Vimrc
nnoremap <leader>sv :source ~/.vimrc<cr>| " Source vimrc - Or just :so % when in this file

nnoremap <leader>; A;<esc>| " Append ; to eol
nnoremap <leader>, A,<esc>| " Append , to eol
nnoremap <leader>N :below 20sp term://node<cr>i| " Node scratch buffer

" maybe do <l>? instead?
" nnoremap <leader>h :split ~/.vim/vimrc/help-shortcuts.md<cr>

" Non Leader: commands
" nnoremap <silent> <tab> :call GotoNextBuffer()<CR>
" one way to solve enter problem with shortened screen (slower though)
" nnoremap <silent> <tab> :call GotoNextBuffer()<CR> :redraw<CR>
" Dobule  enter is a clumsy but effecitve fix for now...
" nnoremap <silent> <S-tab> :call GotoPriorBuffer()<CR>

" REMAP CAPS to BACKTICK key ` for normal mode, ESC for other modes
" nnoremap <BS> `
" nnoremap <BS><BS> `'| " use `` for jump back
" inoremap <BS> <ESC>
" xnoremap <BS> <ESC>

" Preserve backspace with SHIFT-BS (aka SHIFT-CAPSLOCK/DELETE)
inoremap <S-BS> <c-r>=Backspace()<CR>
xnoremap <S-BS> <Del>

" Textmate style newlines in braces (http://stackoverflow.com/questions/6066372/make-vim-curly-braces-square-braces-parens-act-like-textmate)
inoremap {<cr> {<cr>}<c-o><s-o>
inoremap [<cr> [<cr>]<c-o><s-o>
inoremap (<cr> (<cr>)<c-o><s-o>

" PASTE should NOT chante the paste buffer (I should be able to paste 6 times
" check .vimrc.after

" https://dalibornasevic.com/posts/43-12-vim-tips
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

" REMAP O to : since I use : all the time, and almost never use O. See if this
" breaks stuff again..
" nnoremap O :
" nnoremap : O
" nnoremap > O

" https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

"" PLUGIN Keys ###########################################################

" NERDTREE: More settings for this are in ~/.vim/plugin/nerdtree.vim
map <leader>n :NERDTreeToggle<CR> :NERDTreeMirror<CR>
map <C-f> :NERDTreeFind<CR>

" Comment: Line
map <leader>/ gcc<CR>

" Disable leader leader and bind to leader f
map <Leader>f <Plug>(easymotion-bd-f)
map <Leader> <Plug>(easymotion-prefix)

" Snippets: Edit JS snippets file (now handled by <Leader>e)
" nnoremap <leader>es <C-w>v<C-w>l<C-w>L:e ~/.dotfiles/_codesnippets/snippets/javascript.snippets<cr>

" Indentation: Left / right
vmap <leader>[ <Plug>(textmanip-move-left)
vmap <leader>] <Plug>(textmanip-move-right)
nnoremap <leader>] >>
nnoremap <leader>[ <<

" IncSearch Live: (show all results live)
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Search Count: ANZU
nnoremap <silent> <Plug>(anzu-mode-n) :<C-u>call anzu#mode#start(@/, "k", "", "")<CR>
nnoremap <silent> <Plug>(anzu-mode-N) :<C-u>call anzu#mode#start(@/, "K", "", "")<CR>
nnoremap <silent> <Plug>(anzu-mode) :<C-u>call anzu#mode#start(@/, "", "", "")<CR>

" GIT Gutter: TODO: Replace with crtl+
" Gitgutter
" nmap <leader>s <Plug>(GitGutterStageHunk)
" nmap <leader>r <Plug>(GitGutterUndoHunk)
" nmap <leader>p <Plug>(GitGutterPreviewHunk)
" nmap [h <Plug>(GitGutterNextHunk)
" nmap ]h <Plug>(GitGutterPrevHunk)

"Vim signify (like gitgutter
nmap <leader>s <Plug>(GitGutterStageHunk)
" nmap <leader>r :SignifyHunkUndo<CR>
" nmap <leader>p :SignifyHunkDiff<CR>
" nmap [h <Plug>(signify-next-hunk)
" nmap ]h <Plug>(signify-prev-hunk)


nmap <silent> <leader>fc <ESC>/\v^[<=>]{7}( .*\|$)<CR>| " find merge conflict markers - from janus


" TMUX: Restart Server FIXME: can we have this spring us out of scrollmode?
nnoremap <leader>R :silent !tmux send-keys -t 1 Enter C-c C-c hr space - Enter Up Up C-m<CR>| " TMUX: Redo last comand
" nnoremap <leader>R :silent !tmux send-keys -t 1 C-c C-c "history \| sed -r 's/[0-9]*  //' \| grep '^node' -i \| tail -1 \| sh" C-m <CR>

" Undo Tree: - Mundo -
nnoremap <leader>u :MundoToggle<CR>

" Insert Blank Line: - Unimpaired. Below and above
nmap <leader><CR> <Plug>unimpairedBlankDown
" Had to modify iterm2 for this one so it would send the proper keys that nvim
" expects https://stackoverflow.com/questions/16359878/vim-how-to-map-shift-enter
nmap <S-CR> <Plug>unimpairedBlankUp

" Move Line: Vim-TextManip. Move selection down/up   (Ctrl+n, Ctrl+e) in Normal / VISUAL MODE - disabling for HARDTIME
" nmap <C-n> ]e
" nmap <C-e> [e
xmap <C-n> <Plug>(textmanip-move-down)
xmap <C-e> <Plug>(textmanip-move-up)

xmap <leader>d <Plug>(textmanip-duplicate-down)
nmap <leader>d <Plug>(textmanip-duplicate-down)


" Markdown Files:
" Wrap line with ~~
nnoremap wl~ :WrapLine<CR>

" Smooth Scrolling: -
" DISABLED for now...
" nnoremap <silent> N :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 2.7)<CR>
" nnoremap <silent> E :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -2.7)<CR>
" nnoremap <silent> <C-n> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 4)<CR>
" nnoremap <silent> <C-e> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -4)<CR>


" Scrolling: Non-smooth - https://github.com/jooize/vim-colemak#restore-turbo-navigation
" Turbo navigation (Colemak) {{{
    " Works with counts, see ":help complex-repeat"
    " nnoremap <silent> H @='5h'<CR>|xnoremap <silent> H @='5h'<CR>|onoremap <silent> H @='5h'<CR>|
    " nnoremap <silent> N @='5gj'<CR>|xnoremap <silent> N @='5gj'<CR>|onoremap <silent> N @='5gj'<CR>|
    " nnoremap <silent> E @='5gk'<CR>|xnoremap <silent> E @='5gk'<CR>|onoremap <silent> E @='5gk'<CR>|
    " nnoremap <silent> I @='5l'<CR>|xnoremap <silent> I @='5l'<CR>|onoremap <silent> I @='5l'<CR>|
" }}}
" Full page up/down in all the modes
nnoremap <silent> <C-E> <C-U><C-U>
vnoremap <silent> <C-E> <C-U><C-U>
inoremap <silent> <C-E> <C-\><C-O><C-U><C-\><C-O><C-U>

nnoremap <silent> <C-N> <C-D><C-D>
vnoremap <silent> <C-N> <C-D><C-D>
inoremap <silent> <C-N> <C-\><C-O><C-D><C-\><C-O><C-D>


" Half page up/down in all the modes
" FIXME: hacky for my fixed size... Calc this so it caluclates half page
" naturally
nnoremap <silent> E 22<C-Y>
vnoremap <silent> E 22<C-Y>
nnoremap <silent> N 22<C-E>
vnoremap <silent> N 22<C-E>
" nnoremap <silent> E :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -4)<CR>

" nnoremap <silent> E <C-Y>
" map N :set scroll=0<CR>:set scroll^=2<CR>:set scroll-=1<CR><C-D>:set scroll=0<CR>
" map E :set scroll=0<CR>:set scroll^=2<CR>:set scroll-=1<CR><C-U>:set scroll=0<CR>


" WINDOW RE-SIZING. FIXME: Add zoom window back?
" nnoremap <silent> <C-_> :WindowVInc<CR>
" <c-_> is how you do ctrl -
" nnoremap <c-_> :WindowVInc<CR>
nnoremap <silent> - :WindowVInc<CR>
nnoremap <silent> _ :WindowVDec<CR>
" nnoremap <silent> <leader>- :WindowMax<CR>
nnoremap <silent> <leader>_ :WindowMin<CR>
nnoremap <silent> <leader>- :WindowMin<CR>
nnoremap <silent> <leader>= :WindowEq<CR>

" Fuzzy Finder: FZF
" FIXME: use rg or fd instead (FASTER)
" \   'source': 'ag -g \"\" --hidden --ignore .git --ignore node_modules',
" \   'source': 'fd --type file --hidden --exclude .git',
"
" \   'options': winwidth(0) > 140 ? '' : '--multi --exact --tiebreak=begin,length,index --preview="~/.vim/plugged/fzf.vim/bin/preview.sh {}" --preview-window right:60%',
nnoremap <silent> <Leader>t :call fzf#run({
\   'source': 'rg --files --hidden --glob="!.git/*"',
\   'options': '--multi --exact --tiebreak=begin,length,index ' . ShowPreviewIfWideWindow(),
\   'window': { 'width': 1, 'height': 1 },
\   'sink': function('Dontopeninnerdtree')
\ })<CR>

" include node_modules
nnoremap <silent> <Leader>T :call fzf#run({
\   'options': '--exact --tiebreak=end,length ' . ShowPreviewIfWideWindow(),
\   'window': { 'width': 0.98, 'height': 0.98 },
\   'sink': function('Dontopeninnerdtree')
\ })<CR>

"  https://github.com/junegunn/fzf/issues/274 https://unix.stackexchange.com/questions/64736/combine-output-from-two-commands-in-bash
nnoremap <silent> <Leader>e :call fzf#run({
 \'source': 'find ~/.vim/vimrc/* -type f; find ~/.vimrc; find ~/.dotfiles/_codesnippets/snippets/javascript.snippets; find ~/.config/fish/config.fish; find ~/.vim/after/plugin/* -type f; find ~/.config/karabiner.edn; find ~/.config/starship.toml; find ~/.dotfiles/makesymlinks.sh; find ~/.config/alacritty.yml; find ~/.byobu/.tmux.conf; find ~/.byobu/color.tmux; find ~/.byobu/keybindings.tmux',
\   'options': '--multi --exact --tiebreak=end,length ' . ShowPreviewIfWideWindow(),
\   '_hide_window': 1,
\   'sink': function('Dontopeninnerdtree')
\ })<CR>


function! ShowPreviewIfWideWindow()
	" if window is wider than 140 chars, then add the preview options to fzf
	if winwidth(0) > 140
		return '--preview="~/.vim/plugged/fzf.vim/bin/preview.sh {}" --preview-window up:60%'
	else
		return ''
	endif
endfunction

" | " Use the MRU cache
" nnoremap <silent> <Leader>m :FzfHistory<CR>
nnoremap <silent> <Leader>m :FzfLua oldfiles<CR>
" nnoremap <silent> <Leader>g :FzfGitFiles?<CR>
" TODO: can we make this optional too? yes. Just make a short variant and call
" the fn the same way...
" FIXME: Add one for FzfLua git_stash git stash BONUS
" nnoremap <silent> <Leader>g :call fzf#vim#gitfiles('?', {'options': '--preview-window down:60%'})<CR>
nnoremap <silent> <Leader>g :FzfLua git_status<CR>
" nnoremap <silent> <Leader>g :lua require('fzf-lua').git_status({winopts = {height = 0.3}, git = {status={cmd = 'git status'}}, fzf_opts = {['--layout'] = 'reverse-list'} })<CR>
" nnoremap <silent> <Leader>g :lua require('fzf-lua').git_status({git = {status = {cmd= 'ls'}}, fzf_opts = {['--layout'] = 'reverse-list'} })<CR>
" nnoremap <silent> <Leader>g :lua require('fzf-lua').git_status({git = {status = {cmd= 'ls'}}, fzf_opts = {['--layout'] = 'reverse-list'} })<CR>

" FzfLua lines (search all open buffers)

" FIXME: Replace with LSP / FZF Lua things...
nnoremap <silent> <Leader>B :FzfBTags<CR>
nnoremap <silent> <Leader>C :FzfTags<CR>
" nnoremap <silent> <Leader>b :FzfBuffers<CR>
" nnoremap <silent> <Leader>b :call fzf#vim#buffers({'options': '--preview-window up:60%'})<CR>
" nnoremap <silent> <Leader>b :FzfLua buffers<CR>

" https://github.com/junegunn/fzf.vim/pull/733#issuecomment-559720813
function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

" Deletes all seleced buffers
command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))


" scratch paper
nnoremap <silent> <Leader>s :e ~/.dotfiles/scratchpaper.md<CR>

" Yank sugar (highlight etc) https://github.com/neoclide/coc-yank
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

"" MACROS ###################################################################
" 1) Record (q + letter) 2) :reg to find it 3) Replace <80> with Ctrl+v Esc (in insert mode)
" http://stackoverflow.com/questions/2943555/how-to-save-a-vim-macro-that-contains-escape-key-presses
" function() -> () =>"
let @f = 'dw%t =>'
" require statement -> import
let @i = '^dwsimport f=dwdwsfrom ixf)xn^'
" react.createClass -> class syntax
let @c = '^dwsclass kbf=xsextendskbfcfcdwsComponentkbir i%ixx'

