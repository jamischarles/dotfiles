"" TODO Section
" - Align comments
"
"" BASE SETTINGS
let mapleader = "\<Space>" "Remap leader to <space>.  make cursor speed REALLY fast http://stackoverflow.com/questions/23078078/speed-up-vim-cursor-moving-through-j-k
set shortmess+=AT 		" Ignore 'swapfile exists' warnings. Avoid "press enter" on too long messages
set vb                   " enable visual bell (disable audio bell)
set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4 " http://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces
set autoindent                  " Automatic indention
" set nowrap                        " don't wrap lines
set wrap                        " wrap lines
set backspace=indent,eol,start    " backspace through everything in insert mode FIXME: Still needed?
set listchars=tab:\|\ ,eol:¬,trail:· " HIDDEN CHARS

"" Basic Setup from Janus https://github.com/carlhuda/janus/blob/master/janus/vim/core/before/plugin/settings.vim
set nocompatible      " Use vim, no vi defaults
set nospell           " No spell check
set number            " Show line numbers
set ruler             " Show line and column number
set equalalways       " Splits are always sized equally
syntax enable         " Turn on syntax highlighting allowing local overrides
if !has('nvim')
    set encoding=utf-8    " Set default encoding to UTF-8. Nvim defaults this. Only do this in non-nvim.
endif

set clipboard=unnamed    " yank will go to the system clipboard. Allows copy paste to outside
" https://advancedweb.hu/working-with-the-system-clipboard-in-vim/#:~:text=Set%20the%20%2B%20register%20as%20the,from%20it%20with%20%22%2Bp%20.

filetype on                  " required for Vundle. FIXME: Still needed?
set foldtext=CustomFoldText() " Nicer foldtext

"" SEARCHING (from JANUS)
set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter

"" Backup and swap files (titlestring needed for auto-swap plugin).
" Titlestring sets iterm tabtitle for name of file. AMAZING***
set backupdir=~/.vim/backup " where to put backup files.
set directory=~/.vim/backup " where to put swap files.
set title titlestring=

"" UNDO - Save beyond closing Persistent undo - http://stackoverflow.com/questions/2732267/vim-loses-undo-history-when-changing-buffers
set hidden " persist beyond buffer switching
set undofile                    " Allow persistent undo
set undodir=~/.vim/undo         " Store undo files here. You have to make the folder if it doesn't exist
set undoreload=10000            " Not sure what this does?
" set undolevels=1000
set undolevels=100 " This controls how far back you can undo"


"" STATUSLINE (from Janus)  https://github.com/carlhuda/janus/blob/master/janus/vim/core/before/plugin/statusline.vim. FIXME: add to plugin file?
if has("statusline") && !&cp
  set laststatus=2  " always show the status bar
  " Start the status line
  set statusline+=%{ObsessionStatus()}
  set statusline=%f\ %m\ %r
  set statusline+=Line:%l/%L[%p%%]
  set statusline+=Col:%v
  set statusline+=Buf:#%n
  set statusline+=[%b][0x%B]
endif




"" COLOR THEME & FONTS ************************
" http://alvinalexander.com/linux/vi-vim-editor-color-scheme-syntax
" http://stackoverflow.com/questions/7278267/incorrect-colors-with-vim-in-iterm2-using-solarized
" Iterm must be set to xterm-256 (see above)
let g:solarized_contrast = "high"
let g:solarized_visibility = "low"

let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors
" let g:solarized_termcolors = 16
" colorscheme solarized
" set background=light"
" set background=dark"


" does termguicolors cause the refresh issue?... One person suggests it's
" utf-8 that causes it...?
" How about tmux vs non-tmux?
" set termguicolors
"
"
"MUST set this BEFORE you set the colorscheme
" if exists('+termguicolors')
"   " Q: What does this DO?!??!
"   let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
"   let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
"   set termguicolors
" endif

" Force truecolor
" Do we care about truecolor?
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

set termguicolors
"
let g:tokyonight_style = 'night' " available: night, storm (too low contrast for me)
let g:tokyonight_enable_italic = 0
colorscheme tokyonight


if $TERM == "alacritty"
  hi Comment cterm=italic ctermfg=14 gui=italic guifg=#444B6A
  " hi Comment cterm=italic ctermfg=14 gui=italic guifg=#444B6A
  " iterm
  " #484D63
  "
  " Alacritty
  " #434B6D
endif

" Q: Can I override the bg color?
" https://vi.stackexchange.com/questions/18212/prevent-colorscheme-from-changing-background-color
"highlight Normal ctermbg=NONE guibg=#22222c
"highlight Normal ctermbg=NONE guibg=NONE (matches the terminal BG color...)

" highlight Normal ctermbg=NONE guibg=#191D1D (monokai tasty)


" highlight jsObject keys as 'Label' https://github.com/pangloss/vim-javascript/issues/138
" hi def link jsObjectKey Label " Type is nice. Use :hi to see all the
" Type is nice. Use :hi to see all the colors...

" trigger by starting nvim via '$ nvim --cmd "let is_ps=1"
if exists("is_ps")
  " Pluralsight settings:
  set background=light"
  let g:vim_json_syntax_conceal = 0
  let g:conceallevel = 0
  call gitgutter#disable()
else "Highlight object keys
  hi def link jsObjectKey Type
endif

command! Light set background=light"
command! Dark set background=dark"

" For presentations
" colorscheme monokai
" let g:html_font = 'Menlo'



"" Languages and binary support (needed so alacritty can find python)
" let g:python3_host_prog = '/usr/local/bin/python3'
" let g:loaded_python3_provider = 1
