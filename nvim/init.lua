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
vim.g.mapleader =
" "                                                                    -- "Remap leader to <space>.  make cursor speed REALLY fast http://stackoverflow.com/questions/23078078/speed-up-vim-cursor-moving-through-j      -k
vim.opt.clipboard =
"unnamed"                                                              -- yank will go to the system clipboard. Allows copy/paste from/to other apps
-- https://advancedweb.hu/working-with-the-system-clipboard-in-vim/#:~:text=Set%20the%20%2B%20register%20as%20the,from%20it%20with%20%22%2Bp%20.
vim.cmd("set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab") -- http://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces

-- UNDO - Save beyond closing Persistent undo - http://stackoverflow.com/questions/2732267/vim-loses-undo-history-when-changing-buffers
vim.cmd("set hidden")              -- persist beyond buffer switching
vim.cmd("set undofile")            -- Allow persistent undo
vim.cmd("set undodir=~/.vim/undo") -- Store undo files here. You have to make the folder if it doesn't exist
vim.cmd("set undoreload=10000")    -- Not sure what this does?
--" set undolevels=1000
vim.cmd("set undolevels=100")      -- This controls how far back you can undo"

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
-- OLD LAZY install
--local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
--if not vim.loop.fs_stat(lazypath) then
--  vim.fn.system({
--    "git",
--    "clone",
--    "--filter=blob:none",
--    "https://github.com/folke/lazy.nvim.git",
--    "--branch=stable", -- latest stable release
--    lazypath,
--  })
--end
--vim.opt.rtp:prepend(lazypath)


-- NEW lazy install


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)




-- No plugins in these
require("keymap-reset-colemak")
require("keys")


-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"





-- table
local pluginTree = {}


-- ______________ ALMOOOST WORKS. going to use plugin.lua for now instead... -----

-- build a table of plugin specs that are returned from the local plugin files
-- Makes it easy to load local plugins using an array
-- is this slower than the other way? Can we speed this up?
-- LATER: optimize for startup speed...
function buildPluginList(list)
  for _, localPlugin in ipairs(list) do
    -- similar to require.cache in node??
    -- https://www.gammon.com.au/scripts/doc.php?lua=package.preload

    local pluginSpec = {
      -- dir = "~/.dotfiles/nvim/lua/plugins/",
      -- apparently in lua, instead of require('[folder]/[file]') you use a `.` delimeter
      -- so we do require('plugins.colorscheme')
      -- aaaand, this works amazingly with lazy!!!!
      import = "plugins." .. localPlugin
    }

    -- print("localspec", vim.inspect(pluginSpec))
    -- essentially merge the specs together
    table.insert(pluginTree, pluginSpec)
  end
end

-- IF THIS DOESN"T WORK, go back to manual equivalen in plugins.lua...
-- If this manual setup becomes too painful, try one of the distros... like https://www.lazyvim.org/ or lunar-nvim
-- then put a THIN layer of my own keybindings on top of it...
--
--
-- plugins to try:
--
-- blink + snacks + fzf-lua (would be nice to replace a bunch of the the smaller plugins I've been trying to use together...
--
-- https://www.lazyvim.org/news
--vtsls instead of tsserver
-- blink.cmp (completion), snacks (QoL), grug-far, biome instead of lint/prettier...
-- lsp stuff from there ^?
-- mini.diff??? (from mini.nvim)?

buildPluginList({
  -- WHY DOES ORDER MATTER SO MUCH? Probably because of how I config things in the files outside of init...
  'cursorline', -- highlight current line after a jump
  -- set highlight current line number only. PERFECT -- TODO: consider moving this to sign column bg instead...
  -- vim.cmd('set number') -- line numbers
  -- vim.cmd('set cursorline') -- FIXME: find more lua way to do this? Maybe with the vim global options part?
  -- vim.cmd('set cursorlineopt=number ') -- FIXME: find more lua way to do this? Maybe with the vim global options part?

  -- hi CursorLineNr guifg=#af00af guibg=color -- CursorLineNr   xxx cterm=bold gui=bold guifg=#ba793e
  --
  --
  'git',
  -- modules by feature / UI functionality
  -- 'statusline',
  -- --
  -- --
  -- -- command-nav (fzf quick commands etc)
  'command-navigation', -- depends in telescope ctr-t <-
  'telescope-ctrl-t',
  'find-replace',
  --
  --
  -- -- bufferline features
  'buffers',
  'windows', -- window management
  --
  'comments',
  --
  -- -- Autocompletion sources & Snippets
  -- Provided by lsp now??
  -- 'snippets',
  -- 'autocompletion',
  --
  'sessions', -- session managements
  --


  --
  -- -- Text manipulation & text objects
  'text-object-manipulation',


  -- -- LSP/codehinting/linting
  'lsp-codehinting',
  'colorscheme',
  'statusline',
})

-- print(vim.inspect(pluginTree))




-- print("pluginTree2", vim.inspect(pluginTree2))
-- print("pluginTree", vim.inspect(pluginTree))

--print("required plugin tree!!!", vim.inspect(require("plugins")))
--print("required plugin tree!!!", vim.inspect(require("plugins")[1].config))

-- plugin tree
-- require("lazy").setup(pluginTree)
--require("lazy").setup("~/.dotfiles/nvim/plugins/colorscheme.lua", {

require("lazy").setup(pluginTree, {
  -- require("lazy").setup("plugins", {

  profiling = {
    -- Enables extra stats on the debug tab related to the loader cache.
    -- Additionally gathers stats about all package.loaders
    -- loader = true,
    -- Track each new require in the Lazy profiling tab
    -- require = true,
  },
}
)


-- reset keymappings. At END? Is this the best place? (does position actually matter?)

-- CORRECTIVE MAPPINGS
-- These are mapping that aren't being applied properly in other files (for whatever reasons...)
-- map('n', "<C-t>", ":Trouble<CR>")
-- map('n', "<C-t>", ":Trouble diagnostics toggle focus=false filter.buf=0<CR>")
map('n', "<C-t>", ":Trouble diagnostics_buffer<CR>")


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
