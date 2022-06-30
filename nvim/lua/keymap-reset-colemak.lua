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
-- (    v )  Visual+Select mode (this is what I use all the time. What is x for?!?!?
-- (     x)  Visual mode

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
map("nx", "i", "l")

unMap("o", "i") -- unmapping this preserves i as INNER motion in operator pending mode only
-- map("o", "i", "i")
--
--
-- WORD nav (forward and back) ("o" mode mapping means these can be used in op pending mode AYAY)
map("nxo", "l", "b")
map("nxo", "L", "B")
map("nxo", "u", "w")
map("nxo", "U", "W")
map("nxo", "y", "e")
map("nxo", "Y", "E")

-- CAPS/BACKSPACE -> DELETE and ESCAPE and marks
-- map BS to marks in normal mode
map("n", "<BS><BS>", "``") --FIXME: busted...?

map("i", "<BS>", "<cmd>:HandleBackspace<CR>")
map("x", "<BS>", "<ESC>", { nowait = true }) -- nowait forces immediate execution. No waiting for another key to be typed that could match another set.

-- quick jump points
map("n", "<BS>", "`") -- jump to last jump point (return)
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
-- map("x", "x", "d") -- if we
map("x", "X", "d")
map("v", "d", "d", { nowait = true })

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
map("n", "ww", "cc")
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
-- create a global command
-- FIXME: move this somewhere else?
vim.api.nvim_create_user_command("HandleBackspace", function()
	-- if buffertype is NOT telescropPrompt, exit insert mode
	if vim.bo.filetype ~= "TelescopePrompt" then
		vim.cmd("stopinsert")
	else
		feedkeys("<C-H>", "i") -- in Vim, Ctrl+h is mapped to backspace
	end
end, { nargs = 0 })

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
function format_range_operator()
	local old_func = vim.go.operatorfunc -- backup previous reference
	-- set a globally callable object/function
	_G.op_func_formatting = function()
		-- the content covered by the motion is between the [ and ] marks, so get those
		local start = vim.api.nvim_buf_get_mark(0, "[")
		local finish = vim.api.nvim_buf_get_mark(0, "]")
		vim.lsp.buf.range_formatting({}, start, finish)
		vim.go.operatorfunc = old_func -- restore previous opfunc
		_G.op_func_formatting = nil -- deletes itself from global namespace
	end
	vim.go.operatorfunc = "v:lua.op_func_formatting"
	vim.api.nvim_feedkeys("g@", "n", false)
end
vim.api.nvim_set_keymap("n", "gm", "<cmd>lua format_range_operator()<CR>", { noremap = true })
--
--
--
--
