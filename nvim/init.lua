
-- READING:
-- Lua manual https://www.lua.org/manual/5.4/
-- Do we even need anything here?
--https://www.notonlycode.org/neovim-lua-config/

local map = require('utils').mapKey

--------------------------------------------
-- FRESH INSTALL INSTRUCTIONS --------------
-- 1. Go to packer github repo and install it the way they suggest via gitclone
-- 2. run :packerSync
----------------------------

------------------------
-- BASE SETTINGS (FIXME: Move out?) (MUST BE FIRST)
vim.g.mapleader = " " -- "Remap leader to <space>.  make cursor speed REALLY fast http://stackoverflow.com/questions/23078078/speed-up-vim-cursor-moving-through-j      -k
vim.opt.clipboard="unnamed"    -- yank will go to the system clipboard. Allows copy/paste from/to other apps
-- https://advancedweb.hu/working-with-the-system-clipboard-in-vim/#:~:text=Set%20the%20%2B%20register%20as%20the,from%20it%20with%20%22%2Bp%20.
vim.cmd('set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4') -- http://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces

-- UNDO - Save beyond closing Persistent undo - http://stackoverflow.com/questions/2732267/vim-loses-undo-history-when-changing-buffers
vim.cmd('set hidden') -- persist beyond buffer switching
vim.cmd('set undofile')                    -- Allow persistent undo
vim.cmd('set undodir=~/.vim/undo')         -- Store undo files here. You have to make the folder if it doesn't exist
vim.cmd('set undoreload=10000')            -- Not sure what this does?
--" set undolevels=1000
vim.cmd('set undolevels=100') -- This controls how far back you can undo"

vim.cmd([[
set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter
]])
vim.cmd([[
set shortmess+=AT 		" Ignore 'swapfile exists' warnings. Avoid "press enter" on too long messages
"" Backup and swap files (titlestring needed for auto-swap plugin).
" Titlestring sets iterm tabtitle for name of file. AMAZING***
set backupdir=~/.vim/backup " where to put backup files.
set directory=~/.vim/backup " where to put swap files.
set title titlestring=
]])


-- reset keymappings. At END? Is this the best place? (does position actually matter?)
require('keymap-reset-colemak')
require('keys')



-- TODO: co-locate the plugins with the functionality areas... YAS
require('plugins')

-- Colorscheme
require('colorscheme')


-- Start requiring stuff in

-- require('plugins') -- run packerSync from fresh to ensure it's installed



-- modules by feature / UI functionality
require('statusline')
require('git')

-- command-nav (fzf quick commands etc)
require('command-navigation')	


-- bufferline features
require('buffers')	
require('windows') -- window management

-- comments
require('comments')

-- Autocompletion sources & Snippets
require('snippets')
require('autocompletion')

require('sessions') -- session managements

-- LSP/codehinting/linting
require('lsp-codehinting')

-- Text manipulation & text objects
require('text-object-manipulation')



-- CORRECTIVE MAPPINGS
-- These are mapping that aren't being applied properly in other files (for whatever reasons...)
map('n', "<C-t>", ":Trouble<CR>")


--
-- vim.opt.encoding="utf-8" is equivalent of set encoding=utf-8;
-- vim.opt.compatible = true --nvim is always nocompatible
--vim.opt.backspace="indent,eol,start"    -- backspace through everything in insert mode FIXME: Still needed?

-- set nocompatible      " Use vim, no vi defaults

-- source $HOME/.vim/vimrc/plugin-list.lua " Using Packer (Lua) for my plugins now... TODO: start migrating over to this
-- source $HOME/.vim/vimrc/keys.lua " New start for keys
-- " THEN, create a new plugin-settings based on functionality... (when it gets
-- " big enough to warrant a split)
--
-- " Plugin config split by area / UI feature
-- source $HOME/.vim/vimrc/autocomplete.lua " Autocomplete
-- source $HOME/.vim/vimrc/statusline.lua " Autocomplete
-- source $HOME/.vim/vimrc/buffers.lua " Autocomplete
--
--
--
-- source $HOME/.vim/vimrc/init.lua " (Auto-)Commands, Custom functions
