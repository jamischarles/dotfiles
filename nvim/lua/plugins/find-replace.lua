-- Utils and plugins around finding / replacing. Maybe all the rg stuff should go in here?
-- Some of the finding stuff is in command-navigation.lua
--

local map = require("utils").mapKey


-- map("n", "<leader>fr", ":lua require('spectre').open()<CR>") -- ctrl+space YES
-- map("n", "<leader>fr", ":lua require('spectre').open_visual()<CR>") -- selection

-- map("n", "<leader>fr", ":lua require('spectre').open_file_search()<CR>") -- current file
-- map("n", "<leader>fr", ":lua require('grug-far').open_file_search()<CR>") -- current file

map("n", "<leader>fr", ":lua require('grug-far').open({transient=true, prefills = { paths = vim.fn.expand('%') } })<CR>") -- current file
--
return {
  -- {
  --   "windwp/nvim-spectre", -- requires brew install gnu-sed
  --   lazy = true,           -- try verylazy?
  --   config = function()
  --     require("spectre").setup()
  --   end,
  -- }
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      require('grug-far').setup({
        -- options, see Configuration section below
        -- there are no required options atm
        -- engine = 'ripgrep' is default, but 'astgrep' can be specified
      });
    end
  },

}
