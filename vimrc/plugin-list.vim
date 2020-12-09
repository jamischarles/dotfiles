
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

"" INSTRUCTIONS
" after changes:
" :so %
" :PlugInstall


" STARTUP
" Plug 'mhinz/vim-startify'                          " Fancy Startup screen
"
Plug 'liuchengxu/vim-which-key'
Plug 'unblevable/quick-scope'

" GIT / DIFFING
Plug 'jamischarles/vim-fugitive'                          " Git commands in Vim. Consider https://github.com/carlhuda/janus/blob/master/janus/vim/tools/janus/after/plugin/fugitive.vim


Plug 'alok/vim-gitignore' " Syntax highlighting for .gitignore (should come from fugitive?)

Plug 'AndrewRadev/linediff.vim'
" Plug 'airblade/vim-gitgutter'                      " Git gutter
Plug 'mhinz/vim-signify' " Another git gutter? Trying it out...
" Plug 'jreybert/vimagit'   " vim magit. Magic git stuff?

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
Plug 'chengzeyi/fzf-preview.vim' " Preview for search etc
" Plug 'kien/ctrlp.vim'                              " Fuzzy file finder
" Plug 'mileszs/ack.vim'                             " Ack in Vim. TODO: Consider trying ag instead of ack in here
" Plug 'rking/ag.vim'                                " Try AG instead of ACK

Plug 'tomtom/tcomment_vim'
" Plugin 'scrooloose/nerdcommenter'                  " Awesome commenting
" Plugin 'tpope/vim-commentary'                      "
" Plugin 'scrooloose/syntastic'                        " Syntax checker
" Turned off unimpaired because of y delay conflict it caused.
Plug 'jamischarles/vim-unimpaired' " Fork to remove y keybinding conflict
" Plug 'tpope/vim-unimpaired'                        " Buffer switching
Plug 'duff/vim-bufonly'                            " Close all buffers but current
" Plugin 'mihaifm/bufstop'                             " MOST Amazing MRU Buffer switcher

" Snippets #############
Plug 'SirVer/ultisnips'                            " Snippet engine
" Plug 'Shougo/deoplete.nvim'
" Plug 'Shougo/neosnippet.vim'
" Plug 'Shougo/neosnippet-snippets'


" CoC for snippets and intellisense and all that
Plug 'neoclide/coc.nvim', {'branch': 'release'}


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

"Elixir
Plug 'elixir-editors/vim-elixir'

" THEMES
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
" Status bar (bottom)
" Themes for statusbar
Plug 'altercation/vim-colors-solarized'            " Color scheme
" Plug 'lifepillar/vim-solarized8'                   " Trying this to avoid the colors changing slightly?!?
" Plug 'frankier/neovim-colors-solarized-truecolor-only' "24 bit version? Needed for hyperterm...
" Plug 'tomasr/molokai'                              " Color scheme based on monokai
Plug 'sickill/vim-monokai'
Plug 'ErichDonGubler/vim-sublime-monokai' "sublime-monokai Q: Can we have monokai with same bg color...
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'patstockwell/vim-monokai-tasty' "colorscheme vim-monokai-tasty
Plug 'haishanh/night-owl.vim' " Sara drasner theme
" Consider monokai with same bg I use in solarized terminal (see that with
" bat)

" # Best light themes
Plug 'morhetz/gruvbox' "8/10 for dark (nice for both) esp high contrast mode. 9/10 for light. TODO: try a bold font
Plug 'rakr/vim-one' " TODO: give light a chance... maybe increase bg contrast 5/10 (nice for light & dark)
" ^ Gruvbox is light theme WINNER
" TODO: Try material light
"https://github.com/kaicataldo/material.vim
"
"
" #Favorite Dark themes
" - Tokyo night (try this one for a while... ) (purple)
"
" - Winter is coming?
"https://marketplace.visualstudio.com/items?itemName=johnpapa.winteriscoming
"(convert to vim using converter thing... 2 options for that)
" How to convert themes:
" 1) https://github.com/jacoborus/estilo
"
"
" - Night owl (purple & blue)
" - Night owl fork https://github.com/cevr/overnight
" - monokai tasty
"   Gruvbox?
" - Sonokai
" - Dracula (purple)
"   - nord (blue)
"
" ## iterm / Terminal themes to try (order of pref)
" - Dracula
" - OneHalf Dark
" - OneHalf Light
" - Night Owl
" https://github.com/sonph/onehalf (GOOD). both light & dark
"
" Terminal coloring info
" https://gist.github.com/XVilka/8346728
"
"
Plug 'https://github.com/zefei/vim-colortuner'
"
"
" # nice dark themes (trying out...) (best to least)
Plug 'ghifarit53/tokyonight-vim' "NICE. try it out more similar to night owl
Plug 'sainnhe/sonokai' "NICE. Maybe change bg color though...?
Plug 'arcticicestudio/nord-vim' "Nice, but needs darker bg
Plug 'kaicataldo/material.vim', { 'branch': 'main' } "so-so
Plug 'sonph/onehalf' " not working?

" set termguicolors
" let g:tokyonight_style = 'night' " available: night, storm (too low contrast for me)
" let g:tokyonight_enable_italic = 0
" colorscheme tokyonight


