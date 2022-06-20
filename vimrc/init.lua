-- print('hello');
-- edu: https://github.com/nanotee/nvim-lua-guide
--
--https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
--https://www.notonlycode.org/neovim-lua-config/
--
-- READING ----------------------------------
-- https://github.com/nanotee/nvim-lua-guide
-- https://luabyexample.org/docs/nvim-autocmd/
--
--
--TIL:
--Try out lua commands
-- :lua print(vim.bo.filetype)
--
--
-- Functional wrapper for mapping custom keybindings
-- https://blog.devgenius.io/create-custom-keymaps-in-neovim-with-lua-d1167de0f2c2
-- Frontload mappings so other errors don't cause these mappings to break
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end




-- send keys to vim
local feedkeys = function(keys)
  vim.api.nvim_feedkeys(
  vim.api.nvim_replace_termcodes(keys, true, true, true),
  'i',
  false
  )
end

-- handle backspace in telescope vs other environments
-- create a global command
vim.api.nvim_create_user_command(
    'HandleBackspace',
    function()


      -- if buffertype is NOT telescropPrompt, exit insert mode
      if vim.bo.filetype ~= "TelescopePrompt" then
        vim.cmd('stopinsert')
      else
        feedkeys("<C-H>") -- in Vim, Ctrl+h is mapped to backspace
      end
    end,
    { nargs = 0 }
)


-- map backspace/del to esc and marks
map("i", "<BS>", "<cmd>:HandleBackspace<CR>")
map("x", "<BS>", "<ESC>")
-- map BS to marks in normal mode
map("n", "<BS>", "`")
map("n", "<BS><BS>", "`'")
--
--


require('formatter').setup({
  logging = false,
  filetype = {
    javascript = {
        -- prettierd
       function()
          return {
            exe = "prettierd",
            args = {vim.api.nvim_buf_get_name(0)},
            stdin = true
          }
        end
    },
    json = {
       function()
          return {
            exe = "prettierd",
            args = {vim.api.nvim_buf_get_name(0)},
            stdin = true
          }
        end
    },
    css = {
       function()
          return {
            exe = "prettierd",
            args = {vim.api.nvim_buf_get_name(0)},
            stdin = true
          }
        end
    },
    -- other formatters ...
  }
})


-- syntax & editor sugar
require("nvim-autopairs").setup {
  map_bs = false
}

-- indent guide
require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = true,
}

require"telescope".load_extension("frecency");
-- require('telescope').load_extension('fzy_native')


-- TODO: try this, but can we just pipe fzf to telescope?
-- Or use both?
-- https://github.com/ibhagwan/fzf-lua

-- File finding like fzf
require'telescope'.setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    frecency = {
      db_root = "~/db_root",
      show_scores = false,
      show_unindexed = true,
      ignore_patterns = {"*.git/*", "*/tmp/*"},
      disable_devicons = false,
      workspaces = {
        ["conf"]    = "~/.dotfiles",
        ["data"]    = "~/home/my_username/.local/share",
        ["project"] = "~/dev",
        ["wiki"]    = "~/my_username/wiki"
      }
    }
  },
}

require('telescope').load_extension('fzf')

