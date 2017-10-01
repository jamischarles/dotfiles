"" BASIC KEY Settings ####################################################

" LEADER: commands. | means new command. This is a hack, but works?
nmap <leader>l :set list!<CR>| " Toggle hidden chars
nmap <leader>q :call CloseCurrentBufferOrWindow()<CR>
nmap qq :close
nmap <leader><tab> <C-w>w| " Go to next window
nmap <leader>o :only<CR>| " CLOSE all other windows.
nnoremap <leader>w :w<CR>

nnoremap <leader>fr :%s/| " SEARCH/REPLACE
" nnoremap <leader>ef <C-w>v<C-w>l<C-w>L:e ~/.config/fish/config.fish<cr>| " Open fish config
" nnoremap <leader>ev <C-w>v<C-w>l<C-w>L:e ~/.vimrc<cr>| " Open Vimrc
nnoremap <leader>sv :source ~/.vimrc<cr>| " Source vimrc - Or just :so % when in this file

nnoremap <leader>; A;<esc>| " Append ; to eol
nnoremap <leader>, A,<esc>| " Append , to eol
nnoremap <leader><leader> <C-^>| " Goto last buffer
nnoremap <leader>N :below 20sp term://node<cr>i| " Node scratch buffer

" Non Leader: commands
nnoremap <silent> <tab> :call GotoNextBuffer()<CR>
nnoremap <silent> <S-tab> :call GotoPriorBuffer()<CR>

" REMAP CAPS to BACKTICK key ` for normal mode, ESC for other modes
nnoremap <BS> `
nnoremap <BS><BS> `'| " use `` for jump back
inoremap <BS> <ESC>
xnoremap <BS> <ESC>

" Preserve backspace with SHIFT-BS (aka SHIFT-CAPSLOCK/DELETE)
inoremap <S-BS> <c-r>=Backspace()<CR>
xnoremap <S-BS> <Del>

" Textmate style newlines in braces (http://stackoverflow.com/questions/6066372/make-vim-curly-braces-square-braces-parens-act-like-textmate)
inoremap {<cr> {<cr>}<c-o><s-o>
inoremap [<cr> [<cr>]<c-o><s-o>
inoremap (<cr> (<cr>)<c-o><s-o>

" REMAP O to : since I use : all the time, and almost never use O
nnoremap O :
nnoremap > :

"" PLUGIN Keys ###########################################################

" NERDTREE: More settings for this are in ~/.vim/plugin/nerdtree.vim
map <leader>n :NERDTreeToggle<CR> :NERDTreeMirror<CR>
map <C-f> :NERDTreeFind<CR>

" Comment: Line
map <leader>/ gcc<CR>

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
nmap <leader>s <Plug>GitGutterStageHunk
nmap <leader>r <Plug>GitGutterUndoHunk
nmap <leader>p <Plug>GitGutterPreviewHunk
nmap [h <Plug>GitGutterNextHunk
nmap ]h <Plug>GitGutterPrevHunk

nmap <silent> <leader>fc <ESC>/\v^[<=>]{7}( .*\|$)<CR>| " find merge conflict markers - from janus


" TMUX: Restart Server
nnoremap <leader>R :silent !tmux send-keys -t 1 C-c C-c hr space - Enter Up Up C-m<CR>| " TMUX: Redo last comand
" nnoremap <leader>R :silent !tmux send-keys -t 1 C-c C-c "history \| sed -r 's/[0-9]*  //' \| grep '^node' -i \| tail -1 \| sh" C-m <CR>

" Undo Tree: - Mundo -
nnoremap <leader>u :MundoToggle<CR>

" Insert Blank: Line - Unimpaired
nmap <leader><CR> <Plug>unimpairedBlankDown

" Move Line: Vim-TextManip. Move selection down/up   (Ctrl+n, Ctrl+e) in Normal / VISUAL MODE - disabling for HARDTIME
" nmap <C-n> ]e
" nmap <C-e> [e
xmap <C-n> <Plug>(textmanip-move-down)
xmap <C-e> <Plug>(textmanip-move-up)

xmap <leader>d <Plug>(textmanip-duplicate-down)
nmap <leader>d <Plug>(textmanip-duplicate-down)


" Smooth Scrolling: -
nnoremap <silent> N :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 2.7)<CR>
nnoremap <silent> E :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -2.7)<CR>
nnoremap <silent> <C-n> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 4)<CR>
nnoremap <silent> <C-e> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -4)<CR>


" WINDOW RE-SIZING. FIXME: Add zoom window back?
" nnoremap <silent> <C-_> :WindowVInc<CR>
" <c-_> is how you do ctrl -
nnoremap <c-_> :WindowVInc<CR>
nnoremap <silent> _ :WindowVDec<CR>
" nnoremap <silent> <leader>- :WindowMax<CR>
nnoremap <silent> <leader>_ :WindowMin<CR>
nnoremap <silent> <leader>= :WindowEq<CR>

" Fuzzy Finder: FZF
nnoremap <silent> <Leader>t :call fzf#run({
\   'source': 'ag -g "" --hidden --ignore .git ',
\   'options': '--multi --exact --tiebreak=end,length',
\   'down': '~40%',
\   'sink': function('Dontopeninnerdtree')
\ })<CR>

" include node_modules
nnoremap <silent> <Leader>T :call fzf#run({
\   'options': '--exact --tiebreak=end,length',
\   'down': '~40%',
\   'sink': function('Dontopeninnerdtree')
\ })<CR>

"  https://github.com/junegunn/fzf/issues/274 https://unix.stackexchange.com/questions/64736/combine-output-from-two-commands-in-bash
nnoremap <silent> <Leader>e :call fzf#run({
 \'source': '{find ~/.vim/vimrc/* -type f; find ~/.vimrc; find ~/.dotfiles/_codesnippets/snippets/javascript.snippets; find ~/.config/fish/config.fish; find ~/.vim/after/plugin/* -type f;}',
\   'options': '--multi --exact --tiebreak=end,length',
\   'down': '~40%',
\   'sink': function('Dontopeninnerdtree')
\ })<CR>

nnoremap <silent> <Leader>m :FzfHistory<CR>| " Use the MRU cache
nnoremap <silent> <Leader>g :FzfGitFiles?<CR>
nnoremap <silent> <Leader>b :FzfBTags<CR>
nnoremap <silent> <Leader>B :FzfBuffers<CR>


"" MACROS ###################################################################
" 1) Record (q + letter) 2) :reg to find it 3) Replace <80> with Ctrl+v Esc (in insert mode)
" http://stackoverflow.com/questions/2943555/how-to-save-a-vim-macro-that-contains-escape-key-presses
" function() -> () =>"
let @f = 'dw%t =>'
" require statement -> import
let @i = '^dwsimport f=dwdwsfrom xf)xn^'
" react.createClass -> class syntax
let @c = '^dwsclass kbf=xsextendskbfcfcdwsComponentkbir i%ixx'