" TODO: try treesitter for better syntax highlighting...

"
"THEME WINNER
"Light - Gruvbox (give one a chance...)
"Dark ->
"night owl (LEADER try for a while...)
"vim-monookai-tasty (try both)
"Dracula
"monokai
"
"
"TRY:
"https://vimcolorschemes.com/ghifarit53/tokyonight-vim
"https://vimcolorschemes.com/sonph/onehalf
"https://vimcolorschemes.com/sainnhe/sonokai
"https://vimcolorschemes.com/kaicataldo/material.vim
"https://vimcolorschemes.com/arcticicestudio/nord-vim
"
"https://vimcolorschemes.com/ **************** this is great!
"
"FONT WINNER
"Fira Mono Medium (wish we could disable half the ligatures only)... Q: Can I
"fork it and do that?

" temp for now... remove later
" Having a bolder font with more contrast actually makes a huge diff...
" can tell very little difference... but I like hard the best, but let's try
" with one for a while... font choice seems to matter more...
" let g:gruvbox_contrast_dark = "hard"
" let g:gruvbox_contrast_light = "hard"
"
" TODO: blog about this after I make some choices...
" FONTS:
" Fira mono medium is a KEEPER (TODO: try it with all the themes I like...)
"https://github.com/mozilla/Fira (ancestor)
"https://github.com/tonsky/FiraCode (became this...)
"https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraMono/Medium (patched for powerline...)
"(use furamono)
"https://github.com/ryanoasis/nerd-fonts?
"
"

" TODO try out other fonts (based on what these themes recommend...
" Goal is higher contrast and easier on the eyes
" https://github.com/belluzj/fantasque-sans
" https://mozilla.github.io/Fira/
" Try out Dracula (paid)

" Themes to try
" 1) Night-owl - set termguicolors (makes a diff)
" 2) Dracula
" 3) Monokai with custom bg color (that's the part I always dislike)
" 4) Dracula Pro... ?
"
" TODO: maybe set a function to do all the stuff together... sincet that's
" what it'll take anyway...


" set iterm the same color...
" Q: Can I override the bg color?
" https://vi.stackexchange.com/questions/18212/prevent-colorscheme-from-changing-background-color
"highlight Normal ctermbg=NONE guibg=#22222c
"highlight Normal ctermbg=NONE guibg=NONE (matches the terminal BG color...)

" highlight Normal ctermbg=NONE guibg=#191D1D (monokai tasty)


" ## New light themes to try...
" TODO: make functions to switch between these...
" rakr/vim-one (nice for light & dark)
" /morhetz/gruvbox (nice for both) esp high contrast mode
" wimstefan/vim-artesanal/
" https://github.com/tomasr/molokai

" https://www.reddit.com/r/vim/comments/9lnduh/light_highcontrast_colortheme/


Plug 'jooize/vim-colemak'                          " Remap keyboard shortcuts to colemak

" Trying out unite / denite
Plug 'Shougo/denite.nvim'

" CTAGS
" Plug 'ludovicchabant/vim-gutentags'                " Ctag manager (keeps them up to date...)
Plug 'majutsushi/tagbar'                           " Navbar with tags
" Plug 'kristijanhusak/vim-js-file-import', {'do': 'npm install'} " tag-based smart js-imports
Plug 'Galooshi/vim-import-js' " Another js import... (requires  npm install -g import-js)
" Plug 'ternjs/tern_for_vim', { 'do': 'npm install' } " js ctags? Requires npm install after

" SYNTAX
Plug 'pangloss/vim-javascript'                     " JS indentation & syntax sugar
Plug 'groenewege/vim-less'                         " Less language bundle
Plug 'rust-lang/rust.vim'                          " Rust syntax highlighting
Plug 'hashivim/vim-vagrant'                        "Vagrant Syntax
Plug 'rodjek/vim-puppet'                           "Puppet syntax
" Plug 'terryma/vim-multiple-cursors'
" Plugin 'mxw/vim-jsx'                                 " JSX syntax highlighting.
" Plug 'neoclide/vim-jsx-improve'                    " JSX Syntax and indentation

" Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'


" TypeScript
" Plug 'HerringtonDarkholme/yats.vim'
" Plug 'maxmellon/vim-jsx-pretty'


Plug 'aliva/vim-fish'                              "Fish syntax highlighting
Plug 'plasticboy/vim-markdown' " Markdown syntax highlighting
Plug 'jxnblk/vim-mdx-js' "MDX syntax
Plug 'nathanielc/vim-tickscript' "Tickscript for influxdb
Plug 'cespare/vim-toml' "Toml for influxdb
Plug 'dzeban/vim-log-syntax'                       "Log files
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript' "TSX support
Plug 'posva/vim-vue'
Plug 'reasonml-editor/vim-reason-plus' "ReasonML
Plug 'kchmck/vim-coffee-script' "Coffee
Plug 'jparise/vim-graphql'

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

" Fade inactive panes (useful for tmux)
Plug 'TaDaa/vimade'
Plug 'tmux-plugins/vim-tmux-focus-events'

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
