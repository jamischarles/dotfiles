--------------------------
-- Command navigation like for buffers, etc using FZF
-- -----------------------
-- Libs to look at!!!
-- https://github.com/skywind3000/asyncrun.vim (async run shell cmd and pipe return to quickfix window
--
-- Try this for building my own commands in a floating window:
-- https://www.chrisdeluca.me/article/diy-neovim-fzy-search/
--

local map = require("utils").mapKey

-- lua filesystem lib

-- automagic toggling from/to test file
-- TODO: look into what gt does? I do want a faster way to do recall / jump between contexts... Tabs?
-- TODO: just make this my own plugin?

-- TODO: add some shared utils for getting path etc...

-- alternate
-- https://www.dev-log.me/Jump_between_test_files_and_implementation_in_Vim/
-- Lua hacky version of... vim-projectionist
function JumpToTestFileAndBack(opts)
  -- find current path
  -- does it include test file?
  -- if no, find the associated test file
  -- if yes, find the implementation file
  -- Q: Can I hook into the vitest config file to build a mapping of files when vim starts up in the project?
  local filename = vim.fn.expand("%:t")        -- filename only ie: process-logview.test.ts
  local fileNameNoExt = vim.fn.expand("%:t:r") -- filename only minus extension ie: process-logview

  local targetFile

  -- if includes .test.ts ext, then remove it, and find the same file name with .ts extension
  -- else find fileName.test.ts
  --
  --
  -- FIXME: Combine the first 2 conditions (if in test file)
  if string.find(filename, ".vitest.ts") then
    fileNameNoExt = string.gsub(filename, ".vitest.ts", "") -- need to manually remove because the vim pattern only removes the last .* ext
    -- could also use vim.fs.find() to locate the file
    targetFile = vim.fn.systemlist("fd " .. fileNameNoExt .. ".ts -1")[1]
  elseif string.find(filename, ".test.ts") then
    fileNameNoExt = string.gsub(filename, ".vitest.ts", "") -- need to manually remove because the vim pattern only removes the last .* ext
    -- could also use vim.fs.find() to locate the file
    targetFile = vim.fn.systemlist("fd " .. fileNameNoExt .. ".ts -1")[1]
  else
    targetFile = vim.fn.systemlist("fd " .. fileNameNoExt .. ".test.ts -1")[1]
  end

  -- open the file if it exists
  if targetFile then
    vim.api.nvim_command("edit " .. targetFile) -- TODO: make it relative to current file. Or use fd to find it or fzf or something
  end
  -- TODO: run this command and parse the result into the edit
  --
  --
  -- :!fd test.ts --type f
  -- ./lib/logview/__tests__/process-logview-row.test.ts
  -- ./lib/logview/__tests__/process-logview.test.ts
  -- ./tests/happy.test.ts

  -- TODO: hook into fd. Return first result and use that. YAS
end

map("n", "mt", "<cmd>lua JumpToTestFileAndBack('test')<CR>")

---------------------
-- Telescope for frecency
------------------
-- require("telescope").load_extension("frecency")
-- require("telescope").setup({
-- 	defaults = {
-- 		layout_config = {
-- 			horizontal = { height = 0.95, width = 0.9 },
-- 			vertical = { height = 0.9, width = 0.9 },
-- 			-- other layout configuration here
-- 		},
-- 		-- other defaults configuration here
-- 	},
-- 	-- other configuration values here
-- })

-----------------------------------------------------------------
-- NEEEEEEEEEEED a PRoject find symbols list generator (using TS)
-- https://github.com/eckon/treesitter-current-functions
---------------------

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

