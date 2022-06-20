" vim: set nofoldenable:
" let g:OrigamiMap = {
"         \ 'Leader'           : "j",
"         \ 'Align'            : "a",
"         \ 'AlignAll'         : "A",
"         \ 'CommentedOpen'    : "F",
"         \ 'UncommentedOpen'  : "f",
"         \ 'CommentedClose'   : "C",
"         \ 'UncommentedClose' : "c",
"         \ 'Delete'           : "D",
"         \ }



"" SEARCHING using Ctrlsf
" let g:ctrlsf_ackprg = 'rg'
let g:esearch = {'adapter': 'rg'}

" https://github.com/brooth/far.vim " Find and replace. Looks great*** "
"
"
"higlight when f,F is pressed https://github.com/unblevable/quick-scope
let g:qs_highlight_on_keys = ['f', 'F']

""
"" SEARCHING from ACK / AG. Silver Searcher. Use AG instead of ack for ack plugin...
""
":AgFromSearch
":AgFile - Search for filename
" FIXME: Can we have it use the project root? Or do we need to hardcode that?
if executable('ag')
  " let g:ackprg = 'ag --vimgrep'
  let g:ackprg = 'ag --nogroup --nocolor --column'
endif

" Turn off mappings
let g:ag_apply_lmappings=0
let g:ag_apply_qmappings=0

" PIPE allows us to use another command
let g:ag_qhandler="vert copen|WindowEq" "start searching from project root
let g:ag_working_path_mode="r"


"" CTAGS
" after that, you ctrl-] and :tag to do cool stuff. Ctrl-t brings you back.  https://medium.com/usevim/vim-101-tags-bc55bc21e130.
command! CtagGenerate :call plug#helptags()
" Tell tagbar to use btags for Tagbar
let g:tagbar_type_javascript = {
    \ 'replace' : 1,
    \ 'kinds' : [
        \ 'c:classes',
        \ 'f:methods',
        \ 'v:variables',
        \ 'i:imports',
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 'c' : 'class',
    \ },
    \ 'ctagsbin' : 'btags',
    \ 'ctagsargs' : ''
\ }


"" Smooth Scrolling Plugin - Disabled for now
" let g:comfortable_motion_no_default_key_mappings = 1
" let g:comfortable_motion_impulse_multiplier = 0.8 " Feel free to increase/decrease this value.

"" Limit Motion nav HARD-TIME. Limits using the nav easy nav above...
let g:hardtime_showmsg = 1
let g:hardtime_default_on = 0 "Change to 1 for on
let g:hardtime_maxcount = 5

