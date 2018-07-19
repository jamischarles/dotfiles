
" PLUGINS START *********** https://github.com/junegunn/vim-plug
"
" set the runtime path to include Vundle and initialize
" vim-snipmate looks in runtimepath for a folder named 'snippets' for code
" snippets
" set rtp+=~/.vim/bundle/Vundle.vim,~/.dotfiles/_codesnippets
set rtp+=~/.dotfiles/_codesnippets
" set rtp+=~/.fzf " Is this the old version? "
" set rtp+=~/.dotfiles/_codesnippets,/usr/local/Cellar/fzf/HEAD
" set rtp+=~/.
"
"https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

"" Plugins
" TODO:
" - group these into sensible groupings

" STARTUP
Plug 'mhinz/vim-startify'                          " Fancy Startup screen

" GIT / DIFFING
Plug 'tpope/vim-fugitive'                          " Git commands in Vim. Consider https://github.com/carlhuda/janus/blob/master/janus/vim/tools/janus/after/plugin/fugitive.vim
Plug 'AndrewRadev/linediff.vim'
Plug 'airblade/vim-gitgutter'                      " Git gutter
Plug 'jreybert/vimagit'   " vim magit. Magic git stuff?

" Undo / History / Swap
Plug 'jamischarles/vim-mundo' " Fork of Gundo
Plug 'CharlesPatterson/vim-autoswap' "NO WORKY :{ Switch to open window insetad of opening another one

" Navigation
Plug 'takac/vim-hardtime'                          " Disable lazy nav (like the other one)
Plug 'easymotion/vim-easymotion' "Jump easily to spots on screen
" Plug 'bkad/CamelCaseMotion'                        " Next word considers camelcase as part of it :). LOVE IT!!! SO AMAZING
" Plug 'yuttie/comfortable-motion.vim'               " Smooth scrolling

" Plug 'scrooloose/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
" Lazy loading doesn't seem to work properly...
" Plug 'Xuyuanp/nerdtree-git-plugin', { 'on':  'NERDTreeToggle' }  " Load lazily, since first load is really slow with this on
" File tree  Consider https://github.com/carlhuda/janus/blob/master/janus/vim/tools/janus/after/plugin/nerdtree.vim
" Git status in Nerdtree

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Have it
Plug 'junegunn/fzf.vim'
" Plug 'kien/ctrlp.vim'                              " Fuzzy file finder
" Plug 'mileszs/ack.vim'                             " Ack in Vim. TODO: Consider trying ag instead of ack in here
" Plug 'rking/ag.vim'                                " Try AG instead of ACK

Plug 'tomtom/tcomment_vim'
" Plugin 'scrooloose/nerdcommenter'                  " Awesome commenting
" Plugin 'tpope/vim-commentary'                      "
" Plugin 'scrooloose/syntastic'                        " Syntax checker
Plug 'tpope/vim-unimpaired'                        " Buffer switching
Plug 'duff/vim-bufonly'                            " Close all buffers but current
" Plugin 'mihaifm/bufstop'                             " MOST Amazing MRU Buffer switcher
Plug 'SirVer/ultisnips'                            " Snippet engine
" Vim Snippets (local)
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'

Plug 'ervandew/supertab'                           " Sweet tab completion
Plug 'zerowidth/vim-copy-as-rtf'                   " Copy to rtf (and paste code to Keynote)
Plug 'bronson/vim-trailing-whitespace'             " Trail whitespace finder
Plug 'godlygeek/tabular'                           " easy aligning. :Tab /                                                                       = http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
Plug 'tpope/vim-sleuth'                            " Better indentation. Give it a try... Sigh.
Plug 'tpope/vim-surround'                          " easy surround with quote etc
" Plugin 'jwhitley/vim-matchit'                      " better % matching. Does this even do anything? Not sure it's worth having around. REMOVE?
" Plugin 'terryma/vim-expand-region'
" Plugin 'jeetsukumaran/vim-markology'               " Mark visualizations

" Plug 'janko-m/vim-test'                            " Running tests from vim
Plug 'tyru/open-browser.vim'                       " Open in test

Plug 'Raimondi/delimitMate'                        " quote, bracket, etc autocompletion

"Plug 'rizzatti/dash.vim'
Plug 't9md/vim-textmanip'                          " Move selected text around easily
Plug 'ntpeters/vim-better-whitespace'              " Strip whitespace on save
Plug 'elzr/vim-json'                               " Hide quotes, json highlighting
" Plug 'jimmyhchan/dustjs.vim'
Plug 'moll/vim-node'                               " node sugar like gf, gd?
" Plug 'lambdatoast/elm.vim'                         " Elm syntax
" Plug 'ElmCast/elm-vim'                             " Elm error sugar etc
" Plug 'nikvdp/ejs-syntax'                           " EJS Highlighting
Plug 'briancollins/vim-jst'
Plug 'motus/pig.vim'                               "Pig script highlighting

