-----------------
--Comment management
----------------------
local map = require('utils').mapKey
local feedkeys = require('utils').sendFeedkeys

-- local cm = require('Comment')
--
-- cm.setup()


--map('n', "<leader>/", "gcc") -- This odesn't work. WHYYYYYYYYYYYYYYYYYYYYYYYYYY
vim.api.nvim_set_keymap("n", "<leader>/", "gccn^", {}) -- comment and move to next line
vim.api.nvim_set_keymap("x", "<leader>/", "gc", {})

return {
	name = "comments",
	dependencies = {
		'numToStr/Comment.nvim'
	}, -- automagically runs --setup()?  NO
	config=function()
		require('Comment').setup()
	end

}


-- map('n', "<leader>/", feedkeys('gcc', 'n'))
-- Comment current line and go to start of next one
-- Buggy? Why doesn't this work anymore? operatorfunc? How did I break that? 
-- map('n', "<leader>/", '<CMD>lua require("Comment.api").call("toggle_current_linewise_op")<CR>g@$j^')

-- once gcc runs once this works... WHY!?!? Does it not know  yet what to run?
