-- READING:
-- Lua manual https://www.lua.org/manual/5.4/
-- Do we even need anything here?
--https://www.notonlycode.org/neovim-lua-config/

local map = require('utils').mapKey

--------------------------------------------
-- FRESH INSTALL INSTRUCTIONS --------------
----------------------------

------------------------
-- BASE SETTINGS (FIXME: Move out?) (MUST BE FIRST)
vim.g.mapleader = " " -- "Remap leader to <space>.  make cursor speed REALLY fast http://stackoverflow.com/questions/23078078/speed-up-vim-cursor-moving-through-j      -k
vim.opt.clipboard = "unnamed" -- yank will go to the system clipboard. Allows copy/paste from/to other apps
-- https://advancedweb.hu/working-with-the-system-clipboard-in-vim/#:~:text=Set%20the%20%2B%20register%20as%20the,from%20it%20with%20%22%2Bp%20.
vim.cmd("set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4") -- http://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces

-- UNDO - Save beyond closing Persistent undo - http://stackoverflow.com/questions/2732267/vim-loses-undo-history-when-changing-buffers
vim.cmd("set hidden") -- persist beyond buffer switching
vim.cmd("set undofile") -- Allow persistent undo
vim.cmd("set undodir=~/.vim/undo") -- Store undo files here. You have to make the folder if it doesn't exist
vim.cmd("set undoreload=10000") -- Not sure what this does?
--" set undolevels=1000
vim.cmd("set undolevels=100") -- This controls how far back you can undo"

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

-- PLUGINS
--
------------------
-- Set up lazy lua package manager). Doing it this way ensures it'll be
---------------------
local fn = vim.fn
-- Fresh install ensures it's there
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- No plugins in these
require("keymap-reset-colemak")
require("keys")



-- table
local pluginTree = {}

-- build a table of plugin specs that are returned from the local plugin files
-- Makes it easy to load local plugins using an array
function buildPluginList(list)
for  _, localPlugin in ipairs(list) do
	local pluginSpec = require(localPlugin)
	pluginSpec.dir =  "~/.dotfiles/nvim/lua"
	pluginSpec.name = "./" .. localPlugin .. ".lua"

	table.insert(pluginTree, pluginSpec)
end
end

buildPluginList({
	'colorscheme',
'cursorline', -- highlight current line after a jump
-- set highlight current line number only. PERFECT -- TODO: consider moving this to sign column bg instead...
-- vim.cmd('set number') -- line numbers
-- vim.cmd('set cursorline') -- FIXME: find more lua way to do this? Maybe with the vim global options part?
-- vim.cmd('set cursorlineopt=number ') -- FIXME: find more lua way to do this? Maybe with the vim global options part?

-- hi CursorLineNr guifg=#af00af guibg=color -- CursorLineNr   xxx cterm=bold gui=bold guifg=#ba793e
--
--
-- modules by feature / UI functionality
'statusline',
'git',
--
--
-- command-nav (fzf quick commands etc)
'command-navigation',
'find-replace', 


-- bufferline features
'buffers',
'windows', -- window management

'comments',

-- Autocompletion sources & Snippets
'snippets',
'autocompletion',

'sessions', -- session managements

-- LSP/codehinting/linting
'lsp-codehinting',

-- Text manipulation & text objects
'text-object-manipulation',

})

-- print(vim.inspect(pluginTree))

-- plugin tree
require("lazy").setup(pluginTree , {
	-- dev = {
	-- doesn't seem to work
	-- 	-- directory where you store your local plugin projects
	-- 	path = "~/.dotfiles/nvim/lua",
	-- 	---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
	-- 	patterns = {"*.lua"}, -- For example {"folke"}
	-- },
})

-- return

-- reset keymappings. At END? Is this the best place? (does position actually matter?)



-- TODO: co-locate the plugins with the functionality areas... YAS
-- require('plugins')

-- Colorscheme
-- require('colorscheme')


-- Start requiring stuff in

-- require('plugins') -- run packerSync from fresh to ensure it's installed


-- syntax sugar





-- comments


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