" Plug 'Quramy/vim-js-pretty-template'    "html in es6 template strings
Plug 'jonsmithers/experimental-lit-html-vim' "html in es6 template strings

" Find / Search                                    "Incremental search numbers
Plug 'osyo-manga/vim-anzu' "Does incsearch handle this?
Plug 'haya14busa/incsearch.vim'                    " Show all results as you're typing
Plug 'haya14busa/incsearch-index.vim' 			   " Shows the current search count? Q: Integrate this with the other one?
Plug 'numkil/ag.nvim'                              "Ag search
" Plug 'dyng/ctrlsf.vim' " Seperate window for project-wide search. WHY WON'T YOU WORK?
Plug 'eugen0329/vim-esearch'

"Golang
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'jodosha/vim-godebug' " Debugger for go

" THEMES
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
" Status bar (bottom)
" Themes for statusbar
Plug 'altercation/vim-colors-solarized'            " Color scheme
" Plug 'lifepillar/vim-solarized8'                   " Trying this to avoid the colors changing slightly?!?
" Plug 'frankier/neovim-colors-solarized-truecolor-only' "24 bit version? Needed for hyperterm...
Plug 'tomasr/molokai'                              " Color scheme based on monokai
Plug 'sickill/vim-monokai'

Plug 'jooize/vim-colemak'                          " Remap keyboard shortcuts to colemak

" Trying out unite / denite
Plug 'Shougo/denite.nvim'

" CTAGS
" Plug 'ludovicchabant/vim-gutentags'                " Ctag manager
Plug 'majutsushi/tagbar'                           " Navbar with tags
" Plug 'ternjs/tern_for_vim', { 'do': 'npm install' } " js ctags? Requires npm install after

" SYNTAX
Plug 'pangloss/vim-javascript'                     " JS indentation & syntax sugar
Plug 'groenewege/vim-less'                         " Less language bundle
Plug 'rust-lang/rust.vim'                          " Rust syntax highlighting
Plug 'hashivim/vim-vagrant'                        "Vagrant Syntax
Plug 'rodjek/vim-puppet'                           "Puppet syntax
" Plug 'terryma/vim-multiple-cursors'
" Plugin 'mxw/vim-jsx'                                 " JSX syntax highlighting.
Plug 'neoclide/vim-jsx-improve'                    " JSX Syntax and indentation
Plug 'aliva/vim-fish'                              "Fish syntax highlighting
Plug 'plasticboy/vim-markdown' " Markdown syntax highlighting
Plug 'nathanielc/vim-tickscript' "Tickscript for influxdb
Plug 'cespare/vim-toml' "Toml for influxdb
Plug 'dzeban/vim-log-syntax'                       "Log files
Plug 'leafgarland/typescript-vim'
Plug 'posva/vim-vue'
Plug 'reasonml-editor/vim-reason-plus' "ReasonML
Plug 'kchmck/vim-coffee-script' "Coffee

"Eslint. FIXME: do we need both?
Plug 'benekastah/neomake'                          " Async make (for syntax checking etc)

"Prettier
Plug 'sbdchd/neoformat'
Plug 'prettier/vim-prettier' " trying this again :|. Last time was SOO slow

" Plug 'farmergreg/vim-lastplace' " TOO Slow? try to steal the good stuff?                   Open file at the last place you edited.

" MARKS
" Plug 'MattesGroeger/vim-bookmarks'  "mm|mx to mark. mn to jump
" Plug 'kshenoy/vim-signature' " Show marks in the sidebar
" FOLDING
" Plug 'kshenoy/vim-origami' " Right aligns fold markers. FIXME: Mappings
" don't work

Plug 'tpope/vim-obsession'                          " Resurrect vim. Obsession.

Plug 'christoomey/vim-tmux-navigator'              " Tmux / Vim window integration
Plug 'tmux-plugins/vim-tmux'                       " Tmux conf syntax highlighting

Plug 'chrisbra/NrrwRgn' " Open code in new window

" Q: This still needed?
Plug 'sjl/vitality.vim/'                           "Fix cursor issues in tmux
Plug 'jszakmeister/vim-togglecursor'
" https://github.com/jszakmeister/vim-togglecursor/blob/master/doc/togglecursor.txt


" Plugin 'junegunn/limelight.vim' "Focus mode

" Add plugins to &runtimepath
call plug#end()

"" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" VUNDLE END --
"
