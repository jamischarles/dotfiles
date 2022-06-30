-----------------
--Comment management
----------------------
local map = require('utils').mapKey
local feedkeys = require('utils').sendFeedkeys
local use = require('packer').use
use 'numToStr/Comment.nvim'

local cm = require('Comment')

cm.setup()


--map('n', "<leader>/", "gcc") 
--map('n', "<leader>/", "feedkeys('gcc', 'n')") 
-- Comment current line and go to start of next one
map('n', "<leader>/", '<CMD>lua require("Comment.api").call("toggle_current_linewise_op")<CR>g@$j^')
