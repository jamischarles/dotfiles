-------------------------------------
-- Cursorline plugin by me.
-- Helps you find your spot by showing a brief line highlight after you jump lines
-------------------------------------

-- TODO: find a more mild highlight with some debouncing and maybe just havea "lost cursors"
-- or modify the cursor color for these themes

local CursorLine = {}
local timer = vim.loop.new_timer() -- like setTimeout


local function showHighlight()
	vim.cmd('set cursorline') -- FIXME: find more lua way to do this? Maybe with the vim global options part?
end
local function hideHighlight()
	vim.cmd('set nocursorline') -- FIXME: find more lua way to do this? Maybe with the vim global options part?
end


-- init
CursorLine.setup = function()
	local lastLineNum = 0
	local myluafun = function()

		local line,_ = unpack(vim.api.nvim_win_get_cursor(0))

		-- early return if we are on same line
		if (line == lastLineNum) then return end
		lastLineNum = line

		showHighlight()
		timer:start( 100, 0, vim.schedule_wrap(hideHighlight))end

		vim.api.nvim_create_autocmd({"CursorMoved"}, {
			-- pattern = {"*.c", "*.h"},
			callback = myluafun,  -- Or myvimfun
		})
	end


return CursorLine
