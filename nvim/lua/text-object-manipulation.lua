-------------------------------------
-- TEXT OBJECTS and Text manipulation!
-------------------------------------

-- FIXME: Nest all this properly in the return obj

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






        -- config = function()
        --     require("textobj-diagnostic").setup()
        -- end,
-- original keys are destination. (is this because of noremap?)
-- " but use noremap (no re-map), so that the mapping uses the original meaning of any key on the right side of the mapping and not any new mapping that you might have given to that key." https://superuser.com/questions/526161/how-do-i-remap-vims-ctrlo
-- So we should always use the ORIGINAL key as the destination...
-- I think it goes and builds a mapping table before anything is done...

-- TODO: d* needs to be operator text objects

-- Q: What should this be for visual mode?
map("n", "dw", "de", {nowait = true}) -- dw delete to end of word -- mainly in operator pending mode?

-- https://vi.stackexchange.com/questions/122/performing-certain-operations-without-clearing-register
map("n", "<leader>d", [["aY"aP]])  -- duplicate current line. Normal and selection. Don't mess with copy/paste register
map("n", "dd", [["xdd]])  -- delete current line (keep the original mapping). normal mode only. in visual, single d should delete the whole selection. Don't yank to register (use '_', black hole register)

map("x", "d", [["_dd<esc>]], {nowait = true})  -- delete current line (keep the original mapping). normal mode only. in visual, single d should delete the whole selection. discard deleted line
unMap("n", "d") -- restore d* to prior behavior for normal mode

-- map("n", "<leader><CR>", "o<ESC>``") -- insert blank line below and stay in normal mode

-- map("n", "<leader><CR>", "o<ESC>``") -- insert blank line below and stay in normal mode

map("n", "<leader><CR>", ":set paste<CR>m`o<Esc>``:set nopaste<CR>") -- insert blank line below and stay in normal mode
-- map("o", [[s"']], [["m`fEsc>``:set nopaste<CR>]]) -- insert blank line below and stay in normal mode
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
-- function SurroundAndReplace(arguments)
function SurroundAndReplace(openToken, replacementOpenToken)
	-- local openToken = arguments.fargs[1]
	local closeToken = openToken -- start with assumption that open token is same as close token:  ', " " etc
	-- local replacementOpenToken = arguments.fargs[2]
	local replacementCloseToken = replacementOpenToken


	print(vim.inspect(openToken))
	print('HELLLLLLLLLLLLLLLLLLLLLO')
	local cursorStartPos = vim.api.nvim_win_get_cursor(0)

	-- handle when open & close token are different...
	if openToken == "{" then closeToken = "}" end
	if openToken == "(" then closeToken = ")" end
	if openToken == "[" then closeToken = "]" end
	if replacementOpenToken == "{" then replacementCloseToken = "}" end
	if replacementOpenToken == "(" then replacementCloseToken = ")" end
	if replacementOpenToken == "[" then replacementCloseToken = "]" end

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
	-- local startLine = openPos[1]
	-- local startCol = openPos[2]
	-- local startCol = vim.fn.getcurpos()[5] -- is this the right method?
	-- local startCol = vim.fn.col('.')
	-- local startCol = vim.fn.virtcol('.') -- col(), virtcol(), charcol()?!?
	-- print(startCol)
	-- local startLine, startCol = tokenOpenPos
	-- vim.api.nvim_buf_set_mark(0, "z", startLine, startCol, {})

	-- search backwards

	-- Wtf w
	-- :h searchpair is interesting
	-- :h searchpairpos could be EXACTLY what we need...
	-- local closeCol = vim.fn.searchpos([["]], 'cnz', vim.fn.line('.')) -- don't search farther than current line
	-- local startCol = vim.fn.searchpos([["]], 'bcnz', vim.fn.line('.')) -- don't search farther than current line

	-- zero on either means no match
	-- local pairResult = vim.fn.searchpairpos([["]], '', [["]],'cnz') -- don't search farther than current line

	-- FIXME: Check for zero here and print a message like "not found"

	-- Q: Should we just do a single char sub here?
	feedkeys('f'.. closeToken, "n") -- is there a Lua alternative?
	-- local closePos = vim.api.nvim_win_get_cursor(0)
	-- local closeLine = closePos[1]
	-- local closeLine = vim.fn.line('.') -- current line
	print("virtCol" .. vim.fn.virtcol('.')) -- WORKS TOO!!! so was the cursor movement the problem?
	-- local closeCol = closePos[2]
	-- local closeCol = vim.fn.getcurpos()[5] -- is this the right method?

	-- vim.api.nvim_buf_set_mark(0, "x", closeLine, closeCol, {})

	print("--------------------")



	-- replace open token
	-- print("startCol:" .. startCol)
	-- print("##str" .. string.sub(vim.api.nvim_get_current_line(), 0, startCol-2))
	-- local str2 = string.sub(vim.api.nvim_get_current_line(), 0, startCol)
	-- print(#str2)
	-- local byteLen = #str2
	-- TODO: convert startCol to byte via len(str)
	--nvim_get_current_line()
	--`vim.api.nvim_buf_get_lines(buf, firstline, new_lastline, true)`
	print("openPos", openPos[2])
	print("opentToken", openToken)
	-- print(vim.inspect(startLine))
	-- print("startCol: ",  vim.inspect(startCol))
	-- print(vim.inspect(closeLine))
	-- print(vim.inspect(closeCol))
	-- arstrtcs arstarst arst arst
	--
	-- FIXME: handle the 'near tags' use case?
	-- FIXME: Handle the "no result found" use case print message? Fail gracefully?
	-- FIXME: add wildcard for third so I can use whatever replacement input?
	-- FIXME: add "WRAP" use case
	--
	-- accept current cursor pos as a match
	-- search backwards until we find the openToken
	local startLine, startCol = unpack(vim.fn.searchpos(openToken, 'bnc', vim.fn.line('.'))) -- don't search farther than current line

	-- TODO: should have looked at nvim_put
	vim.api.nvim_buf_set_text(0, startLine-1, startCol-1, startLine-1, startCol, {replacementOpenToken})

	-- certain cases (like delete char) we need to search for it AFTER we delete one because the cursCol pos will change
	-- local closeLine, closeCol = unpack(vim.fn.searchpos(closeToken, 'n', vim.fn.line('.'))) -- don't search farther than current line

	-- local closeLine, closeCol = unpack(vim.fn.searchpairpos(openToken, "", closeToken, 'n', vim.fn.line('.'))) -- don't search farther than current line

	-- find the matching token. Essentially same as typing '%'. Helps with nested tokens to find the right match
	--
	-- if open and close tokens are the same we cannot use seachpairpos becuase that fn must have different open/close tokens passed in
	if openToken == closeToken then -- quotes etc
		closeLine, closeCol = unpack(vim.fn.searchpos(closeToken, 'n', vim.fn.line('.'))) -- don't search farther than current line
	else -- braces etc that are different
		closeLine, closeCol = unpack(vim.fn.searchpairpos(openToken, "", closeToken, 'n' )) -- allow searching past current line
	end

	print("closeLine:".. closeLine)
	print("closeCol:".. closeCol)
	vim.api.nvim_buf_set_text(0, closeLine-1, closeCol-1, startLine-1, closeCol, {replacementCloseToken})
	-- don't move cursor. Does NOT accept current pos as match.


	-- vim.fn.setbufline()
	-- vim.fn.setline
	-- setcursorcharpos

	-- vim.api.nvim_buf_set_text(0, startLine-1, 0, startLine-1, 1, {[[']]}) -- offset end col by 1 if we want a replace
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


-- wrap
-- ca -> Change Around
-- https://vi.stackexchange.com/a/21119
function SurroundWithToken()
	-- local cursorStartPos = vim.api.nvim_win_get_cursor(0)
	-- FIXME: return curs pos. ^ doesn't work, prolly becaue there's a shift anyway?
	local first = vim.api.nvim_exec('echo getcharstr()', true)
	feedkeys("ciw", "n", true)
	feedkeys(first, "", true)
	feedkeys(first, "", true)
	feedkeys("<ESC>P", "n", true)

	-- restore cursor to original pos
	-- vim.api.nvim_win_set_cursor(0, cursorStartPos)
end
--
function ChangeSurroundingToken()
	local first = vim.api.nvim_exec('echo getcharstr()', true)
	local second = vim.api.nvim_exec('echo getcharstr()', true)
	SurroundAndReplace(first,second)
	-- print("HELLO: ".. first .. "|" .. second)
	-- try a motion, then match that in both dirs. Or try cword)
end


function DeleteSurroundingToken()
	local first = vim.api.nvim_exec('echo getcharstr()', true)
	SurroundAndReplace(first,"blank")

end

-- BUGS to fix:
-- X Matches wrong pair currently (finds first ocurrence instead of match) Fails with nested params
-- X Solution: use searchpairpos() - FIXED
--
-- FUTURE:
-- Support ranges? (like the json use case)
-- X add wrap support (use different ergonimics than surround.vim). again json use case - FIXED
-- support dot command?
--  

-- vim.api.nvim_create_user_command("SurroundAndReplace", SurroundAndReplace, {nargs = "*"})
vim.api.nvim_create_user_command("SurroundWithToken", SurroundWithToken, {nargs = "*"})
vim.api.nvim_create_user_command("ChangeSurroundingToken", ChangeSurroundingToken, {nargs = "*"})
vim.api.nvim_create_user_command("DeleteSurroundingToken", DeleteSurroundingToken, {nargs = "*"})


-- TODO: use this appraoch:
-- https://www.davekuhlman.org/nvim-lua-info-notes.html
-- Go all in on Lua
-- See if we can do the whole thing in script without moving the cursor. Then swap the code


-- Very naive & simple one for now... We can do more complex stuff later (like use 'opfunc')
-- map('o', 's"\'', ':<C-u>silent! normal! f"F"lvt\'<cr>')
-- map('o', 's"\'', SurroundAndReplace) -- TODO: Write a func for this? May be getting complex enough now...
-- vim.api.nvim_set_keymap("o", [[s"']], [[<ESC>maf"r'F"r'"`a]], {noremap = true})
-- vim.api.nvim_set_keymap("o", [[s"']], [[:SurroundAndReplace "<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
--
vim.api.nvim_set_keymap("n", "cw", ":SurroundWithToken<CR>", {noremap = true}) -- TODO: Can we use this to have live op for last one?
vim.api.nvim_set_keymap("n", "csa", ":SurroundWithToken<CR>", {noremap = true}) -- TODO: Can we use this to have live op for last one?
vim.api.nvim_set_keymap("n", "cs", ":ChangeSurroundingToken<CR>", {noremap = true}) -- TODO: Can we use this to have live op for last one?
-- vim.api.nvim_set_keymap("n", "ca", ":SurroundingWithToken<CR>", {noremap = true}) -- TODO: Can we use this to have live op for last one?
vim.api.nvim_set_keymap("n", "ds", ":DeleteSurroundingToken<CR>", {noremap = true}) -- TODO: Can we use this to have live op for last one?
-- vim.api.nvim_set_keymap("n", "dd", [["_yy]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
-- vim.api.nvim_set_keymap("n", [[cs"']], [[:SurroundAndReplace " getcharstr()<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
-- vim.api.nvim_set_keymap("n", [[cs'"]], [[:SurroundAndReplace ' "<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
-- vim.api.nvim_set_keymap("n", [[cs`']], [[:SurroundAndReplace ` '<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
--
-- vim.api.nvim_set_keymap("n", [[cs({]], [[:SurroundAndReplace ( {<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
-- vim.api.nvim_set_keymap("n", [[cs([]], [[:SurroundAndReplace ( [<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
-- vim.api.nvim_set_keymap("n", [[cs{(]], [[:SurroundAndReplace { (<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?

-- vim.api.nvim_set_keymap("n", [[ds"]], [[:SurroundAndReplace " blank<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
-- -- vim.api.nvim_set_keymap("n", [[ds"]], [[:lua SurroundAndReplace('"', false)<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
-- vim.api.nvim_set_keymap("n", [[ds']], [[:SurroundAndReplace ' blank<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
--
-- vim.api.nvim_set_keymap("n", [[ds{]], [[:SurroundAndReplace { blank<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
-- vim.api.nvim_set_keymap("n", [[ds(]], [[:SurroundAndReplace ( blank<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
-- vim.api.nvim_set_keymap("n", [[ds(]], [[:SurroundAndReplace { blank<CR>]], {noremap = true}) -- TODO: Can we use this to have live op for last one?
--
-- WRAP

map("o", [[s"']], [["m`fEsc>``:set nopaste<CR>]])
-- TODO: wrap surround? use expand(<cword>)?

-- wrap word

-- can we even use op pending? We're essentially creating a new operator...


-- unMap('n', 's')
map('n', 's', 'i', {nowait=true})
unMap('o', 's')
unMap('v', 's') -- don't enter when were are in SELECT mode. we want autocompletion to be in insertion mode after completing a snippet 


return {
name = "text-object-manipulation",
dependencies = {
 "andrewferrier/textobj-diagnostic.nvim"

},
config= function()

-- jump to next/prev lsp error
require("textobj-diagnostic").setup({create_default_keymaps = false})
map('n', '[t', "<cmd>lua require('textobj-diagnostic').next_diag()<CR><esc>")
map('n', ']t', "<cmd>lua require('textobj-diagnostic').prev_diag()<CR><esc>")
end
}

