
------------------------------
---- Settings for AUTOCOMPLETE features
------------------------------

-- FIXME: Make this a module I can require in.
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--
-- - Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      -- ['<BS>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },

      { name = 'path' } -- enable path autosuggestions for all filetypes
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })


  -- Todo: try this: https://github.com/lukas-reineke/cmp-rg
  -- cmp.setup.cmdline(':Rg', {
  --   mapping = cmp.mapping.preset.cmdline(),
  --   sources = cmp.config.sources({
  --     { name = 'path'},{ name = 'buffer' }
  --   }, {
  --     { name = 'ripgrep' }
  --   })
  -- })



  -- SNIPPETS
  require("luasnip.loaders.from_vscode").lazy_load()


  -- READING
  --https://sbulav.github.io/vim/neovim-setting-up-luasnip/

  -- luasnip mappings
  --  press <Tab> to expand or jump in a snippet. These can also be mapped separately
-- via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
map("i", "<Tab>", ":luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'")
-- imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'

--" -1 for jumping backwards.
-- inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

map("s", "<Tab>", ":lua require('luasnip').jump(1)<CR>")
-- snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
map("s", "<S-Tab>", ":lua require('luasnip').jump(-1)<CR>")
-- snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

-- For changing choices in choiceNodes (not strictly necessary for a basic setup).
-- imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
-- smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'

--
--
-- (src) https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua#L190
-- snippets are added via ls.add_snippets(filetype, snippets[, opts]), where
-- opts may specify the `type` of the snippets ("snippets" or "autosnippets",
-- for snippets that should expand directly after the trigger is typed).
--
-- opts can also specify a key. By passing an unique key to each add_snippets, it's possible to reload snippets by
-- re-`:luafile`ing the file in which they are defined (eg. this one).


-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local function copy(args)
	return args[1]
end

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.add_snippets("all", {
	-- trigger is `fn`, second argument to snippet-constructor are the nodes to insert into the buffer on expansion.
	s("fn", {
		-- Simple static text.
		t("//Parameters: "),
		-- function, first parameter is the function, second the Placeholders
		-- whose text it gets as input.
		f(copy, 2),
		t({ "", "function " }),
		-- Placeholder/Insert.
		i(1),
		t("("),
		-- Placeholder with initial text.
		i(2, "int foo"),
		-- Linebreak
		t({ ") {", "\t" }),
		-- Last Placeholder, exit Point of the snippet.
		i(0),
		t({ "", "}" }),
	}),
  })


  -- BUFFER type, not file name
  -- FIXME: Explain how these mechanics work
  ls.add_snippets("javascript", {
    -- examples
    s("repeat", { i(1, "text"), t({ "", "" }), rep(1) }),
    s("dl1", { --lambda. Like mirroring but different?
      i(1, "sample_text"),
      t({ ":", "" }),
      dl(2, l._1, 1),
    }),

    -- lamdba with a transform?
    s("dl2", {
      i(1, "sample_text"),
      i(2, "sample_text_2"),
      t({ "", "" }),
      dl(3, l._1:gsub("\n", " linebreak ") .. l._2, { 1, 2 }),
    }),


    s("cl", {
      -- Simple static text.
      --
      t("console.log('"),
      -- t(1, "' '"),
      i(1, "test"),
      t("', "),
      rep(1), -- repeat 1 here
      t(")"),
      i(2)
    }),
    -- trigger is `cll`, second argument to snippet-constructor are the nodes to insert into the buffer on expansion.
    s("cll", {
      -- Simple static text.
      t("console.log('"),
      -- t(1, "' '"),
      i(1, "test"),
      f(copy, 2),
      t("')"),
      i(0)
      -- function, first parameter is the function, second the Placeholders
      -- whose text it gets as input.
      -- f(copy, 2),
      -- t({ "", "function " }),
      -- -- Placeholder/Insert.
      -- i(1),
      -- t("("),
      -- -- Placeholder with initial text.
      -- i(2, "int foo"),
      -- -- Linebreak
      -- t({ ") {", "\t" }),
      -- -- Last Placeholder, exit Point of the snippet.
      -- i(0),
      -- t({ "", "}" }),
    }),
  })


-- in a ts file: search typescript-, then js-, then all-snippets.
ls.filetype_extend("typescript", { "javascript" })
