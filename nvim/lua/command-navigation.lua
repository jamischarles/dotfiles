--------------------------
-- Command navigation like for buffers, etc using FZF
-- -----------------------
-- Libs to look at!!!
-- https://github.com/skywind3000/asyncrun.vim (async run shell cmd and pipe return to quickfix window
--

local map = require("utils").mapKey
local use = require("packer").use

use({
	"ibhagwan/fzf-lua",
	-- optional for icon support
	requires = { "kyazdani42/nvim-web-devicons" },
})

use({
	"nvim-telescope/telescope.nvim",
	requires = { { "nvim-lua/plenary.nvim" } },
})

use({
	"nvim-telescope/telescope-frecency.nvim",
	config = function()
		require("telescope").load_extension("frecency")
	end,
	requires = { "tami5/sqlite.lua" },
})

---------------------
-- Telescope for frecency
------------------
require("telescope").load_extension("frecency")
require('telescope').setup({
  defaults = {
    layout_config = {
      horizontal = {height = 0.95, width = 0.9 },
      vertical = {height = 0.9, width = 0.9 }
      -- other layout configuration here
    },
    -- other defaults configuration here
  },
  -- other configuration values here
})


-----------------
-- FZF-LUA
-- ---------------
local actions = require("fzf-lua.actions")
local utils = require("fzf-lua.utils")
local enterKey = utils.ansi_codes.yellow("<Return>")
local delBuffer = utils.ansi_codes.yellow("<Ctrl-X>")
require("fzf-lua").setup({
	keymap = {
		["<ctrl-a>"] = "preview-page-down", -- navigate preview up/down
		["<c-a>"] = "preview-page-down", -- navigate preview up/down
		["<C-e>"] = "preview-page-up",
		["<F7>"] = "toggle-preview",
		-- Rotate preview clockwise/counter-clockwise
		["<F5>"] = "toggle-preview-ccw",
		["<F6>"] = "toggle-preview-cw",
		["<S-down>"] = "preview-page-down",
		["<S-up>"] = "preview-page-up",
		["<S-left>"] = "preview-page-reset",
},
	winopts = {
		-- split         = "belowright new",-- open in a split instead?
		-- "belowright new"  : split below
		-- "aboveleft new"   : split above
		-- "belowright vnew" : split right
		-- "aboveleft vnew   : split left
		-- Only valid when using a float window
		-- (i.e. when 'split' is not defined, default)
		height = 0.98, -- window height
		width = 0.95, -- window width
		row = 0.50, -- window row position (0=top, 1=bottom)
		col = 0.50,
		fullscreen = true,

		preview = {
			scrollbar = "float",
			layout = "vertical",
			vertical = "up:75%",
		},
	},
	-- provider setup
	files = {
		-- previewer      = "bat",          -- uncomment to override previewer
		-- (name from 'previewers' table)
		-- set to 'false' to disable
		prompt = "Files❯ ",
		multiprocess = true, -- run command in a separate process
		git_icons = false, -- show git icons? -- TOO slow
		file_icons = true, -- show file icons?
		-- color_icons = true, -- colorize file|git icons
		-- path_shorten   = 1,              -- 'true' or number, shorten path?
		-- executed command priority is 'cmd' (if exists)
		-- otherwise auto-detect prioritizes `fd`:`rg`:`find`
		-- default options are controlled by 'fd|rg|find|_opts'
		-- NOTE: 'find -printf' requires GNU find
		cmd = "fd --color=never --type f --hidden --follow --exclude .git --exclude locales --exclude tests/functional",
		-- find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
		-- rg_opts = "--color=never --files --hidden --follow -g '!.git'",
		-- fd_opts = "--color=never --type f --hidden --follow --exclude .git",
		actions = {
			-- inherits from 'actions.files', here we can override
			-- or set bind to 'false' to disable a default action
			["default"] = actions.file_edit,
			-- custom actions are available too
			["ctrl-y"] = function(selected)
				print(selected[1])
			end,
		},
	},
	git = {
		status = {
			cmd = "git status --porcelain", -- needed to not break the ansi formatting. Q: should this be default?
			actions = {
				["ctrl-x"] = {
					function(selected)
						vim.cmd(":!git checkout " .. selected[1])
					end,
					require("fzf-lua.actions").resume,
				},
			},
			["--header"] = vim.fn.shellescape(("%s to reset to head, %s to open"):format("ctrl-X", enterKey)),
		},
	},
	buffers = {
		fzf_opts = {
			["--header"] = vim.fn.shellescape(("%s to close buffer, %s to open"):format(delBuffer, enterKey)),
		},
	},
	-- https://github.com/ibhagwan/fzf-lua/blob/d02d6f2f6bf951c461d52bdbe97784ce87243318/lua/fzf-lua/providers/git.lua#L43
	-- ctrl-x deletes buffer. FIXME: Can we print that info?
	-- actions we can do when inside those windows
	actions = {
		--   ["default"]     = actions.buf_edit,
		--   ["ctrl-d"]     = actions.buf_del
		-- }
		--
		buffers = {
			-- providers that inherit these actions:
			--   buffers, tabs, lines, blines
			["default"] = actions.buf_edit,
			["ctrl-s"] = actions.preview_page_down,
			["c-s"] = actions.preview_page_down,
		},
	},
})

