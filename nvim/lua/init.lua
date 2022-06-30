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
--https://neovim.io/doc/user/api.html (see nvim_feedkeys)
--https://neovim.io/doc/user/builtin.html#feedkeys()
local feedkeys = function(keys, mode)
  vim.api.nvim_feedkeys(
  vim.api.nvim_replace_termcodes(keys, true, true, true),
  mode,
  false
  )
end

-- handle backspace in telescope vs other environments
-- create a global command
-- vim.api.nvim_create_user_command(
--     'HandleBackspace',
--     function()
--
--
--       -- if buffertype is NOT telescropPrompt, exit insert mode
--       if vim.bo.filetype ~= "TelescopePrompt" then
--         vim.cmd('stopinsert')
--       else
--         feedkeys("<C-H>", "i") -- in Vim, Ctrl+h is mapped to backspace
--       end
--     end,
--     { nargs = 0 }
-- )
--
--
-- -- map backspace/del to esc and marks
-- map("i", "<BS>", "<cmd>:HandleBackspace<CR>")
-- map("x", "<BS>", "<ESC>")
-- -- map BS to marks in normal mode
-- map("n", "<BS>", "`")
-- map("n", "<BS><BS>", "`'")
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




-- " REMAP CAPS to BACKTICK key ` for normal mode, ESC for other modes
-- nnoremap <BS> `
-- nnoremap <BS><BS> `'| " use `` for jump back
-- inoremap <BS> <ESC>
-- xnoremap <BS> <ESC>





-- autocmd BufEnter * if &buftype != "nofile" | lua require'completion'.on_attach()


-- :startinsert/:stopinsert/vim.cmd('startinsert')



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


----------------------------
-- GIT features


-- local gs = require("gitsigns")
-- vim.api.nvim_create_user_command(
--     'Diff',
--     function()
--       gs.diffthis('~', {split = "botright"}) -- call same as :Gitsigns diffthis. Async action
--       -- gs.diffthis('~', {split = "botright"}) -- call same as :'Gitsigns diffthis. Async action
--       -- feedkeys("<C-W><C-x>", "m") -- Swap the panes
--     end,
--     { nargs = 0 }
-- )
--

-- vim.api.nvim_create_user_command('Diff', ":rightbelow Gitsigns diffthis",  { nargs = 0 })


-- commands I want to use more
-- gitsigns show (or can use ~1) (show last commit for the file... or can look a specific commit)
-- gitsigns diffthis hash? (base)




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