-----------------
-- FZF-LUA
-- ---------------
local actions = require "fzf-lua.actions"
local utils = require "fzf-lua.utils"
local enterKey = utils.ansi_codes.yellow("<Return>")
local delBuffer = utils.ansi_codes.yellow("<Ctrl-X>")
require'fzf-lua'.setup {
  keymap = {
    ["<ctrl-a>"]    = "preview-page-down", -- navigate preview up/down
    ["<c-a>"]    = "preview-page-down", -- navigate preview up/down
    ["<C-e>"]      = "preview-page-up",
    ["<F7>"]        = "toggle-preview",
    -- Rotate preview clockwise/counter-clockwise
    ["<F5>"]        = "toggle-preview-ccw",
    ["<F6>"]        = "toggle-preview-cw",
    ["<S-down>"]    = "preview-page-down",
    ["<S-up>"]      = "preview-page-up",
      ["<S-left>"]    = "preview-page-reset",
  },
  winopts = {
    -- split         = "belowright new",-- open in a split instead?
    -- "belowright new"  : split below
    -- "aboveleft new"   : split above
    -- "belowright vnew" : split right
    -- "aboveleft vnew   : split left
    -- Only valid when using a float window
    -- (i.e. when 'split' is not defined, default)
    height           = 0.98,            -- window height
    width            = 0.95,            -- window width
    row              = 0.50,            -- window row position (0=top, 1=bottom)
    col              = 0.50,
    fullscreen = false,

    preview = {
      scrollbar      = 'float',
      layout = 'vertical',
      vertical = 'up:80%'
    }
  },
  git = {
    status = {
      cmd = "git status --porcelain" -- needed to not break the ansi formatting. Q: should this be default?
    }
  },
  buffers = {
    fzf_opts = {
      ['--header'] = vim.fn.shellescape(('%s to close buffer, %s to open'):format(delBuffer, enterKey))    }
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
    ["default"]     = actions.buf_edit,
    ["ctrl-s"]      = actions.preview_page_down,
    ["c-s"]      = actions.preview_page_down
  }
}
}


  local fzf_lua = require("fzf-lua")


  -- https://github.com/ibhagwan/fzf-lua/issues/196
  -- Allow delete action from the buffer window
  local function fzf_buffersWithDelete(opts)
    if not opts then opts = {} end
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
    opts.fzf_cli_args  = ("--bind=ctrl-x:execute-silent:%s"):format(action)
    fzf_lua.buffers(opts)
  end


  -- vim.api.nvim_create_user_command('FzfBuffersWithDeleteAction', fzf_buffersWithDelete,  { nargs = 0 })

  -- map("n", "<Leader>b", ":FzfBuffersWithDeleteAction<CR>")
  map("n", "<Leader>b", ":FzfLua buffers<CR>")
-- nnoremap <silent> <Leader>b :FzfLua buffers<CR>

-- vim.api.nvim_buf_set_keymap(
--   0,
--   'i',
--   '<Bs>',
--   '<cmd>lua PromptBackspace()<CR>',
--   {noremap = true}
-- )


-- " REMAP CAPS to BACKTICK key ` for normal mode, ESC for other modes
-- nnoremap <BS> `
-- nnoremap <BS><BS> `'| " use `` for jump back
-- inoremap <BS> <ESC>
-- xnoremap <BS> <ESC>





-- autocmd BufEnter * if &buftype != "nofile" | lua require'completion'.on_attach()


-- :startinsert/:stopinsert/vim.cmd('startinsert')

-- Lua function
local myluafun = function()
    print("This buffer enters")
  -- if vim.bo.filetype == "TelescopePrompt" then
  -- i don't want it for the buffer? unless it is a stpecific buffer type...
  vim.api.nvim_set_keymap("i", "<BS>", "<BS>")
    print("This buffer enters")
  -- else
    print("This buffer enters NOT")
  -- end


end


  -- vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  --   -- pattern = {"*.c", "*.h"},
  --   callback = myluafun,
  -- })

-- https://luabyexample.org/docs/nvim-autocmd/
-- vim.api.nvim_create_autocmd("FileType", {
--     -- group = "bufcheck",
--     pattern = { "TelescopePrompt"},
--     callback = myluafun,
-- })
--
-- vim.api.nvim_create_autocmd("User", {
--     -- group = "bufcheck",
--     pattern = { "TelescopePreviewerLoaded"},
--     callback = myluafun,
-- })

-- autocmd User TelescopePreviewerLoaded setlocal wrap


-- GIT features
require('gitsigns').setup()
map('n', '<leader>h', ':Gitsigns setqflist<CR>')
map('n', '<leader>p', ':Gitsigns preview_hunk<CR>')
map('n', '<leader>r', ':Gitsigns reset_hunk<CR>')
map('n', '[h', ':Gitsigns next_hunk<CR>')
map('n', ']h', ':Gitsigns prev_hunk<CR>')



