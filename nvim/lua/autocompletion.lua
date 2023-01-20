----------------------------
-- AUTOCOMPLETION ----------------
-- -------------------------------
--
--

local map = require('utils').mapKey
local use = require('packer').use



-- Cmp autocompletion
use 'hrsh7th/nvim-cmp'
use 'hrsh7th/cmp-nvim-lsp'
use 'hrsh7th/cmp-buffer'
use 'hrsh7th/cmp-path'
use 'hrsh7th/cmp-cmdline'
use 'hrsh7th/cmp-nvim-lua' -- nvim api completion
use { 'saadparwaiz1/cmp_luasnip', requires = '~/.config/nvim/lua/snippets' }

-- delay? https://github.com/hrsh7th/nvim-cmp/issues/715

-- syntax sugar (matching closing brace)
use "windwp/nvim-autopairs"

require('nvim-autopairs').setup {
	map_bs = false
}

local cmp_autopairs = require('nvim-autopairs.completion.cmp');


--
-- - Setup nvim-cmp.
local luasnip = require 'luasnip'
local cmp = require 'cmp'

-- cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done())
--

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
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		-- ['<BS>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

		-- https://github.com/ChristianChiarulli/nvim/blob/a5f5fb81b652fde891a6abd228cf3e9e878ea218/lua/user/cmp.lua#L132
		-- YASS
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
				-- elseif check_backspace() then Q: Where did this go?
				-- 	fallback()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),






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
-- https://www.reddit.com/r/neovim/comments/qa4wb6/how_do_i_limit_completion_options_with_nvimcmp/
-- :h pumheight
-- vim.ui.nvim_ui_pum_set
vim.o.pumheight = 25 -- set height limit of autocompletion window
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path', max_item_count = 7 },
		{ name = 'nvim_lua' }
	}, {
		{ name = 'cmdline' }
	})
})


-- cmp.setup.cmdline(':Rg', {
-- 	mapping = cmp.mapping.preset.cmdline(),
-- 	sources = cmp.config.sources({
-- 		{ name = 'path', max_item_count = 7 }
-- 	}, {
-- 		{ name = 'cmdline' }
-- 	})
-- })


-- Todo: try this: https://github.com/lukas-reineke/cmp-rg
-- cmp.setup.cmdline(':Rg', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path'},{ name = 'buffer' }
--   }, {
--     { name = 'ripgrep' }
--   })
-- })
