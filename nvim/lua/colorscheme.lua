---------------------
-- Colorscheme
---------------------
local use = require('packer').use
    -- LIGHT themes I like
	--
    use 'cocopon/iceberg.vim' -- "++ (Blue + purple)
    use 'EdenEast/nightfox.nvim' -- ++ Dark during the day. Has 10 themes inside. Very configurable.
-- "DuskFox is like tokyonight Duskfox, Dawnfox++, Nightfox++, Nordfox, Dayfox++ (nightshift)
    use 'stillwwater/vim-nebula' -- ++ NICE in light AND Dark (nightshift decent)

    -- DARK themes I like (fox ones)
    use 'ghifarit53/tokyonight-vim' --NICE. try it out more similar to night owl
    -- use 'haishanh/night-owl.vim' -- ++ Dark during day. Sara drasner theme



vim.opt.background = "light"
vim.api.nvim_create_user_command('Light', ':lua vim.opt.background="light"', {nargs=0})
vim.api.nvim_create_user_command('Dark', ':lua vim.opt.background="dark"', {nargs=0})




-- vim.cmd('colorscheme iceberg') -- no lua equivalent of this :colorscheme command
-- vim.cmd('colorscheme dayfox') -- no lua equivalent of this :colorscheme command
-- vim.cmd('colorscheme duskfox') -- no lua equivalent of this :colorscheme command
vim.cmd('colorscheme dawnfox') -- no lua equivalent of this :colorscheme command

-- LIKE
-- dawnfox
-- nordfox

-- return M