local fzf_lua = require("fzf-lua")

-- https://github.com/ibhagwan/fzf-lua/issues/196
-- Allow delete action from the buffer window
local function fzf_buffersWithDelete(opts)
	if not opts then
		opts = {}
	end
	local action = require("fzf.actions").action(function(selected)
		fzf_lua.actions.buf_del(selected)
		fzf_lua.win.set_autoclose(false)
		fzf_buffersWithDelete(opts)
		fzf_lua.win.set_autoclose(true)
	end, "{+}")
	if not opts.curbuf then
		-- make sure we keep current buffer at the header
		opts.curbuf = vim.api.nvim_get_current_buf()
	end
	opts.actions = { ["ctrl-x"] = false }
	opts.fzf_cli_args = ("--bind=ctrl-x:execute-silent:%s"):format(action)
	fzf_lua.buffers(opts)
end

function Trim(s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

-------------------------
-- AutoCommands
-------------------------
-- track frecency of buffers I load in nvim. We'll use this to generate a frecency list for history
-- ONLY do this for buffers that are writable (should avoid help windows etc, quickfix windows etc)

-- vim.api.nvim_create_autocmd({ "BufEnter" }, { -- do we need both? BufWinEnter
-- 	-- update CLI command for manual frecency
-- 	-- command = ':silent !fre --add ' .. vim.fn.expand('%')  -- FIXME: Find lua api of this?
-- 	callback = function()
-- 		local curFilePath = vim.api.nvim_buf_get_name(0)
-- 		local isBufReadOnly = vim.api.nvim_buf_get_option(0, "readonly")
--
-- 		local gitProjectRoot = Trim(vim.fn.system("git rev-parse --show-toplevel"))
--
-- 		-- print("maybe adding: " .. curFilePath)
--
-- 		-- TODO: Filter for files in current project path(check with git?)
-- 		if not string.find(curFilePath, gitProjectRoot) then
-- 			return
-- 		end -- is currently in project path
-- 		if isBufReadOnly then
-- 			return
-- 		end -- is buffer writable (should weed out help files etc)
--
-- 		-- print("adding: " .. curFilePath)
-- 		vim.cmd(":silent !fre --add " .. curFilePath) -- add to fre
-- 	end,
--
-- 	-- PRUNTNG & QUALITY:
-- 	-- TODO: Add some methods for pruning & deleting or filtering on the dataset when it goes in (ignore help files etc)
--
-- 	-- command = ':silent !fre --add ' .. vim.fn.expand('%')  -- FIXME: Find lua api of this?
-- 	--
-- 	-- command = ':silent !fre --add ' .. vim.fn.expand('%')  -- FIXME: Find lua api of this?
-- 	-- callback = function()
-- 	--  local timeout_in_ms = 20
-- 	--  local pipe = io.popen('ls')
-- 	--  vim.defer_fn(function()
-- 	--   pipe:flush()
-- 	--   pipe:close()
-- 	--  end, timeout_in_ms)
-- 	-- end
-- })

-------------------------
-- MAPPINGS
-------------------------

-- vim.api.nvim_create_user_command('FzfBuffersWithDeleteAction', fzf_buffersWithDelete,  { nargs = 0 })

-- map("n", "<Leader>b", ":FzfBuffersWithDeleteAction<CR>")
map("n", "<Leader>t", ":FzfLua files<CR>")
map("n", "<Leader>g", ":FzfLua git_status<CR>")
map("n", "<Leader>b", ":FzfLua buffers<CR>") -- could we sort this by frecency? interesting!!!
map("n", "<Leader>m", ":Telescope frecency<CR>") -- uses my custom frecency usin `fre` (see above)

-- retiring my own custom solution for now...
-- map(
-- 	"n",
-- 	"<Leader>m",
-- 	':lua require(\'fzf-lua\').files({cmd = "fre --sorted", actions = {["ctrl-x"] = {function(selected) vim.cmd(":!fre --delete ".. selected[1]) end, require"fzf-lua.actions".resume} }})<CR>'
-- )


-- FIXME: Can we cache this somehow to speed it up?
-- https://github.com/junegunn/fzf/issues/1740 (caching commentary

-- CLTRL-X deletes the result from the frecency dataset YASSSS
--fre --sorted | fzf | xargs fre -D -- really we just need the command that ctr-d or ctrl-x would execute. fre --delete FILENAME
-- can I map actions on these?

map("n", "<Leader>e", ":FzfLua files cwd=~/.dotfiles/nvim<CR>") -- change folder for files() lookup

-- Custom commands!!!
map("n", "<Leader>e", ":FzfLua files cwd=~/.dotfiles/nvim<CR>") -- change folder for files() lookup

-- vim.api.nvim_create_user_command('Rg', fzf_buffersWithDelete,  { nargs = 1 })
vim.api.nvim_create_user_command("Rg", function(arguments)
	require("fzf-lua").files({
		actions = { ["default"] = actions.file_edit },
		cmd = "rg  --fixed-strings --max-count 1 --column --line-number --no-heading --color=always --smart-case --iglob !locales -- " .. arguments.args,
	}) --ignores locales/*

	-- ['--header'] = vim.fn.shellescape(('%s to close buffer, %s to open'):format(delBuffer, enterKey))    }
	-- Old cmd-t function I used...
	-- require('fzf-lua').files({cmd = 'rg --files --hidden --glob="!.git/*"'})
end, {
	nargs = "*",
	desc = "Say hi to someone",
})

-- search all hidden folders as well
vim.api.nvim_create_user_command("Rga", function(arguments)
	require("fzf-lua").files({
		actions = { ["default"] = actions.file_edit },
		cmd = "rg  --fixed-strings --max-count 1 --column --line-number --no-heading --color=always --no-ignore --ignore-case -- "
			.. arguments.args,
	})
end, {
	nargs = "*",
	desc = "Say hi to someone",
})

-- search only git changed files
vim.api.nvim_create_user_command("Rgg", function(arguments)
	require("fzf-lua").files({
		actions = { ["default"] = actions.file_edit },

		cmd = "git status --porcelain | sed s/^...// | xargs rg  --fixed-strings --max-count 1 --column --line-number --no-heading --color=always --smart-case --iglob !locales -- " .. arguments.args,
	})
end, {
	nargs = "*",
	desc = "Say hi to someone",
})


local getOpenBufferList = function()
	local bufferFileNames = {}
	for _, bufNum in ipairs(vim.api.nvim_list_bufs()) do
		-- map[b] = true
		-- if vim.fn.buflisted(bufNum) then
		local isListed = unpack(vim.fn.getbufinfo(bufNum))['listed'] -- weird way of getting open buffers
		if isListed == 1 then
			-- table.insert(bufferFileNames, vim.api.nvim_buf_get_name(bufNum))
			table.insert(bufferFileNames, vim.api.nvim_buf_get_name(bufNum))
		end
	end
	return bufferFileNames
end

-- print(vim.inspect(getOpenBufferList()))
	-- print(vim.fn.shellescape(table.concat(getOpenBufferList(), '\n')))

-- search only across open buffers
vim.api.nvim_create_user_command("Rgb", function(arguments)
	local openBufferNames = getOpenBufferList()
	-- could just use fzf-lua lines (pretty cool!)
	require("fzf-lua").files({
		actions = { ["default"] = actions.file_edit },

		-- cmd = vim.fn.shellescape(table.concat(openBufferNames, '\n')) .. " | xargs bat" -- kind of works
		cmd = vim.fn.shellescape(table.concat(openBufferNames, '\n')) .. " | xargs rg  --fixed-strings --max-count 1 --column --line-number --no-heading --color=always --smart-case -- " .. arguments.args,
	})
end, {
	nargs = "*",
	desc = "Say hi to someone",
})


-- print(vim.inspect(bufList))

-- Rg: -> fzfLua grep _project
--https://github.com/ibhagwan/fzf-lua/issues/449
-- TODO: USE THIS for Rg: command completion
-- https://vi.stackexchange.com/questions/35139/custom-arguments-to-user-command

-- TODO: Try telescope for this?
-- map("n", "<Leader>t", "<cmd>lua require('fzf-lua').run()<CR>")

-- \   'source': 'rg --files --hidden --glob="!.git/*"',
-- \   'options': '--multi --exact --tiebreak=begin,length,index ' . ShowPreviewIfWideWindow(),
-- \   'window': { 'width': 1, 'height': 1 },

--
-- nnoremap <silent> <Leader>t :call fzf#run({
-- \   'source': 'rg --files --hidden --glob="!.git/*"',
-- \   'options': '--multi --exact --tiebreak=begin,length,index ' . ShowPreviewIfWideWindow(),
-- \   'window': { 'width': 1, 'height': 1 },
-- \   'sink': function('Dontopeninnerdtree')
-- \ })<CR>
--
-- " include node_modules
-- nnoremap <silent> <Leader>T :call fzf#run({
-- \   'options': '--exact --tiebreak=end,length ' . ShowPreviewIfWideWindow(),
-- \   'window': { 'width': 0.98, 'height': 0.98 },
-- \   'sink': function('Dontopeninnerdtree')
-- \ })<CR>
--
-- "  https://github.com/junegunn/fzf/issues/274 https://unix.stackexchange.com/questions/64736/combine-output-from-two-commands-in-bash
-- nnoremap <silent> <Leader>e :call fzf#run({
--  \'source': 'find ~/.vim/vimrc/* -type f; find ~/.vimrc; find ~/.dotfiles/_codesnippets/snippets/javascript.snippets; find ~/.config/fish/config.fish; find ~/.vim/after/plugin/* -type f; find ~/.config/karabiner.edn; find ~/.config/starship.toml; find ~/.dotfiles/makesymlinks.sh; find ~/.config/alacritty.yml; find ~/.byobu/.tmux.conf; find ~/.byobu/color.tmux; find ~/.byobu/keybindings.tmux',
-- \   'options': '--multi --exact --tiebreak=end,length ' . ShowPreviewIfWideWindow(),
-- \   '_hide_window': 1,
-- \   'sink': function('Dontopeninnerdtree')
-- \ })<CR>
--

-- vim.api.nvim_buf_set_keymap(
