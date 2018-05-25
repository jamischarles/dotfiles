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

"" Files: Nerdtree
let g:NERDTreeShowHidden=1 	 " Show hidden files by default
let NERDTreeQuitOnOpen=0 " DOESN'T WORK :(

"" Files: FZF
let g:fzf_command_prefix = 'Fzf'


" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
" - window (nvim only)
let g:fzf_layout = { 'down': '~30%' }

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
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1     " use nice arrow symbols etc

" Disable "mixed indent" warnings for airline status bar (false positives)
let g:airline#extensions#whitespace#enabled = 0

"" Linter / Neomake
" FIXME: Turn this back on
" let g:neomake_javascript_enabled_makers = ['eslint']
" If eslint exec exists, use that.
" let eslint_path = '/Users/jacharles/dev/p2pnodeweb/node_modules/.bin/eslint'
let eslint_path = './node_modules/.bin/eslint'
if filereadable(eslint_path)
  let g:neomake_javascript_eslint_exe = eslint_path
endif

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


" Prettier - NeoFormat
let g:neoformat_javascript_prettier = {
  \ 'exe': '/Users/jacharles/.nvm/versions/node/v8.11.0/bin/prettier',
  \ 'stdin': 1,
  \ }
let g:neoformat_only_msg_on_error = 1
let g:neoformat_enabled_javascript= ['prettier']
"


"" Syntax Highlighting
" JSX: - Allow JSX syntax highlighting in JS files
let g:jsx_ext_required = 0

"" Git Gutter -> Goto vimrc.after.vim

" Vim signature: Marks in the sidebar
" TODO: Turn off for PS
let g:SignatureForceRemoveGlobal=1"

" Vim Markdown fenced language support. TODO: just make that default?
let g:vim_markdown_fenced_languages = ['javascript=js']