let g:list_of_normal_keys = ["h", "n", "e", "i", "x", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:list_of_visual_keys = ["h", "n", "e", "i", "x", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:list_of_insert_keys = ["<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:list_of_disabled_keys = []

"" Search count - https://gist.github.com/cognitivegears/a854e6b45a29b8fed007c3b05c757fe4  Unite and Anzu?  ?
let g:anzu_enable_CursorMoved_AnzuUpdateSearchStatus=1

"" IncSearch live search
let g:incsearch#auto_nohlsearch = 1 " Turn off highlight automagically when it makes sense


"" Autocompletion, and snippets... Util-snips. http://vimcasts.org/episodes/meet-ultisnips/
let g:UltiSnipsExpandTrigger="<tab>"
"https://github.com/Shougo/neosnippet.vim
" let g:deoplete#enable_at_startup = 1
" let g:neosnippet#enable_snipmate_compatibility = 1
" let g:neosnippet#snippets_directory='~/.dotfiles/_codesnippets/snippets'


" COC and TAB
" go the proper direction with tab
let g:SuperTabDefaultCompletionType = "<c-n>"
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

"
"https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources#use-cr-to-confirm-completion
"Confirm selection with enter
" :help complete_ctrl-y (explanation to this madness is here...)
" inoremap <expr> <cr> pumvisible() ? <SID>acceptSelectionAndExitInsertMode() : "\<C-g>u\<CR>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" inoremap <expr> <cr> pumvisible() ? "\<C-y>\<C-[>" : "\<C-g>u\<CR>"
" inoremap <expr> <cr> pumvisible() ? "\<C-y>Hello" : "\<C-g>u\<CR>"
" inoremap <expr> <cr> pumvisible() ? "\<C-y>\<C-r>\=:hello" : "\<C-g>u\<CR>"
" inoremap <cr>  acceptSelectionAndExitInsertMode()
" inoremap <expr> <cr> <SID>acceptSelectionAndExitInsertMode()
" inoremap <expr> <cr> pumvisible() ? "\<C-g>:normal" : "\<C-g>u\<CR>"
"

" Autocomplete on the command bar
" PYTHON :(. TODO: try to use
"https://github.com/hrsh7th/nvim-cmp instead. Or then use this and install
"stupid python
" https://github.com/gelguy/wilder.nvim
" call wilder#setup({'modes': [':', '/', '?']})


" COC and ENTER
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" TODO: change single quotes back to boudle quotes if uncommended
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              " \: '\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>'
                              "
" After confirm via enter, leave the insert mode...
" inoremap <silent><expr> <cr> pumvisible() ? "\<C-r>=coc#_select_confirm()\<CR>\<ESC>"
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"


" https://github.com/neoclide/coc.nvim/issues/1445
" Map gd to function definition using COC
nmap <silent> gd <Plug>(coc-definition)


function! s:acceptSelectionAndExitInsertMode()

  if pumvisible()
    \<C-y>
  else
    echo "exit"
    :exe "echo 'hi my friend'"
    return "hello my friend\<C-]>"
    " return "\<C-]>"

  endif

  " return "\<C-y>\<C-O>"
  return ":normal"
  " return "hello"
  " return call feedkeys("\<C-y>")
  " execute "normal \<C-y>"
endfunction
  " :normal


function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'


"" Files: Nerdtree
let g:NERDTreeShowHidden=1 	 " Show hidden files by default
let NERDTreeQuitOnOpen=1 " Close Nerdtree after opening file

"" Files: FZF
let g:fzf_command_prefix = 'Fzf'

" Always enable preview window on the right with 60% width
" let g:fzf_preview_window = 'right:60%'
" Disable preview for anything that's not custom and defined in key file...
" let g:fzf_preview_window = []


" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
" - window (nvim only)
"   Other FZF stuff found in keys file
" let g:fzf_layout = { 'down': '~100%' }


" let g:fzf_layout = { 'down': '~100%' }
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }

" let g:fzf_layout = { 'down': '~30%' }

" Customize fzf colors to match your color scheme
" TODO: Change this?
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }


" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] to customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

"" File search: (same file)?
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
" Use ag instead of grep for ctrlp
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  " http://stackoverflow.com/questions/18285751/use-ag-in-ctrlp-vim
  " No idea why this ignore works, but this appears to ignore non-us locales
  " folders
  " If you use user command, the custom_ignore doesn't apply...
  let g:ctrlp_user_command = 'ag %s -l --ignore .git --hidden -g ""'
  " let g:ctrlp_user_command = 'ag %s -l  --ignore .git --hidden -g ""'


  " ag is fast enough that CtrlP doesn't need to cache
  " let g:ctrlp_use_caching = 0

endif

"" StatusLine / Airline
" Show tabs & buffers at the top
" let g:airline#extensions#tabline#enabled = 1
" let g:airline_powerline_fonts = 1     " use nice arrow symbols etc

" Disable "mixed indent" warnings for airline status bar (false positives)
" let g:airline#extensions#whitespace#enabled = 0

"" Linter / Neomake
" FIXME: Turn this back on
" let g:neomake_javascript_enabled_makers = ['eslint']
" If eslint exec exists, use that.
" let eslint_path = '/Users/jacharles/dev/p2pnodeweb/node_modules/.bin/eslint'

" let eslint_path = './node_modules/.bin/eslint'
" if filereadable(eslint_path)
"   let g:neomake_javascript_eslint_exe = eslint_path
" endif

" let g:neomake_javascript_eslint_args = ['--no-ignore', '-c', '/Users/jacharles/dev/p2pnodeweb/.eslintes6rc', '-f', 'compact']


" Keep tray closed
let g:neomake_open_list = 0 "2 to open

let g:neomake_warning_sign = {
\ 'text': '!',
\ 'texthl': 'Warning',
\ }

let g:neomake_error_sign = {
\ 'text': '✗',
\ 'texthl': 'Error',
\ }

" Troubleshooting Neomake. Turn these on...
" let g:neomake_verbose=3
" let g:neomake_open_list = 2
" let g:neomake_logfile='/tmp/error.log'


" Prettier - NeoFormat STOPPED USING IT. Using Formatter instead
let g:neoformat_try_formatprg = 1
" DISABLE by commenting these out
   " \ 'exe': '/Users/jacharles/.nvm/versions/node/v8.11.0/bin/prettier',
   " \ 'exe': '/Users/jacharles/.fnm/node-versions/v14.15.3/installation/lib/node_modules/prettier/bin-prettier.js',
 let g:neoformat_javascript_prettier = {
   \ 'exe': 'node ~/.fnm/aliases/default/lib/node_modules/prettier/bin-prettier.js',
   \ }
 let g:neoformat_only_msg_on_error = 1
 let g:neoformat_enabled_javascript= ['prettier']
 let g:prettier#config#single_quote = 'true'
 let g:prettier#config#trailing_comma = 'all'

 " Debugging
let g:neoformat_verbose = 1


"" Syntax Highlighting
" JSX: - Allow JSX syntax highlighting in JS files
let g:jsx_ext_required = 0

"" Git Gutter -> Goto vimrc.after.vim


"" Vim Signify (similar to gitgutter
" https://github.com/mhinz/vim-signify/blob/master/doc/signify.txt
let g:signify_sign_delete_first_line="-"
let g:signify_sign_change="~"
" let g:signify_sign_show_count = 1

"Useful commands
":SignifyDiff!
":SignifyFold! "Fold anything not changed


" Vim signature: Marks in the sidebar
" TODO: Turn off for PS
let g:SignatureForceRemoveGlobal=1"

"" MARKDOWN settings
" Vim Markdown fenced language support. TODO: just make that default?
let g:vim_markdown_fenced_languages = ['javascript=js']

let g:vim_markdown_strikethrough = 1
let g:vim_markdown_new_list_item_indent = 0

" Enable window fading when tmux has other pane focus
let g:vimade={}
let g:vimade.enablefocusfading=0 " disabled for now... we can turn it on again later...

" TMUX Navigation
let g:tmux_navigator_no_mappings = 1
