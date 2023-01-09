-- Key mappings baseline...
-- For generic things. Mappings for plugins will be located with plugin code...
--
-- TODO: Remove vim-colemak and make my own colmak settings here
--
--
local map = require("utils").map

-- normal navigation
map('n', "N", "22j") -- search result reverse
-- Fix (and hopefully, soon, replace colemak plugin mappings)
-- map('n', "N", "K") -- search result reverse
