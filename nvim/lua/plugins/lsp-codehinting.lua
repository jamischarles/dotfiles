-- trying a very minimalist "from-scratch" approach
-- https://github.com/VonHeikemen/lsp-zero.nvim
-- https://lsp-zero.netlify.app/docs/
--
--
-- INIT vs config
-- https://www.reddit.com/r/neovim/comments/17f9pqi/what_is_the_difference_between_setting_keymaps/
--
-- --TL;DR) Legacy vim plugins that require vim.g.*** = ... settings should go to init. For other neovim plugins (usually .setup { ... }), put the config in config.
--
-- init = executed before plugin loads, i.e. being added to &rtp, execute plugin/*.lua scripts, etc.
--
-- config = executed after plugin loads.
--
-- Keymaps can go to config in most of the cases (the behavior are actually different, e.g. when the plugin uses hasmapto to determine whether to create a default keymap or not). If you do not lazy load the plugin, your config code is anyway being executed during startup but with config can be executed lazily, so it could be beneficial for speed.
-- --


-- for github copiliot
local setupAiCodingAssist = function()
  -- lua
  -- vim.g.copilot_node_command = "~/.nvm/versions/node/v16.15.0/bin/node"
  vim.g.copilot_node_command = "~/.volta/tools/image/node/20.10.0/bin/node"
end

-- for nvim_cmp
local setupAutocomplete = function()
  local cmp = require('cmp')

  cmp.setup({
    sources = {
      { name = 'nvim_lsp' },
      { name = 'buffer' },
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      -- Super tab
      ['<Tab>'] = cmp.mapping(function(fallback)
        local luasnip = require('luasnip')
        local col = vim.fn.col('.') - 1

        if cmp.visible() then
          cmp.select_next_item({ behavior = 'select' })
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
          fallback()
        else
          cmp.complete()
        end
      end, { 'i', 's' }),

      -- Super shift tab
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        local luasnip = require('luasnip')

        if cmp.visible() then
          cmp.select_prev_item({ behavior = 'select' })
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
      -- enter to accept
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
    -- Make the first item in completion menu always be selected.
    preselect = 'item',
    completion = {
      completeopt = 'menu,menuone,noinsert'
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
  })
end


local setupLanguageServers = function()
  require('mason').setup({})

  require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = { 'lua_ls', 'biome' }, --, 'rust_analyzer'},
    handlers = {
      -- this first function is the "default handler"
      -- it applies to every language server without a "custom handler"
      function(server_name)
        require('lspconfig')[server_name].setup({})
      end,

      -- this is the "custom handler" for `biome`
      biome = function()
        require('lspconfig').biome.setup({
          single_file_support = false,
          on_attach = function(client, bufnr)
            -- print('hello biome')
          end
        })
      end,
    }
  })
end

local buffer_autoformat = function(bufnr)
  local group = 'lsp_autoformat'
  vim.api.nvim_create_augroup(group, { clear = false })
  vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })

  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = bufnr,
    group = group,
    desc = 'LSP format on save',
    callback = function()
      -- note: do not enable async formatting
      vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
    end,
  })
end

local setupFormatOnSave = function()
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
      local id = vim.tbl_get(event, 'data', 'client_id')
      local client = id and vim.lsp.get_client_by_id(id)
      if client == nil then
        return
      end

      -- make sure there is at least one client with formatting capabilities
      if client.supports_method('textDocument/formatting') then
        buffer_autoformat(event.buf)
      end
    end
  })
end


local setupDiagnostics = function()
  -- uncomment to disable
  --vim.diagnostic.config({
  --  signs = false,
  --})
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '✘',
        [vim.diagnostic.severity.WARN] = '▲',
        [vim.diagnostic.severity.HINT] = '⚑',
        [vim.diagnostic.severity.INFO] = '»',
      },
    },
  })
end

return {
  -- indent guides
  -- {
  --   "folke/snacks.nvim",
  --   ---@type snacks.Config
  --   opts = {
  --     indent = {
  --       -- your indent configuration comes here
  --       -- or leave it empty to use the default settings
  --       -- refer to the configuration section below
  --     }
  --   }
  -- },



  -- AI assistance... TODO: Make a seperate file for this?
  'github/copilot.vim',

  -- cucumber feature -> step navigation
  'tpope/vim-cucumber',


  -- trouble
  --
  -- require('tsc').setup({
  --   use_trouble_qflist = false,
  -- })

  -- Quickfix window with lsp errors etc
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- keys = {
    --   -- {
    --   --   "<leader>xx",
    --   --   "<cmd>Trouble diagnostics toggle<cr>",
    --   --   desc = "Diagnostics (Trouble)",
    --   -- },
    --   {
    --     "<C-t>", -- ctrl-t
    --     "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    --     desc = "Buffer Diagnostics (Trouble)",
    --   },
    -- },
    config = function()
      -- TODO later: change so shows by severity
      -- https://github.com/folke/trouble.nvim/blob/main/docs/examples.md#diagnostics-cascade
      require("trouble").setup(
        {
          modes = {
            diagnostics_buffer = {
              mode = "diagnostics", -- inherit from diagnostics mode
              filter = { buf = 0 }, -- filter diagnostics to the current buffer
            },
          }
        }
      )
    end
  },

  ---------------------
  --- Autocomplete... (see autocomplete.lua file for most of it)

  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',

    -- use a release tag to download pre-built binaries
    version = 'v0.11.0', -- need to do this OR build from source... for the fuzzy matcher...
    -- ^ this way we can download a pre-built binary of the fuzzy matcher...
    -- pinned to git release tag

    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo +nightly build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {
        preset = 'enter',
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        -- accept on enter, don't auto-select
        ['<CR>'] = { 'accept', 'fallback' },

        -- accept on enter. select if none is selected
        -- ['<CR>'] = {
        --   function(cmp)
        --     if cmp.snippet_active() then
        --       return cmp.accept()
        --     else
        --       return cmp.select_and_accept()
        --     end
        --   end,
        --   'snippet_forward',
        --   'fallback'
        -- },
        -- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },


      },
      completion = {
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        ghost_text = {
          enabled = false,
          -- Show the ghost text when an item has been selected
          show_with_selection = true,
          -- Show the ghost text when no item has been selected, defaulting to the first item
          show_without_selection = false,
        },
      },


      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },


      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
    opts_extend = { "sources.default" }
  },







  ----------------------------------------------------
  -- HOVER improved for LSP-hover ---------------------
  ----------------------------------------------------
  -- Read: https://github.com/neovim/nvim-lspconfig
  -- TODO: TRY THIS https://github.com/glepnir/lspsaga.nvim
  -- TODO: Tweak and configure this more...
  -- TODO: try guard.nvim # for linting...
  -- TODO: consider moving this into config block for the other one... not needed though really.
  { --// WOOOOW. so good
    "glepnir/lspsaga.nvim",
    branch = "main",
    event = "BufRead",
    config = function()
      require("lspsaga").setup({
        finder = {
          max_width  = 0.9,
          max_height = 0.9
        },
        -- right rail symbols
        outline = {
          win_width = 40,
          keys = {
            jump = "+" -- throwaway just so e isn't used
          }
        },
        ui = {
          -- turns off the ANNOYING lightbulb icon
          code_action = "",
          max_width   = 0.9,
          max_height  = 0.9

        },
        keymaps = {
          scroll_down = '<C-n>',
          scroll_up = '<C-e>',
        }
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- 'hrsh7th/cmp-nvim-lsp',
      -- 'hrsh7th/nvim-cmp',
      -- 'hrsh7th/cmp-buffer', -- buffer completion

      -- 'saghen/blink.cmp',


      "L3MON4D3/LuaSnip", -- snippet engine

      "williamboman/mason.nvim",
      { "williamboman/mason-lspconfig.nvim", dependencies = { "neovim/nvim-lspconfig" } },
    },
    init = function()
      -- Reserve a space in the gutter
      -- This will avoid an annoying layout shift in the screen
      vim.opt.signcolumn = 'yes'
    end,


    config = function()
      -- Add cmp_nvim_lsp capabilities settings to lspconfig
      -- This should be executed before you configure any language server

      -- cmp_nvim_lsp
      -- local lspconfig_defaults = require('lspconfig').util.default_config
      -- lspconfig_defaults.capabilities = vim.tbl_deep_extend(
      --   'force',
      --   lspconfig_defaults.capabilities,
      --   require('cmp_nvim_lsp').default_capabilities()
      -- )

      -- BLINK
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local lspconfig = require('lspconfig')

      lspconfig['lua_ls'].setup({ capabilities = capabilities })


      -- This is where you enable features that only work
      -- if there is a language server active in the file
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local map = vim.keymap.set
          local opts = { buffer = event.buf }


          map("n", "<Leader>f", ":Lspsaga finder<CR>") -- find symbol in project. WOOOOOW
          map("n", "<leader>a", "<cmd>Lspsaga outline<CR>")
          map("n", "<C-p>", ":Lspsaga peek_definition<CR>")

          vim.keymap.set('n', '<leader>l', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
          vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
          vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
          vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
          vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
          vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
          vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
          vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
          vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        end,
      })

      -- setup lua lsp support
      require('lspconfig').lua_ls.setup({})

      -- FIXME: How do we accept the selection???
      -- Should this be in autocomplete.lua file?
      -- setupAutocomplete()

      setupLanguageServers()

      setupFormatOnSave()

      setupDiagnostics()

      setupAiCodingAssist()
    end
  } }
