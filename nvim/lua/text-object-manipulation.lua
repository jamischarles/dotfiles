-------------------------------------
-- TEXT OBJECTS and Text manipulation!
-------------------------------------

-- READING 
-- https://thevaluable.dev/vim-create-text-objects/
-- https://www.davekuhlman.org/nvim-lua-info-notes.html <-------- TRY THIS
-- :h marks
-- :h jumps
--
-- LIBS
-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
-- https://github.com/RRethy/nvim-treesitter-textsubjects
--
local map = require('utils').mapKey
local unMap = require('utils').unmapKey
local feedkeys = require('utils').sendFeedkeys

-- original keys are destination. (is this because of noremap?)
-- " but use noremap (no re-map), so that the mapping uses the original meaning of any key on the right side of the mapping and not any new mapping that you might have given to that key." https://superuser.com/questions/526161/how-do-i-remap-vims-ctrlo
-- So we should always use the ORIGINAL key as the destination...
-- I think it goes and builds a mapping table before anything is done...

-- TODO: d* needs to be operator text objects

-- Q: What should this be for visual mode?
map("n", "dw", "de", {nowait = true}) -- dw delete to end of word -- mainly in operator pending mode?

map("nv", "<leader>d", "YP")  -- duplicate current line. Normal and selection
map("nx", "dd", "dd<esc>")  -- delete current line (keep the original mapping)

-- map("n", "<leader><CR>", "o<ESC>``") -- insert blank line below and stay in normal mode

-- map("n", "<leader><CR>", "o<ESC>``") -- insert blank line below and stay in normal mode

