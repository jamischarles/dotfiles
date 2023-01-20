-- Key mappings baseline...
-- For generic things. Mappings for plugins will be located with plugin code...
--
-- TODO: Remove vim-colemak and make my own colmak settings here
-- READING https://blog.devgenius.io/create-custom-keymaps-in-neovim-with-lua-d1167de0f2c2
--
--
local map = require("utils").mapKey


-- plugins needed for this file (maybe later move this out?)
--use 'JoosepAlviste/nvim-ts-context-commentstring'

-----------------------------
-- LEADER KEYS
-- --------------------------
map('n', "<leader>w", ":write<CR>") -- save
map('n', "<leader>o", ":only<CR>") -- close other windows

-- see command-navigation for all the fzf leader keys

-- FZF stuff


-- xmap <leader>d <Plug>(textmanip-duplicate-down)
-- nmap <leader>d <Plug>(textmanip-duplicate-down)


-- Fix (and hopefully, soon, replace colemak plugin mappings)
-- map('n', "N", "K") -- search result reverse
