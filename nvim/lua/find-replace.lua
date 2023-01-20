-- Utils and plugins around finding / replacing. Maybe all the rg stuff should go in here?
-- Some of the finding stuff is in command-navigation.lua
--

local map = require("utils").mapKey


-- map("n", "<leader>fr", ":lua require('spectre').open()<CR>") -- ctrl+space YES
-- map("n", "<leader>fr", ":lua require('spectre').open_visual()<CR>") -- selection
map("n", "<leader>fr", ":lua require('spectre').open_file_search()<CR>") -- current file
--
return {
	name = "find-replace",
	dependencies = {
		"windwp/nvim-spectre", -- requires brew install gnu-sed
	},
	config = function()
		require("spectre").setup()
	end,
}
