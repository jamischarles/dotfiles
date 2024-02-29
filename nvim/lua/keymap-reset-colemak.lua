----------------------
-- Reset the keymapping for colemak layout
-- Similar to https://github.com/jooize/vim-colemak
-- https://blog.devgenius.io/create-custom-keymaps-in-neovim-with-lua-d1167de0f2c2
--

-- READ: https://thevaluable.dev/vim-create-text-objects/ (jumping around)
--
-- TODO: Add a detailed "desc" for each mapping that includes the file using debug
-- TODO: create an FzfLua list of all the keymaps
-- TODO: create a table listing of all the mappings done by lua with desc
--
-- interesting mapping plugin options
-- https://github.com/svermeulen/vimpeccable

-- emulates JS-type bind
function bind(func, args) -- TODO: allow variable param list
	return function()
		return func(unpack(args))
	end
end

local map = require("utils").mapKey
local unMap = require("utils").unmapKey
local feedkeys = require("utils").sendFeedKeys
-- (c     )  Command-line mode
-- ( i    )  Insert mode
-- (  n   )  Normal mode
-- (   o  )  Operator pending
-- (    v )  (Visual+) Select mode is for selection + type over it. (autocomplete uses this, to highlight, and then typing allows you to proceed )
-- (     x)  Visual mode (THIS is what i use for selection only) "Visual"

--------------------------
-- Debugging and lookup
-- Default mappings  :h index
-- Debugging mappings
-- TODO: Print a pretty map of this. Then make this a plugin. map() + debug mappings + print table of mappings.
-- Name: simpleMapper. superMapper, superMaps, superMap, luaMap
local function printMapping(mode)
	vim.pretty_print(vim.api.nvim_get_keymap(mode))
end
local function printBufMapping(mode)
	vim.pretty_print(vim.api.nvim_buf_get_keymap(0, mode))
end

-- TODO: allow param for mode type, and default of no modes
vim.api.nvim_create_user_command("VM", ":FzfLua keymaps", { desc = "Print global lua mappings" })
vim.api.nvim_create_user_command("VMBuffer", bind(printBufMapping, {'n'}), {desc="Print global lua mappings"})
-- vim.api.nvim_create_user_command("VMBuffer",":FzFlua" , { desc = "Print buffer local mappings" })

