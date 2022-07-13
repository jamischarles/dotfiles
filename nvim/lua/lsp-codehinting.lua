-- -------------------------
-- LSP config & tooling
-- https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c
-- ----------------------------
--
-- LOOK INTO:
-- nvim_buf_add_highlight({buffer}, {ns_id}, {hl_group}, {line}, {col_start}, (add highlights)
--
-- require("null-ls").setup({
--   sources = {
--     require("null-ls").builtins.formatting.stylua,
--     require("null-ls").builtins.diagnostics.eslint,
--     require("null-ls").builtins.completion.spell,
--   },
-- })

local map = require("utils").mapKey
local unMap = require("utils").unmapKey
local use = require("packer").use

-- Formatting
use({ "ckipp01/stylua-nvim", run = "cargo install stylua" }) -- lua formatting

-- Syntax highlighting
use({
	"nvim-treesitter/nvim-treesitter",
	run = ":TSUpdate",
})

-- gps context
use {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig"
}

-- coloring hex colors
use 'norcalli/nvim-colorizer.lua'
require'colorizer'.setup {
	css = {
		rgb_fn   = true;        -- CSS rgb() and rgba() functions
		hsl_fn   = true;        -- CSS hsl() and hsla() functions
		css      = true;        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
		css_fn   = true;
	};
	less = {
		rgb_fn   = true;        -- CSS rgb() and rgba() functions
		hsl_fn   = true;        -- CSS hsl() and hsla() functions
		css      = true;        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
		css_fn   = true;
	};

}

-- better tag matching (including git conflict markers)
-- use 'andymass/vim-matchup'

-- context nav (tells you what element you are in and the bounds)
use({ "nvim-treesitter/nvim-treesitter-context", requires = "nvim-treesitter/nvim-treesitter" })

-- Ctags-like plugin that shows all the fns for a file
use({
	"stevearc/aerial.nvim",
	config = function()
		require("aerial").setup()
	end,
})
-- navigating around the symbols in a file
use("ziontee113/syntax-tree-surfer")

-- LSP config stuff
use("nvim-lua/plenary.nvim") -- async lua lib writing easier async. needed for some of these deps
use("neovim/nvim-lspconfig") -- Configurations for Nvim LSP
use("jose-elias-alvarez/null-ls.nvim") --
use("jose-elias-alvarez/nvim-lsp-ts-utils")

-- Terminal window on top of code window with easy toggle
use({
	"akinsho/toggleterm.nvim",
	tag = "v1.*",
	config = function()
		require("toggleterm").setup()
	end,
})

use({
	"folke/trouble.nvim",
	requires = "kyazdani42/nvim-web-devicons",
})

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
	-- buf_map(bufnr, "n", "K", ":LspHover<CR>")
	buf_map(bufnr, "n", "[a", ":LspDiagPrev<CR>")
	buf_map(bufnr, "n", "]a", ":LspDiagNext<CR>")
	buf_map(bufnr, "n", "ga", ":LspCodeAction<CR>")
	-- buf_map(bufnr, "n", "<Leader>a", ":LspDiagLine<CR>")
	buf_map(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>")
	if client.resolved_capabilities.document_formatting then
		vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	end

	-- quickfix window for lsp errors etc
	require("trouble").setup({})

	-- unmap C-t so we can map it?
	-- vim.api.nvim_del_keymap("n", "<C-t>")
	-- unMap('n', "<C-t>")
	-- SEE inti.lua for trouble mapping

	-- code context info
	require('nvim-navic').attach(client, bufnr)
	--

	-- attach aerial to LSP for ctags-like interface
	require("aerial").on_attach(client, bufnr)
	-- Toggle the aerial window with <leader>a
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>a", "<cmd>AerialToggle!<CR>", {})
	-- Jump forwards/backwards with '{' and '}'
	vim.api.nvim_buf_set_keymap(bufnr, "n", "{", "<cmd>AerialPrev<CR>", {})
	vim.api.nvim_buf_set_keymap(bufnr, "n", "}", "<cmd>AerialNext<CR>", {})
	-- Jump up the tree with '[[' or ']]'
	vim.api.nvim_buf_set_keymap(bufnr, "n", "[[", "<cmd>AerialPrevUp<CR>", {})
	vim.api.nvim_buf_set_keymap(bufnr, "n", "]]", "<cmd>AerialNextUp<CR>", {})
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
		null_ls.builtins.formatting.prettier,
	},
	on_attach = on_attach,
})

-- LSP for LUA
-- https://formulae.brew.sh/formula/lua-language-server
-- https://jdhao.github.io/2021/08/12/nvim_sumneko_lua_conf/

--https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/sumneko_lua.lua
require("lspconfig").sumneko_lua.setup({
	commands = {
		Format = {
			function()
				require("stylua-nvim").format_file()
			end,
		},
	},
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
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
})

-- require("treesitter-context").setup({
-- 	enable = true,
-- })

require'treesitter-context'.setup{
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
            'class',
            'function',
            'method',
            -- 'for', -- These won't appear in the context
            -- 'while',
            -- 'if',
            -- 'switch',
            -- 'case',
        },
        -- Example for a specific filetype.
        -- If a pattern is missing, *open a PR* so everyone can benefit.
        --   rust = {
        --       'impl_item',
        --   },
    },
    exact_patterns = {
        -- Example for a specific filetype with Lua patterns
        -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
        -- exactly match "impl_item" only)
        -- rust = true,
    },

    -- [!] The options below are exposed but shouldn't require your attention,
    --     you can safely ignore them.

    zindex = 20, -- The Z-index of the context window
    mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
}

-- require'nvim-treesitter.configs'.setup {
-- 	matchup = {
-- 		enable = true,              -- mandatory, false will disable the whole extension
-- 		disable = { "c", "ruby" },  -- optional, list of language that will be disabled
-- 		-- [options]
-- 	},
-- }

-- LSP keymappings

-- unmap Ctrl-l (from tmux-navigator)
-- vim.api.nvim_del_keymap('n', '<C-L>')
-- vim.keymap.del('n', '<C-L>')

-- Ctrl-L to show definition etc under cursor
map("n", "<C-l>", ":LspHover<CR>")
map("n", "<Leader>l", ":LspDiagLine<CR>")

-- maybe ctrl-} for moving to next lsp thing?
-- Would be cool to have ctrl- layer for LSP and other diagnostic / code hints & help & renames and corrections... in normal mode...