-- BUFFER managment. TODO: Move to a buffer.lua file?
vim.opt.termguicolors = true
-- require('bufferline').setup {}
require('bufferline').setup {
  options = {
    mode = "buffers", -- set to "tabs" to only show tabpages instead
    numbers = "buffer_id", -- | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
      close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
      right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
      left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
      middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
      -- NOTE: this plugin is designed with this icon in mind,
      -- and so changing this is NOT recommended, this is intended
      -- as an escape hatch for people who cannot bear it for whatever reason
      indicator_icon = '▎',
      buffer_close_icon = '',
      modified_icon = '●',
      close_icon = '',
      left_trunc_marker = '',
      right_trunc_marker = '',
      --- name_formatter can be used to change the buffer's label in the bufferline.
      --- Please note some names can/will break the
      --- bufferline so use this at your discretion knowing that it has
      --- some limitations that will *NOT* be fixed.
      name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
        -- remove extension from markdown files for example
        if buf.name:match('%.md') then
          return vim.fn.fnamemodify(buf.name, ':t:r')
        end
      end,
      max_name_length = 24,
      max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
      tab_size = 18,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = true,
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        -- return "("..count.."):"..level..""
        local icon = level:match("error") and " " or ""
        return " " .. icon .. count
        -- local icon = level:match("error") and " " or " "
      end,
      -- NOTE: this will be called a lot so don't do any heavy processing here
      custom_filter = function(buf_number, buf_numbers)
        -- filter out filetypes you don't want to see
        if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
          return true
        end
        -- filter out by buffer name
        if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
          return true
        end
        -- filter out based on arbitrary rules
        -- e.g. filter out vim wiki buffer from tabline in your work repo
        if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
          return true
        end
        -- filter out by it's index number in list (don't show first buffer)
        if buf_numbers[1] ~= buf_number then
          return true
        end
      end,
      -- offsets = {{filetype = "NvimTree", text = "File Explorer" | function , text_align = "left" | "center" | "right"}},
      color_icons = true, -- whether or not to add the filetype icon highlights
      show_buffer_icons = true, -- disable filetype icons for buffers
      show_buffer_close_icons = false,
      show_buffer_default_icon = true, -- whether or not an unrecognised filetype should show a default icon
      show_close_icon = false,
      show_tab_indicators = false,
      persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
      -- can also be a table containing 2 custom separators
      -- [focused and unfocused]. eg: { '|', '|' }
      -- separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
      -- enforce_regular_tabs = false | true,
      always_show_bufferline = true,
      custom_areas = {
        -- Please note that this function will be called a lot and should be as inexpensive as possible so it does not block rendering the tabline.
        right = function()
          local result = {}
          local seve = vim.diagnostic.severity
          local error = #vim.diagnostic.get(0, {severity = seve.ERROR})
          local warning = #vim.diagnostic.get(0, {severity = seve.WARN})
          local info = #vim.diagnostic.get(0, {severity = seve.INFO})
          local hint = #vim.diagnostic.get(0, {severity = seve.HINT})

          if error ~= 0 then
            table.insert(result, {text = "  " .. error, guifg = "#EC5241"})
          end

          if warning ~= 0 then
            table.insert(result, {text = "  " .. warning, guifg = "#EFB839"})
          end

          if hint ~= 0 then
            table.insert(result, {text = "  " .. hint, guifg = "#A3BA5E"})
          end

          if info ~= 0 then
            table.insert(result, {text = "  " .. info, guifg = "#7EA9A7"})
          end
          return result
        end,
      }
      -- sort_by = 'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
        -- add custom logic
        -- return buffer_a.modified > buffer_b.modified
      -- end
    }
  }


map("n", "<tab>", ":BufferLineCycleNext<CR>")
map("n", "<S-tab>", ":BufferLineCyclePrev<CR>")
map("n", "<leader><leader>", ":edit #<CR>") -- go to last open buffer
-- " nnoremap <leader><leader> <C-^>| " Goto last buffer
-- map("n", "<leader>q", ":CloseCurrentBufferOrWindow<CR>")
map("n", "<leader>q", ":bdelete<CR>")
map("n", "<leader>o", ":only<CR>") -- Close all other windows



