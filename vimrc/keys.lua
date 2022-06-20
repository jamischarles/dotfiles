-- Key mappings baseline...
-- For generic things. Mappings for plugins will be located with plugin code...
--
-- TODO: Remove vim-colemak and make my own colmak settings here
--
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


-- normal navigation
map('n', "N", "22j") -- search result reverse
-- Fix (and hopefully, soon, replace colemak plugin mappings)
-- map('n', "N", "K") -- search result reverse
