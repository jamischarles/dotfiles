----------------------------
-- This file contains shared utils that can be required from other lua files
-- -------------

-- https://blog.devgenius.io/create-custom-keymaps-in-neovim-with-lua-d1167de0f2c2
-- Assign an empty table to the local variable named Utils (it's standard to name the variable as "Utils")
local Utils = {}

------------------------
-- PUBLIC
-- -----------------------
--
-- READING:
-- :h map-commands
-- :h map-arguments
--
-- :map
-- :map!
-- The first command displays the maps that work in normal, visual and select and operator pending mode. The second command displays the maps that work in insert and command-line mode.

-- Define your function & add it the Utils table
-- TODO: add file location of the mapping for better tracing...
-- opts takes almost anything from :h map-arguments
function Utils.mapKey(modes, lhs, rhs, opts)
--traceback()
   -- noremap = recursive? WHAT does this actually do?
   -- :h recursive_mapping THIS is what allows you to easily swap mappings without it being circular
    local options = { noremap = true, desc="mode: " .. modes }
	options.desc = options.desc .. " src=" .. getMappingFilename()

    if opts then
        options = vim.tbl_extend("force", options, opts)
    end


    -- allow for mode to be 'n' or 'xno' which will then be split into each char and the map assigned
    for currentIndex = 1, string.len(modes)+1 do  -- for 1 to the number of letters in our text + 1
        local mode = string.sub(modes, currentIndex, currentIndex) -- similar to "someString"[currentIndex]
        -- vim.api.nvim_set_keymap(currentLetter, lhs, rhs, options)

        vim.api.nvim_set_keymap(mode, lhs, rhs, options)
        -- print (string.sub(mode, a,a)) -- split the string with the start and end at "a"
    end  -- repeat untill the for loop ends


    -- print(string.len(mode))
    --
    -- if string.len(mode) == 3 then
    --     print "YAS"
    -- else
    --     print "NOOO"
    -- end


end

function Utils.unmapKey(mode, lhs)
    vim.api.nvim_del_keymap(mode, lhs)
end

-- alone it works. But doesn't seem  to work well when required in from other files...?
-- use vim.fn.system() instead
function Utils.runShellCommand(cmd)
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()
	return result
end

-- TODO: Plugin: make it esasy to track down 1 result with fzf or similar... or use vim-s -filter... 
-- FIXME: Plugin: Allow some setting / glob to tell it what level of stacktrace to get...
-- FIXME: should I include a "track-over-time" thing for troubleshooting mappins as well? like if something is set/unset several times?   
function getMappingFilename ()
	local level = 1
	local secondToLast
	local lastLine 

	while true do -- does this go until an error is found?
		local info = debug.getinfo(level, "Sl")
		if not info then break end -- ah. THIS breaks it when info isn't found anymore
		if info.what == "C" then   -- is a C function?
			-- print(level, "C function")
		else   -- a Lua function
			secondToLast = lastLine
			lastLine = string.format("[%s]:%d",
			info.short_src, info.currentline)
		end
		level = level + 2
	end

	-- print(secondToLast)
	-- FIXME: maybe add to array, then get it that way?
	return secondToLast

end

function traceback ()
	local level = 1
	while true do
		local info = debug.getinfo(level, "Sl")
		if not info then break end
		if info.what == "C" then   -- is a C function?
			print(level, "C function")
		else   -- a Lua function
			print(string.format("[%s]:%d",
			info.short_src, info.currentline))
		end
		level = level + 2
	end
end




--https://neovim.io/doc/user/api.html (see nvim_feedkeys)
--https://neovim.io/doc/user/builtin.html#feedkeys()
function Utils.sendFeedkeys(keys, mode)
  vim.api.nvim_feedkeys(
  vim.api.nvim_replace_termcodes(keys, true, true, true),
  mode,
  false
  )
end

-- Since the Utils table is scoped, it has to be returned for usage elsewhere
return Utils