-- NAVIGATION (leaving out "O" because I don't want to use these in op pending mode)
map("nx", "n", "j")
map("nx", "N", "22j") -- search result reverse
map("nx", "e", "k")
map("nv", "E", "22k")
-- singleCharNav left/right
map("nx", "h", "h")
-- map("o", "i", "i")
--
--
-- WORD nav (forward and back) 
map("nx", "l", "b")
map("nx", "L", "B")
map("nx", "u", "w")
map("nx", "U", "W")
map("nx", "y", "e")
map("nx", "Y", "E")

-- Operator pending mode
map("o", "iu", "iw") -- add support for inner-word motion and around-word motion
map("o", "iU", "iW")
map("o", "au", "aw")
map("o", "aU", "aW")

map("o", "al", "ab") -- add support for around-block motion and inner-block motion
map("o", "aL", "aB") -- b -> paren block, B-> braces block 
map("o", "il", "ib")
map("o", "iL", "iB")

-- had to move this down to avoid conflicts with the operator pending mappings (caused the "wait-for-op" delay when I pressed i in normal mode (annoying))
map("nx", "i", "l", {nowait = true} )

unMap("o", "i") -- unmapping this preserves i as INNER motion in operator pending mode only

-- Operators
-- cib (change inner BLOCK) with parens
-- ciB    { with braces
-- ci(
-- ca* (includes the outside)

-- CAPS/BACKSPACE -> DELETE and ESCAPE and marks
-- map BS to marks in normal mode


-- FIXME: Should I just have all these call handlebackspace?
-- unMap("n", "<BS>") -- unmap handleBackSpace for normal mode Q: does it unmap the most recent thing?
-- map("n", "<BS>", "`") -- jump to last jump point (return)
map("n", "<BS><BS>", "``") --FIXME: busted...?
unMap("x", "<BS><BS>") -- ignore <BS><BS> in visual mode

map("nix", "<BS>", "<cmd>:HandleBackspace<CR>") -- insert and  visual mode should exit to normal mode
-- map("o", "<BS>", "`")

-- Q: how to handle OP pending?

-- create a global command
vim.api.nvim_create_user_command("HandleBackspace", function()
-- https://www.reddit.com/r/neovim/comments/s2v0cz/how_to_get_the_current_mode/
	local mode = vim.api.nvim_get_mode()["mode"]

        -- print("filetype",vim.bo.filetype)
	-- print("mode:"..mode)

	if mode == "n" then
		-- FIXME: read the modifier keys
		vim.api.nvim_feedkeys("'", "i", false) -- WHY DOES THIS WORK?!?!!? with the "i" modifier?
	elseif mode == "v" then
		-- vim.api.nvim_feedkeys("<ESC", "n", false)
		local keys = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
		vim.api.nvim_feedkeys(keys, "", true)

		-- select line mode
	elseif mode == "V" then
		local keys = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
		-- :h feedkeys for modifiers (2nd param)
		vim.api.nvim_feedkeys(keys, "", true)
		-- vim.api.nvim_feedkeys(":normal <ESC>", "n", false)
		-- feedkeys("<ESC>", "v") -- in Vim, Ctrl+h is mapped to backspace
		-- feedkeys("`", "n") -- in Vim, Ctrl+h is mapped to backspace
		--
	end

        -- if none of conditions are met, then escape insert and go to normal mode 
	-- if buffertype is NOT telescropPrompt, exit insert mode
	if vim.bo.filetype ~= "TelescopePrompt" then
          -- print('stopinsers', vim.bo.filetype)
          vim.cmd("stopinsert")
	else
          -- WORKS!!!! -> in telescope prompt, send backspace while in insert mode, ensures we can use backspace
          local keys = vim.api.nvim_replace_termcodes("<C-H>", true, false, true)
          vim.api.nvim_feedkeys(keys, "i", false) -- in Vim, Ctrl+h is mapped to backspace
	  end
        end, { nargs = 0 })



-- move this after "n" so it applies this over the other one
-- map("x", "<BS>", "<ESC>", { nowait = true }) -- nowait forces immediate execution. No waiting for another key to be typed that could match another set.
-- unMap("n", "<BS>") --unmap above setting in normal mode so we can preserve the jump point stuff
-- Order MATTERS. ^ This one needs to be after the x mapping for same key
map("n", "gs", "gi") -- gi - go to last insertion point

-- "no such mapping"
-- unMap('x', "`") -- unmap backtick (mark jump) in visual mode so <BS> doesn't get mapped to it (weirdly)

-- undo/redo
map("n", "z", "u")
map("x", "z", ":<C-U>undo<CR>")
map("n", "Z", ":redo")
map("x", "Z", ":<C-U>redo<CR>")

-- TODO: need to map U (undo for current line only!!!) -- exec normal is similar to feedkeys (same?)
-- VERY similar to git reset hunk (just minus the version control?)
-- vim.api.nvim_create_user_command("UndoLine", ":exec 'normal! U'", {nargs = 0})

-- cut/copy/paste --
map("n", "x", "dl")
map("n", "X", "dd")
-- map("x", "x", "d") -- mapping isn't needed? Happens naturally?
-- map("x", "X", "d")
-- unMap('n', "X")
map("x", "d", [["_d]], { nowait = true }) -- don't affect registers

map("n", "C", "yy")
map("x", "C", "yl")

-- if we set vx modes for 'c', then we need to explicity unmap 'c' for 'n' mode. Unsure why of this quirk.
map("vx", "c", "yl") -- copy single letter in visual mode. In normal mode we want it to stay the CHANGE op
unMap("n", "c") -- CHANGE operator. Keep this as original meaning. Needs to be before other C mappings

-- GENIUS https://stackoverflow.com/questions/3154556/paste-from-clipboard-in-vim-script
-- V -> PASTE after current line (wheter single or multi line yank)
-- map("n", "V", ":put +<cr>")
-- PASTE should NOT change the paste buffer (I should be able to paste 6 times
-- w/o having the previously replaced content show up now...
-- https://superuser.com/questions/321547/how-do-i-replace-paste-yanked-text-in-vim-without-yanking-the-deleted-lines
map("s", "v", ":<C-U>let @p = @+<CR>gvp:let @+ = @p<CR>")
map("s", "V", ":<C-U>let @P = @+<CR>gvp:let @+ = @P<CR>")

map("nx", "v", "p") -- ORDER MATTERS!!! Put this after the s-mode stuff
map("nx", "V", "P")

-- SURROUND
-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects use this as ds etc

-- Q: ANYTHING MISSING?
-- look in .vimrc.after.vim

-- ENTERING MODES
--x  a%            <Plug>(MatchitVisualTextObject)
map("nx", "a", "v")
unMap("o", "a") -- preserve a for AROUND in operator pending mode
map("nx", "A", "V")
-- map("n", "s", "i", {nowait=true})
-- unMap("o", "s")
map("n", "S", "I")
map("n", "t", "a")
map("n", "T", "A", { nowait = true })

-- unMap("o", "T") -- we don't need op pending for T (backwards til)

-- map("v", "T", "$$A") -- jump back to start and undo selection
-- map("v", "S", "^I")  ?? jump back to certain point?
-- map("o", "r", "i") ?? What does this do?
--x  t           * (mode() =~# "[V]" ? "\<C-V>0o$A" : "A")

-- operator mapping for s (SURROUND) like surround.vim from tpope
-- map("o", "s", nn

-- mode + convenience
map("n", "ww", [["_cc]]) -- clear the line, start at beginning in insert, and drop it into black hole register
-- map("nx", "w", "c") -- I never use this..., though it's better than the default

-- SEARCH Navigation
map("o", "f", "f") -- preserve original mapping for ops (find)
map("o", "t", "t") -- preserve original mapping for operations ('til)
-- map('o', 'T', 'T') -- preserve original mapping for operations ('til)
unMap("n", "t")
-- unMap('n', 'T') -- fix T for normal mode (jump to end of line) and insert . Maybe fix this later. for now I cae more about no conflicts than T working in op pending mode
map("n", "t", "a", { nowait = true })
unMap("o", "t") -- subtract mapping for op pending mode only

--
map("nx", "k", "n") -- search next result
map("nxv", "K", "N") -- search result reverse
--
--
--
--
-- handle backspace in telescope vs other environments

---------------------------
---- EXPERIMENTAL
--------------------------
--
--
--
--nmap  <silent> /c :set opfunc=SpecialChange<CR>g@
-- Make this a global function
_G.SpecialChange = function(type)
	-- vim.cmd("exec 'normal! `[v`]d'")
	vim.cmd([[exec 'normal! m`']]) -- mark jump point
	vim.cmd([[exec 'normal! f"']])
	vim.cmd([[exec "normal! r'"]])
	vim.cmd([[exec 'normal! F"']])
	vim.cmd([[exec "normal! r'"]])
	vim.cmd([[exec "normal! ``"]]) -- return back after
	-- vim.cmd("silent exec 'let @/=@\"'")
	-- vim.cmd("startinsert")
end

-- cs'" change surrounding ' to "

-- vim.api.nvim_create_user_command("SpecialChange", SpecialChange, {nargs = 0})

-- one working example
-- operatorfunc=v:lua.require'Comment.api'.locked.toggle_current_linewise_op

map("n", "<leader>c", ":set opfunc=SpecialChange<CR>g@")
--nmap  <silent> /c :set opfunc=SpecialChange<CR>g@

-- https://vi.stackexchange.com/a/37454
-- operatorfunc is a callback to g@ operator (+ any motion) that you can set
-- This seems to conflict with comment mapping so disabling this for now

-- function format_range_operator()
-- 	local old_func = vim.go.operatorfunc -- backup previous reference
-- 	-- set a globally callable object/function
-- 	_G.op_func_formatting = function()
-- 		-- the content covered by the motion is between the [ and ] marks, so get those
-- 		local start = vim.api.nvim_buf_get_mark(0, "[")
-- 		local finish = vim.api.nvim_buf_get_mark(0, "]")
-- 		vim.lsp.buf.range_formatting({}, start, finish)
-- 		vim.go.operatorfunc = old_func -- restore previous opfunc
-- 		_G.op_func_formatting = nil -- deletes itself from global namespace
-- 	end
-- 	vim.go.operatorfunc = "v:lua.op_func_formatting"
-- 	vim.api.nvim_feedkeys("g@", "n", false)
-- end
-- vim.api.nvim_set_keymap("n", "gm", "<cmd>lua format_range_operator()<CR>", { noremap = true })
--
--
--
--
