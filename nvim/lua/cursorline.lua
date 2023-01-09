-------------------------------------
-- Cursorline plugin by me.
-- Highlights the number column of the current line you are on. 
-- This was very tricky because I had to override the signs added by gitSigns.
-- I did that by adding my own sign to the curren line with a higher priority.
-------------------------------------

-- :h sign_place, :h signs

vim.cmd('set number') -- show line numbers
vim.cmd('set cursorline') -- FIXME: find more lua way to do this? Maybe with the vim global options part?
vim.cmd('set cursorlineopt=number') -- only highlight the number, not the whole line
--

-- define the props for the new sign we want to add. -- TODO: consider adding slight bg highlight as well?
vim.fn.sign_define("MyCurrentLineHighlightSign", { numhl = "GitSignsChange" })

-- vim.fn.sign_place(999, "", "MyCurrentLineHighlightSign", vim.fn.bufname(), {lnum=24})

			-- call sign_place(5, '', 'sign2', 'json.c')

local CursorLine = {}

local function moveNumberHighlight()
	local lineNr,_ = unpack(vim.api.nvim_win_get_cursor(0))
	vim.fn.sign_unplace("MyCustomGroup", {buffer=vim.fn.bufname()}) -- :h sign_unplace
	vim.fn.sign_place("", "MyCustomGroup", "MyCurrentLineHighlightSign", vim.fn.bufname(), {lnum=lineNr, priority=100}) -- must be higher than signs from git-sign (10)
	-- vim.cmd("set cursorline") -- FIXME: find more lua way to do this? Maybe with the vim global options part?
end

-- init
CursorLine.setup = function()
	local myluafun = function()
		moveNumberHighlight()
	end

	vim.api.nvim_create_autocmd({ "CursorMoved" }, {
		callback = myluafun,
	})
end

return CursorLine

------********************** OLD VERSION. Worked really well. Didn't love the style

-- local CursorLine = {}
-- local timer = vim.loop.new_timer() -- like setTimeout
--
--
-- local function showHighlight()
-- 	vim.cmd('set cursorline') -- FIXME: find more lua way to do this? Maybe with the vim global options part?
-- end
-- local function hideHighlight()
-- 	vim.cmd('set nocursorline') -- FIXME: find more lua way to do this? Maybe with the vim global options part?
-- end
--
--
-- -- init
-- CursorLine.setup = function()
-- 	local lastLineNum = 0
-- 	local myluafun = function()
--
-- 		local line,_ = unpack(vim.api.nvim_win_get_cursor(0))
--
-- 		-- early return if we are on same line
-- 		if (line == lastLineNum) then return end
-- 		lastLineNum = line
--
-- 		showHighlight()
-- 		timer:start( 100, 0, vim.schedule_wrap(hideHighlight))
-- 		end
--
-- 		vim.api.nvim_create_autocmd({"CursorMoved"}, {
-- 			-- pattern = {"*.c", "*.h"},
-- 			callback = myluafun,  -- Or myvimfun
-- 		})
-- 	end
