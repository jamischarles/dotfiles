----------------
-- Git Features
----------------
local map = require('utils').mapKey


--- FIXME: where should keymaps go?
  map('n', '<leader>h', ':Gitsigns setqflist<CR>')
  map('n', '<leader>p', ':Gitsigns preview_hunk<CR>')
  map('n', "<leader>s", ":Gitsigns stage_hunk<CR>")
  map('n', '<leader>r', ':Gitsigns reset_hunk<CR>')
  map('n', '[h', ':Gitsigns next_hunk<CR>')
  map('n', ']h', ':Gitsigns prev_hunk<CR>')




  function ReplaceBufferWithGitHeadContentForFile()
	  local curBufferPath = vim.api.nvim_buf_get_name(0)
	  local bufferContentAtHead = vim.fn.system("git show HEAD:" .. curBufferPath) -- w/o changes

	  -- this causes issues...
	  -- only draws first line. then messes up statusline and bufferline
	   vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(bufferContentAtHead, '\n'))
  end



  -- diff and have current changes on the left and base on the right
  vim.api.nvim_create_user_command('Diff', ":Gitsigns diffthis ~ split=botright",  { nargs = 0 })
  vim.api.nvim_create_user_command('Blame', ":Gitsigns blame_line",  { nargs = 0 })
  
  -- convenience commands
  vim.api.nvim_create_user_command('StageHunk', ":Gitsigns stage_hunk",  { nargs = 0 })
  vim.api.nvim_create_user_command('StageHunkUndo', ":Gitsigns undo_stage_hunk",  { nargs = 0 })
  vim.api.nvim_create_user_command('GitBufferCommits', ":FzfLua git_bcommits",  { nargs = 0 })
  vim.api.nvim_create_user_command('GitBranches', ":FzfLua git_branches",  { nargs = 0 })

  -- vim.api.nvim_create_user_command('GRead', vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.split(vim.cmd('!git show HEAD:%'), '\n')), {nargs = 0})
  vim.api.nvim_create_user_command('GRead', ':%!git show HEAD:%', {nargs = 0}) -- magic. Replace buffer with output from the command
  vim.api.nvim_create_user_command('GWrite', ":Gitsigns stage_buffer",  { nargs = 0 })


-- find conflict markers -- from Janus
-- nmap <silent> <leader>fc <ESC>/\v^[<=>]{7}( .*\|$)<CR>| " find merge conflict markers - from janus
-- nmap <silent> <leader>fc <ESC>/\v^[<=>]{7}( .*\|$)<CR>| " find merge conflict markers - from janus
map('n', '<leader>fc', [[<ESC>/\v^[<=>]{7}( .*|$)<CR>]])

-- :h matchit
-- Configures % to work with git conflict markers. DOESN"T WORK
--
vim.cmd('packadd! matchit') -- enable matchit for vim. Needed for neovim?
vim.cmd("let b:match_words = '<<<<<<<:=======:>>>>>>>'")


-------------------------
--- HELPFUL MAGIC -------------------
  --git rev-parse --show-toplevel  -- SHOW root folder of project (VERY VERY VERY USEFUL)

return {
	name="cursorline",
	dependencies = {
'lewis6991/gitsigns.nvim'
	},
	config=function()
require('gitsigns').setup {
    sign_priority = 10,
	numhl= true,
    diff_opts = {
      algorithm = "minimal"
      -- split = "botright"
    }
  }
	end,
}