map("n", "<leader><CR>", ":set paste<CR>m`o<Esc>``:set nopaste<CR>") -- insert blank line below and stay in normal mode
map("o", [[s"']], [["m`fEsc>``:set nopaste<CR>]]) -- insert blank line below and stay in normal mode
-- explained: https://vim.fandom.com/wiki/Quickly_adding_and_deleting_empty_lines
--
--
map('n', '<leader>;', 'A;<ESC>') -- append line with ;
map('n', '<leader>,', 'A,<ESC>') -- append line with ,

-- OPERATORS
-- https://learnvimscriptthehardway.stevelosh.com/chapters/15.html
-- o mode is for OPERATOR PENDING
-- TODO: Make that work with visual range

-- indentation dec/inc
map("nv", "<leader>[", "<<") 
map("nv", "<leader>]", ">>") 

---------------------
--CREATING new TEXT OBJECTS (like $ or ^ etc). Things you can operate on
-- https://thevaluable.dev/vim-create-text-objects/
-- -----------------------------
--
-- local print_two_things = function (x, y)
--   print(x.a)
--   print(x.b)
-- end
--
-- function print_it (arg)
-- 	printResult = printResult .. "\n"
-- end

-- TODO: Make this a plugin called surround.nvim on github...?
-- TODO: write some simple assertion test cases for this?
function SurroundAndReplace(arguments)
	local openToken = arguments.fargs[1]
	local closeToken = openToken -- start with assumption that open token is same as close token:  ', " " etc
	local replacementOpenToken = arguments.fargs[2]
	local replacementCloseToken = replacementOpenToken


	print(vim.inspect(openToken))
	print('HELLLLLLLLLLLLLLLLLLLLLO')
	local cursorStartPos = vim.api.nvim_win_get_cursor(0)

	-- handle when open & close token are different...
	if openToken == "{" then closeToken = "}" end
	if openToken == "(" then closeToken = ")" end
	if replacementOpenToken == "{" then replacementCloseToken = "}" end
	if replacementOpenToken == "(" then replacementCloseToken = ")" end

	-- handle deletion use case
	if replacementOpenToken == "blank" then
		replacementOpenToken = ""
		replacementCloseToken = ""
	end -- if nil make it empty

	-- move to start of char (search backwards on same line)
	-- vim.cmd('F'.. char) -- is there a Lua alternative?
	feedkeys('F'.. openToken, "n") -- is there a Lua alternative? feedkeys is similar to vim.cmd('exec normal "F")
	print(vim.inspect(openToken))
	-- lua vim.cmd(vim.api.nvim_replace_termcodes("normal! vw<Esc>", true, true, true))
	-- local tokenOpenPos = vim.api.nvim_win_get_cursor()
	local openPos = vim.api.nvim_win_get_cursor(0)
	local startLine = openPos[1]
	-- local startCol = openPos[2]
	local startCol = vim.fn.getcurpos()[5]
	-- local startLine, startCol = tokenOpenPos
	vim.api.nvim_buf_set_mark(0, "z", startLine, startCol, {})

	-- Q: Should we just do a single char sub here?
	feedkeys('f'.. closeToken, "n") -- is there a Lua alternative?
	local closePos = vim.api.nvim_win_get_cursor(0)
	local closeLine = closePos[1]
	local closeCol = closePos[2]

	vim.api.nvim_buf_set_mark(0, "x", closeLine, closeCol, {})

	print("--------------------")



	-- replace open token
	print("startCol" .. startCol)
	print("##str" .. string.sub(vim.api.nvim_get_current_line(), 0, startCol-2))
	local str2 = string.sub(vim.api.nvim_get_current_line(), 0, startCol)
	print(#str2)
	local byteLen = #str2
	-- TODO: convert startCol to byte via len(str)
	--nvim_get_current_line()
	--`vim.api.nvim_buf_get_lines(buf, firstline, new_lastline, true)`
	vim.api.nvim_buf_set_text(0, startLine-1, startCol-2, startLine-1, startCol, {[["]]})
	-- replace close token
	-- vim.api.nvim_buf_set_text(0, closeLine-1, closeCol-1, closeLine-1, closeCol-1, {replacementCloseToken})

	-- Q: should we try using nvim_buf_get_lines() and then transforming the string with lua?
	-- use normal vim search/replace over the range
	--
	-- TODO: SIMPLIFY THIS. Don't use regex...

	-- -- replace open token (don't use /g so it only replaces the first match)
	-- vim.cmd([[:'<,'>:s/]] .. openToken .. [[/]] .. replacementOpenToken .. [[/]]) -- TODO: Try to include \%V
	--
	-- -- replace close token
	-- vim.cmd([[:'<,'>:s/]] .. closeToken .. [[/]] .. replacementCloseToken .. [[/]]) -- TODO: Try to include \%V

	-- restore cursor to original pos
	vim.api.nvim_win_set_cursor(0, cursorStartPos)

	-- TODO: clear the marks?
end

function DeleteSurroundingToken()
end

-- wrap
function surroundWithToken()
	-- try a motion, then match that in both dirs. Or try cword)
end

vim.api.nvim_create_user_command("SurroundAndReplace", SurroundAndReplace, {nargs = "*"})


-- TODO: use this appraoch:
-- https://www.davekuhlman.org/nvim-lua-info-notes.html
-- Go all in on Lua
-- See if we can do the whole thing in script without moving the cursor. Then swap the code


-- Very naive & simple one for now... We can do more complex stuff later (like use 'opfunc')
-- map('o', 's"\'', ':<C-u>silent! normal! f"F"lvt\'<cr>')
-- map('o', 's"\'', SurroundAndReplace) -- TODO: Write a func for this? May be getting complex enough now...
-- vim.api.nvim_set_keymap("o", [[s"']], [[<ESC>maf"r'F"r'"`a]], {noremap = true})
-- vim.api.nvim_set_keymap("o", [[s"']], [[:SurroundAndReplace "<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
vim.api.nvim_set_keymap("n", [[cs"']], [[:SurroundAndReplace " '<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
vim.api.nvim_set_keymap("n", [[cs'"]], [[:SurroundAndReplace ' "<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?

vim.api.nvim_set_keymap("n", [[cs({]], [[:SurroundAndReplace ( {<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
vim.api.nvim_set_keymap("n", [[cs{(]], [[:SurroundAndReplace { (<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?

vim.api.nvim_set_keymap("n", [[ds"]], [[:SurroundAndReplace " blank<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
-- vim.api.nvim_set_keymap("n", [[ds"]], [[:lua SurroundAndReplace('"', false)<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
vim.api.nvim_set_keymap("n", [[ds']], [[:SurroundAndReplace ' blank<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?

vim.api.nvim_set_keymap("n", [[ds{]], [[:SurroundAndReplace { blank<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
vim.api.nvim_set_keymap("n", [[ds(]], [[:SurroundAndReplace ( blank<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
-- vim.api.nvim_set_keymap("n", [[ds(]], [[:SurroundAndReplace { blank<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?

-- TODO: wrap surround? use expand(<cword>)?

-- wrap word

-- can we even use op pending? We're essentially creating a new operator...

-- unMap('n', 's')
map('n', 's', 'i', {nowait=true})
unMap('o', 's')