-- FIXME: Organize this differently?
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "javascript", "lua", "typescript" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}


require("toggleterm").setup{}

-- -------------------------
-- LSP config & tooling
-- https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c
-- ----------------------------
-- require("null-ls").setup({
--   sources = {
--     require("null-ls").builtins.formatting.stylua,
--     require("null-ls").builtins.diagnostics.eslint,
--     require("null-ls").builtins.completion.spell,
--   },
-- })

-- TODO: use lua version
-- vim.api.nvim_set_option('signcolumn', "yes")
-- print(vim.api.nvim_get_option('signcolumn'))

local lspconfig = require("lspconfig")

local buf_map = function(bufnr, mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
        silent = true,
    })
end


-- onattach callback
-- This callback runs whenever a language server attaches to a buffer and is used to set up commands, keybindings, and other buffer-local options
-- No hoisting in lua?
local on_attach = function(client, bufnr)
  vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
  vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
  vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
  vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
  vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
  vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
  vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
  vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
  vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
  vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
  vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
  vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
  buf_map(bufnr, "n", "gd", ":LspDef<CR>")
  buf_map(bufnr, "n", "gr", ":LspRename<CR>")
  buf_map(bufnr, "n", "gy", ":LspTypeDef<CR>")
  buf_map(bufnr, "n", "K", ":LspHover<CR>")
  buf_map(bufnr, "n", "[a", ":LspDiagPrev<CR>")
  buf_map(bufnr, "n", "]a", ":LspDiagNext<CR>")
  buf_map(bufnr, "n", "ga", ":LspCodeAction<CR>")
  -- buf_map(bufnr, "n", "<Leader>a", ":LspDiagLine<CR>")
  buf_map(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>")
  if client.resolved_capabilities.document_formatting then
    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
  end

  -- quickfix window for lsp errors etc
  require("trouble").setup {}

  -- unmap C-t so we can map it?
  -- vim.api.nvim_del_keymap("n", "<C-t>")
  map('n', "Ctrl-T", ":Trouble<CR>")
  map('n', "<Ctrl-T>", ":Trouble<CR>")


  -- attach aerial to LSP for ctags-like interface
  require("aerial").on_attach(client, bufnr)
-- Toggle the aerial window with <leader>a
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>AerialToggle!<CR>', {})
    -- Jump forwards/backwards with '{' and '}'
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '{', '<cmd>AerialPrev<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '}', '<cmd>AerialNext<CR>', {})
    -- Jump up the tree with '[[' or ']]'
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[[', '<cmd>AerialPrevUp<CR>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']]', '<cmd>AerialNextUp<CR>', {})
end


lspconfig.tsserver.setup({
  -- cb that runs whenever we open a file that tsserver supports
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false -- disable built in tsserver formatter (we use prettier)
    client.resolved_capabilities.document_range_formatting = false
    local ts_utils = require("nvim-lsp-ts-utils")
    ts_utils.setup({})
    ts_utils.setup_client(client)
    buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
    buf_map(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
    buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")
    on_attach(client, bufnr)
  end,
})

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.formatting.prettier
  },
  on_attach = on_attach
})


-- LSP for LUA
-- https://formulae.brew.sh/formula/lua-language-server
-- https://jdhao.github.io/2021/08/12/nvim_sumneko_lua_conf/

--https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/sumneko_lua.lua
require'lspconfig'.sumneko_lua.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}





-- LSP keymappings


-- unmap Ctrl-l (from tmux-navigator)
-- vim.api.nvim_del_keymap('n', '<C-L>')
-- vim.keymap.del('n', '<C-L>')

-- Ctrl-L to show definition etc under cursor
map("n", "<C-l>", ":LspHover<CR>")
map("n", "<Leader>l", ":LspDiagLine<CR>")

-- maybe ctrl-} for moving to next lsp thing?
-- Would be cool to have ctrl- layer for LSP and other diagnostic / code hints & help & renames and corrections... in normal mode...