-- https://www.chrisdeluca.me/2022/01/12/diy-neovim-fzy.html
-- Pop open broot as our filefinder / nerdtree replacement
-- Full height and width
local brootExplorer = function()
  -- https://stackoverflow.com/questions/69050359/how-to-get-the-current-buffer-file-path-using-the-neovim-lua-api
  --vim.fn.expand('%:p:h') -- gets current working dir
  local currentFilePath = vim.fn.expand("%:p:h") -- gets current working dir

  local width = vim.o.columns * 2
  -- local width = vim.o.columns * 2
  local height = 61
  -- if (vim.o.columns >= 85) then
  --   width = 80 * 1.5
  -- end

  -- creating a new window is this easy?!?!?!
  vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
    relative = "editor",
    style = "minimal",
    border = "shadow",
    noautocmd = true,
    width = width,
    height = height,
    col = math.min((vim.o.columns - width) / 2),
    row = math.min((vim.o.lines - height) / 2 - 1),
  })

  -- temp file we have to create (that's how broot does it too)
  local file = vim.fn.tempname()

  vim.api.nvim_command("startinsert") -- avoids having to switch to insert mode in popup
  -- %:p:h -> get current file path so we can load focused there
  -- PRINT cmd
  local brootCmd = "/opt/homebrew/bin/broot -c ':preview_text;:focus' "
      .. currentFilePath
      .. " --no-trim-root --conf ~/.dotfiles/broot-nvim.conf.toml > " --outcmd is the path where we send the output to
      .. file
  --
  -- print("brootCmd", brootCmd);

  --
  vim.fn.termopen(
    brootCmd, -- open term with command above
    {
      on_exit = function()
        vim.api.nvim_command("bdelete!") -- automatically delete the terminal buffer
        --
        -- read the value from the temp file, then delete it
        local f = io.open(file, "r")
        local stdout = f:read("*all")
        f:close()
        os.remove(file)

        -- if we add this it opens the file in the popup window... Could be cool for manual preview...
        -- vim.api.nvim_command("bdelete!") -- automatically delete the terminal buffer

        vim.api.nvim_command("edit " .. stdout)
      end,
    }
  )
end

-- local nnnExplorer = function()
--   local width = vim.o.columns * 2
--   local height = 41
--   if (vim.o.columns >= 85) then
--     width = 80 * 1.5
--   end
--
--   -- creating a new window is this easy?!?!?!
--   vim.api.nvim_open_win(
--     vim.api.nvim_create_buf(false, true),
--     true,
--     {
--       relative = 'editor',
--       style = 'minimal',
--       border = 'shadow',
--       noautocmd = true,
--       width = width,
--       height = height,
--       col = math.min((vim.o.columns - width) / 2),
--       row = math.min((vim.o.lines - height) / 2 - 1),
--     }
--   )
--
--   -- temp file we have to create (that's how broot does it too)
--   local file = vim.fn.tempname()
--
--   vim.api.nvim_command('startinsert') -- avoids having to switch to insert mode in popup
--   -- %:p:h -> get current file path so we can load focused there
--   vim.fn.termopen('/opt/homebrew/bin/yazi > ' .. file, {
--     on_exit = function()
--       vim.api.nvim_command('bdelete!') -- automatically delete the terminal buffer
--       --
--       -- read the value from the temp file, then delete it
--       local f = io.open(file, 'r')
--       local stdout = f:read('*all')
--       f:close()
--       os.remove(file)
--       -- if we leave this as is, it opens the file in the popup window... Could be cool for manual preview...
--       vim.api.nvim_command('edit ' .. stdout)
--     end
--   })
-- end

-------------------------
-- MAPPINGS
-------------------------

-- DEFINITIONS for fzf lua are in the  FZF-LUA section!!!
-- That's where we define how these sections behave...

-- vim.api.nvim_create_user_command('FzfBuffersWithDeleteAction', fzf_buffersWithDelete,  { nargs = 0 })

-- map("n", "<Leader>b", ":FzfBuffersWithDeleteAction<CR>")
map("n", "<Leader>t", ":FzfLua files<CR>")                                             -- see config above for this
-- FIXME not working
map("n", "<Leader>T", "<cmd>lua require('fzf-lua').files({cmd='fd --no-ignore'})<CR>") -- all files & folders
-- map("n", "<Leader>g", ":FzfLua git_status<CR>")

-- map("n", "<Leader>b", ":FzfLua buffers<CR>") -- could we sort this by frecency? interesting!!!

-- map("n", "<Leader>b", ":FzfLua buffers<CR>") -- could we sort this by frecency? interesting!!! -- behavior for this defined in fzf-lua config section...
-- ^ see telescope section TODO: move it up here?

-- map("n", "<Leader>m", ":Telescope frecency<CR>") -- uses my custom frecency usin `fre` (see above)
map("n", "<Leader>m", ":FzfLua oldfiles<CR>") -- uses my custom frecency usin `fre` (see above)

-- To add nvim treesitter like menu options: https://github.com/kyazdani42/nvim-tree.lua/pull/1162
-- For now maybe we can just commands on it... g? for keys
-- f filter
-- . run command
vim.api.nvim_create_user_command("Broot", brootExplorer, { nargs = 0 })
-- vim.api.nvim_create_user_command('NNN', nnnExplorer, { nargs = 0 })
-- map("n", "<Leader>N", ":NnnPicker %:p:h<CR>") -- all files & folders
map("n", "<Leader>n", ":Broot <CR>") -- all files & folders
map("n", "<Leader>N", ":Yazi <CR>")  -- all files & folders (in iterm need to hold shift AFTER space)

-- disable netrw so yazi doesn't open in it
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_netrw = 1

-- map("n", "<Leader-S>N", ":Yazi <CR>") -- all files & folders

-- map("n", "<Leader>n", ":NvimTreeToggle<CR>")
-- map("n", "<C-F>", ":NvimTreeFindFile<CR>") -- uses my custom frecency usin `fre` (see above)

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

-- Custom commands!!! -- TODO: Include broot?
map("n", "<Leader>e", ":FzfLua files cwd=~/.dotfiles/nvim<CR>") -- change folder for files() lookup

local getOpenBufferList = function()
  local bufferFileNames = {}
  for _, bufNum in ipairs(vim.api.nvim_list_bufs()) do
    -- map[b] = true
    -- if vim.fn.buflisted(bufNum) then
    local isListed = unpack(vim.fn.getbufinfo(bufNum))["listed"] -- weird way of getting open buffers
    if isListed == 1 then
      -- table.insert(bufferFileNames, vim.api.nvim_buf_get_name(bufNum))
      table.insert(bufferFileNames, vim.api.nvim_buf_get_name(bufNum))
    end
  end
  return bufferFileNames
end

local function create_rg_search_commands(actions)
  -- vim.api.nvim_create_user_command('Rg', fzf_buffersWithDelete,  { nargs = 1 })
  vim.api.nvim_create_user_command("Rg", function(arguments)
    require("fzf-lua").files({
      actions = { ["default"] = actions.file_edit },
      cmd =
          "rg  --fixed-strings --max-count 5 --column --line-number --no-heading --color=always --smart-case --iglob !locales -- "
          .. arguments.args,
    }) --ignores locales/*
    -- cmd = "rg  --fixed-strings --max-count 1 --column --line-number --no-heading --color=always --smart-case --iglob !locales -- " .. arguments.args,

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
      cmd =
          "rg  --fixed-strings --max-count 1 --column --line-number --no-heading --color=always --no-ignore --ignore-case -- "
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

      cmd =
          "git status --porcelain | sed s/^...// | xargs rg  --fixed-strings --max-count 1 --column --line-number --no-heading --color=always --smart-case --iglob !locales -- "
          .. arguments.args,
    })
  end, {
    nargs = "*",
    desc = "Say hi to someone",
  })

  -- search only across open buffers
  vim.api.nvim_create_user_command("Rgb", function(arguments)
    local openBufferNames = getOpenBufferList()
    -- could just use fzf-lua lines (pretty cool!)
    require("fzf-lua").files({
      actions = { ["default"] = actions.file_edit },

      -- cmd = vim.fn.shellescape(table.concat(openBufferNames, '\n')) .. " | xargs bat" -- kind of works
      cmd = vim.fn.shellescape(table.concat(openBufferNames, "\n"))
          .. " | xargs rg  --fixed-strings --max-count 1 --column --line-number --no-heading --color=always --smart-case -- "
          .. arguments.args,
    })
  end, {
    nargs = "*",
    desc = "Say hi to someone",
  })
end

-- print(vim.inspect(getOpenBufferList()))
-- print(vim.fn.shellescape(table.concat(getOpenBufferList(), '\n')))

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

return {
  name = "command-navigation",
  dependencies = {
    {
      "ibhagwan/fzf-lua",
      -- optional for icon support
      dependencies = { "kyazdani42/nvim-web-devicons" },
    },
    {
      "nvim-telescope/telescope.nvim",
      -- "nvim-telescope/telescope.nvim", branch = '0.1.x',
      dependencies = { { "nvim-lua/plenary.nvim" } },
    },

    { "axkirillov/easypick.nvim", dependencies = { "nvim-telescope/telescope.nvim" } },

    {
      "aaronhallaert/advanced-git-search.nvim",
      config = function()
        -- optional: setup telescope before loading the extension
        -- require("telescope").setup {
        --   -- move this to the place where you call the telescope setup function
        --   extensions = {
        --     advanced_git_search = {
        --       -- See Config
        --     }
        --   }
        -- }

        require("telescope").load_extension("advanced_git_search")
      end,
      dependencies = {
        --- See dependencies
      },
    },

    {
      "DreamMaoMao/yazi.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
      },

      -- keys = {
      --   { "<leader>N", "<cmd>Yazi<CR>", desc = "Toggle Yazi" },
      -- },
    },

    -----------------
    -- Custom telescope pickers I made...
    -----------------
    {
      "telescope-ctrl-t", -- my own
      dir = "~/.dotfiles/nvim/lua/telescope-ctrl-t.lua",
      config = function()
        require("telescope-ctrl-t").init()
      end,
      dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- optional, for file icons
      },
      -- do I need to call .setup()?
    },

    -- nnn instead of nerdtree...
    -- TODO: try again if my custom setup doesn't work
    -- { 'mcchrish/nnn.vim' },

    -- {
    -- 	"nvim-telescope/telescope-frecency.nvim",
    -- 	config = function()
    -- 		require("telescope").load_extension("frecency")
    -- 	end,
    -- 	dependencies = { "tami5/sqlite.lua" },
    -- },
    --

    -----------------
    -- Open urls in browser with gx
    ---------------
    --
    {
      "chrishrb/gx.nvim",
      config = function()
        require("gx").setup({
          open_browser_app = "open", -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
          -- open_browser_args = { "--background" }, -- specify any arguments, such as --background for macOS' "open".
          open_browser_args = {},    -- specify any arguments, such as --background for macOS' "open".
          handlers = {
            plugin = true,           -- open plugin links in lua (e.g. packer, lazy, ..)
            github = true,           -- open github issues
            brewfile = true,         -- open Homebrew formulaes and casks
            package_json = true,     -- open dependencies from package.json
            search = true,           -- search the web/selection on the web if nothing else is found
          },
          handler_options = {
            search_engine = "google",                             -- you can select between google, bing, duckduckgo, and ecosia
            search_engine = "https://search.brave.com/search?q=", -- or you can pass in a custom search engine
          },
        })
      end,
    },

    ----------------------
    -- Jumping around files quickly & easily
    -- ----------------
    --
    -- { "ThePrimeagen/harpoon", dependencies = { "nvim-lua/plenary.nvim" } },

    {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- PORTAL looks cool. TODO: try it more / again...
    { "cbochs/portal.nvim",       dependencies = { "ThePrimeagen/harpoon" } },

    -- REMOVE
    {
      "toppair/reach.nvim",
      config = function()
        require("reach").setup({
          notifications = true,
        })
      end,
    },

    {
      "chentoast/marks.nvim",
      config = function()
        require("marks").setup({})
      end,
    },

    --------------------------
    --FILE navigation / exploration
    ------------------------------
    -- {
    -- 	"stevearc/oil.nvim",
    -- 	config = function()
    -- 		require("oil").setup()
    -- 	end,
    -- },

    --- if I don't like yazi, try this or fzf + broot
    -- https://gist.github.com/Canop/9baee3bd8fe9fe904817572e94f99a32?permalink_comment_id=3789225#gistcomment-3789225
    --
    --

    -- trying floating nav window with broot or yazi...
    --https://github.com/MunifTanjim/nui.nvim try this with broot?
    {
      "DreamMaoMao/yazi.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
      },

      -- trying broot instead
      -- Building my own floating window implementation for broot (didn't find a good plugin for it in nvim...)
      -- https://github.com/Canop/broot/issues/293
      -- https://www.chrisdeluca.me/2022/01/12/diy-neovim-fzy.html
      --
      --
      --
      -- keys = {
      --   { "<leader>n", "<cmd>Yazi<CR>", desc = "Toggle Yazi" },
      -- },
    },

    -- {
    -- 	"kyazdani42/nvim-tree.lua",
    -- 	dependencies = {
    -- 		"kyazdani42/nvim-web-devicons", -- optional, for file icons
    -- 	},
    --
    -- 	-- marks and other useful nav?
    -- 	-- tag = "nightly", -- optional, updated every week. (see issue #1193)
    -- },
  },

  -- fixme: is this a good pattern? Or should we group it in the deps list?
  config = function()
    -- map gx  - to open in browser -- FIXME: move somewhere else?
    map("n", "gx", ":Browse<cr>") -- change folder for files() lookup

    ----------------------
    -- Telescope
    -- ---------------------
    local builtin = require("telescope.builtin")
    require("telescope").setup({
      defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        -- https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#default-mappings
        mappings = {
          i = { -- for the prompt
            -- map actions.which_key to <C-h> (default: <C-/>)
            -- actions.which_key shows the mappings for your picker,
            -- e.g. git_{create, delete, ...}_branch for the git_branches picker
            -- ["<C-h>"] = "which_key"
            --
            -- ["<BS>"] = "<C-h>", -- Fixed the backspace issue in ~/.dotfiles/keymap_reset_colemak.lua

            -- preview scroll up-down
            ["<c-e>"] = require("telescope.actions").preview_scrolling_up,
            ["<c-n>"] = require("telescope.actions").preview_scrolling_down,

            -- https://www.reddit.com/r/neovim/comments/pzxw8h/telescope_quit_on_first_single_esc/
            -- before this, esc goes to normal mode. So you have to esc 2x to close modal. This removes the 2nd esc needed
            ["<esc>"] = require("telescope.actions").close,
          },
        },
      },
      pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        builtin.treesitter,
        -- builtin picker
      },
      extensions = {
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure
      },
    })

    local builtin = require("telescope.builtin")
    -- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    -- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    -- https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#layout-display
    -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/pickers/layout_strategies.lua
    -- :help telescope.layout
    -- vim.keymap.set('n', '<leader>b', function() builtin.buffers({layout_strategy='vertical',layout_config={width=0.7, mirror=true, preview_cutoff=70 }})  end, {})
    -- vim.keymap.set("n", "<leader>b", function()
    --   builtin.buffers({ layout_strategy = "vertical", layout_config = { width = 0.7, mirror = true } })
    -- end, {})

    vim.keymap.set("n", "<leader>ff", function()
      builtin.git_status({ layout_strategy = "vertical", layout_config = { width = 0.7, mirror = true } })
    end, {})

    vim.keymap.set("n", "<leader>b", function()
      -- builtin.buffers({ layout_strategy = "vertical", layout_config = { width = 0.7, mirror = true } })
      builtin.buffers({
        layout_strategy = "vertical",
        layout_config = { width = 0.7, mirror = true },
        -- FIXME: weird structure to that plugin...
        -- making entries for the list?
        entry_maker = require("telescope-ctrl-t").init().gen_from_buffer_like_leaderf(),
        -- entry_maker = require "vimrc.telescope.my_make_entry".gen_from_buffer_like_leaderf(),
      })
    end, {})

    vim.keymap.set("n", "<leader>g", function()
      builtin.git_status({
        layout_strategy = "horizontal",
        layout_config = { preview_width = 0.6, height = 0.95, width = 0.95, mirror = false },
        -- dynamic_preview_title = true,
        -- FIXME: weird structure to that plugin...
        -- making entries for the list?

        -- TODO: Make my own like leader-f that I made
        -- entry_maker = require("telescope-ctrl-t").init().gen_from_buffer_like_leaderf(),
      })
    end, {})

    -- nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>

    ---------------------
    -- custom telescope pickers from command line commands using easypick
    ---------------------
    require("easypick").setup({
      -- diff current branch with base_branch and show files that changed with respective diffs in preview
      pickers = {
        {
          name = "gitStatus",
          command = "git status --porcelain",
          previewer = require("easypick").previewers.branch_diff({ base_branch = "develop" }),
        },
        {
          name = "changed_files",
          command = "git diff --name-only $(git merge-base HEAD develop )",
          previewer = require("easypick").previewers.branch_diff({ base_branch = "develop" }),
        },
      },
    })

    -- last param is args for vim.keymap.set NOT for builtin.buffers

    -- https://github.com/nvim-tree/nvim-tree.lua#custom-mappings
    -- local function my_on_attach(bufnr)
    --   local api = require "nvim-tree.api"
    --
    --   local function opts(desc)
    --     return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    --   end
    --
    --   -- default mappings
    --   api.config.mappings.default_on_attach(bufnr)
    --
    --   -- custom mappings
    --   vim.keymap.set('n', 'u', api.tree.change_root_to_parent,        opts('folder up'))
    --   vim.keymap.set('n', 'e', '<UP>',        opts('arrow-Up')) -- override the rename keymapping
    --   vim.keymap.set('n', 'E', api.node.navigate.sibling.prev,        opts('arrow-Up')) -- override the rename keymapping
    --   vim.keymap.set('n', 'N', api.node.navigate.sibling.next,        opts('arrow-Up')) -- override the rename keymapping
    --
    --   -- vim.keymap.set("n", "e", "<nop>", {}) -- NOT WORKING?!?!
    --   -- vim.keymap.set("n", "k", "<nop>", {})
    --   -- vim.keymap.set('n', 'e')
    -- end
    -- file explorer
    -- try this https://github.com/stevearc/oil.nvim (buffer based file editing. INTERESTING)
    -- consider just putting this in .opts for the nvim-tree dep above
    -- require("nvim-tree").setup({
    -- 	filters = { custom = { "^.git$" } },
    --                       on_attach = my_on_attach,
    -- 	view = {
    -- 		adaptive_size = true,
    -- 		-- mappings = {
    -- 		-- 	list = {
    -- 		-- 		{ key = "u", action = "dir_up" },
    -- 		-- 		{ key = "e", action = "" }, -- remove the `e` mapping so my mappings kick in (move up)
    -- 		-- 	},
    -- 		-- },
    -- 	},
    -- })

    -- make this a global for the command
    harpoon = require("harpoon")
    harpoon:setup()

    -- use telescope for harpoon
    local conf = require("telescope.config").values

    local function toggle_telescope(harpoon_files, layout_conf)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        -- TODO: format the file paths here...
        table.insert(file_paths, item.value)
      end

      -- writing your own telescope picker... https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md
      -- look at this for more complex lua utils like merging tables https://github.com/lunarmodules/Penlight
      -- https://github.com/axkirillov/easypick.nvim
      require("telescope.pickers")
          .new(layout_conf, { -- pass in config like layout
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
    end

    -- commands based on harpoon
    --
    vim.api.nvim_create_user_command("HarpoonTerm", "lua require('harpoon.term').gotoTerminal(1)", {})

    vim.api.nvim_create_user_command("HarpoonAddFile", "lua harpoon:list():append()", {})
    vim.api.nvim_create_user_command("HarpoonRemoveFile", "lua harpoon:list():remove()", {})
    vim.api.nvim_create_user_command("HarpoonToggle", "lua harpoon.ui:toggle_quick_menu(harpoon:list())", {})
    vim.api.nvim_create_user_command("HarpoonNext", "lua harpoon:list():next()", {})
    vim.api.nvim_create_user_command("HarpoonPrev", "lua harpoon:list():prev()", {})
    --
    vim.keymap.set("n", "<c-1>", function()
      harpoon:list():select(1)
    end)
    vim.keymap.set("n", "<c-2>", function()
      harpoon:list():select(2)
    end)
    -- vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end)
    -- vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end)
    -- vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
    -- vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

    -- map("n", "<leader>ht", "<cmd>HarpoonToggle<CR>")
    -- map("n", "<leader>hh", "<cmd>HarpoonToggle<CR>")
    map("n", "<c-a>", ":HarpoonAddFile<CR>")
    map("n", "<c-r>", ":HarpoonRemoveFile<CR>")

    -- vim.keymap.set("n", "<leader>hh", function() toggle_telescope(harpoon:list({layout_strategy='vertical',layout_config={width=0.7, mirror=true}})) end,
    vim.keymap.set("n", "<leader>h", function()
      toggle_telescope(harpoon:list(), {
        -- same as one below
        layout_strategy = "horizontal",
        layout_config = {
          mirror = false,
          height = 0.999999,
          width = 0.999999, --[[ preview_cutoff = 0.3 ]]
          preview_width = 0.65,
          prompt_position = "top",
          anchor = "NE",
        },
        sorting_strategy = "ascending", -- results in TOP of window, not bottom
      })
    end, { desc = "Open harpoon window" })

    vim.keymap.set("n", "<-c-h>", function()
      toggle_telescope(harpoon:list(), {
        layout_strategy = "horizontal",
        -- < 1 makes it % based. > 1 makes it fixed column based
        -- preview cutoff = disable preview at less than that width
        layout_config = {
          mirror = false,
          height = 0.999999,
          width = 0.999999, --[[ preview_cutoff = 0.3 ]]
          preview_width = 0.65,
          prompt_position = "top",
          anchor = "NE",
        },
        sorting_strategy = "ascending", -- results in TOP of window, not bottom
        -- TODO: Make another one that's just a path formatter and pass that one in?
        -- entry_maker = require "telescope-ctrl-t".init().gen_from_buffer_like_leaderf(),
        -- path_display = { "truncate", "tail" },
      })
    end, { desc = "Open harpoon window" })

    map("n", "<C-n>", ":HarpoonNext<CR>") -- jump to next TODO: maybe make this c-h?
    map("n", "<C-e>", ":HarpoonPrev<CR>") --

    -- map("n", "<C-S-N>", ":HarpoonPrev<CR>") -- jump to next TODO: maybe make this c-h?
    -- WORKS ^ if you send the proper escape code from the terminal see my TIL on this...

    -- map("n", "<C-N>", ":HarpoonPrev<CR>") -- jump to next TODO: maybe make this c-h?

    -- TODO: make a til for this...
    -- hard problem. C + Shift is pretty much ignored in most places. You can use alt, or use remapping magic with like karabiner...

    -- map("n", "<C-N>", ":HarpoonPrev<CR>") -- jump to next TODO: maybe make this c-h?
    -- ^ SHIFT notation

    -- ADD: leader H ? for append?

    -- quickly add?
    -- consider leader n for toggle...

    -- buggy with new neovim. disabling for now
    -- vim.keymap.set("n", "<c-o>", require("portal").jump_backward, {})
    -- vim.keymap.set("n", "<c-i>", require("portal").jump_forward, {})

    -----------------
    -- FZF-LUA
    -- TODO: consider trying skim instead of fzf. We can just swap it out here. fzf-lua supports both...
    --
    -- ---------------
    local actions = require("fzf-lua.actions")
    local utils = require("fzf-lua.utils")
    local enterKey = utils.ansi_codes.yellow("<Return>")
    local delBuffer = utils.ansi_codes.yellow("<Ctrl-X>")
    require("fzf-lua").setup({
      "telescope",                          -- look and feel from profile...
      keymap = {
        ["<ctrl-a>"] = "preview-page-down", -- navigate preview up/down
        ["<c-a>"] = "preview-page-down",    -- navigate preview up/down
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
        width = 0.95,  -- window width
        row = 0.50,    -- window row position (0=top, 1=bottom)
        col = 0.50,
        fullscreen = true,

        border = false,
        preview = {
          scrollbar = "float",
          layout = "horizontal",
          horizontal = "right:55%",
        },
        -- preview = {
        -- 	scrollbar = "float",
        -- 	layout = "vertical",
        -- 	vertical = "up:75%",
        -- },
      },
      -- provider setup
      files = {
        -- previewer      = "bat",          -- uncomment to override previewer
        -- (name from 'previewers' table)
        -- set to 'false' to disable
        prompt = "Files❯ ",
        multiprocess = true, -- run command in a separate process
        git_icons = false,   -- show git icons? -- TOO slow
        file_icons = true,   -- show file icons?

        -- doesn't work?
        -- winopts = {
        --     fullscreen = false,
        --   preview = {
        --     -- flip to hor split after it's this many chars wide...
        --     layout         = 'flex',
        --     flip_columns   = 20,
        --
        --   }
        -- },

        -- color_icons = true, -- colorize file|git icons
        -- path_shorten   = 1,              -- 'true' or number, shorten path?
        -- executed command priority is 'cmd' (if exists)
        -- otherwise auto-detect prioritizes `fd`:`rg`:`find`
        -- default options are controlled by 'fd|rg|find|_opts'
        -- NOTE: 'find -printf' requires GNU find
        --https://github.com/sharkdp/fd/issues/789 SORT
        -- sort by recently openened/modified? Files only. include hidden files, but remove locales and java tests and .git
        cmd =
        "fd --color=never --type f --hidden --follow --exclude .git --exclude locales --exclude dist --exclude tests/functional -X ls -tu", -- -tu vs -tc?
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

          -- https://github.com/ibhagwan/fzf-lua/issues/814#issuecomment-1631061166
          -- Tell fzf not to pass the buff nr etc... and all the buffer cruft
          ["--delimiter"] = "' '",   -- split by string
          -- ["--with-nth"]="-2,1,4.." -- keep these, 1, 3, rest
          ["--with-nth"] = "-1,5..", -- keep these, 1, 3, rest
        },

        file_icons = true, -- show file icons?

        -- https://github.com/ibhagwan/fzf-lua/wiki/Advanced#example-1-live-ripgrep
        fn_transform = function(x)
          -- return "hello"
          --
          -- return "hiiii " .. x .. "hiii"

          -- TODO: use plenary to add the file name
          -- If this casuses issues, just create my own
          -- use the same technique as the one for broot...
          -- FIXME: this may be goog enough with the changes above to with-nth, but maybe just manually split by " " and
          -- Or just build it custom myself (might be easier...)
          return require("fzf-lua").make_entry.file(
            x,
            { --[[ file_icons=true, filename_only=true, color_icons=true, ]]
              path_shorten = true,
              __prefix = "hi",
            }
          )
          -- local t =  require'fzf-lua'.make_entry.file("hello " .. x, {file_icons=true, filename_only=true, color_icons=true, path_shorten=true, __prefix="hi"})
          -- print(t)
          -- return "hi " .. t
          -- print(x)
          -- return fzf_lua.make_entry.file(x, opts)
        end,

        -- previewer = "builtin" ,
        -- previewer = false , -- to turn off
        winopts = {

          -- REALLY slick. Try this split out...
          -- split         = "aboveleft vnew",-- open in a split instead?

          -- "belowright new"  : split below
          -- "aboveleft new"   : split above
          -- "belowright vnew" : split right
          -- "aboveleft vnew   : split left
          -- Only valid when using a float window
          -- (i.e. when 'split' is not defined, default)
          height = 0.97, -- window height
          width = 0.75,  -- window width
          row = 0.70,    -- window row position (0=top, 1=bottom)
          col = 0.50,
          fullscreen = false,

          border = true,
          -- preview = {
          -- 	scrollbar = "float",
          -- 	layout = "horizontal",
          -- 	horizontal = "right:55%",
          -- },

          preview = {
            scrollbar = "float",
            layout = "vertical",
            vertical = "down:65%",
          },
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

    create_rg_search_commands(require("fzf-lua.actions"))

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
  end,
}
-- vim.api.nvim_buf_set_keymap(
