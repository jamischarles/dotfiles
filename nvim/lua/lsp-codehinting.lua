-- -------------------------
-- LSP config & tooling
-- https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c
-- https://blog.codeminer42.com/configuring-language-server-protocol-in-neovim/
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

-- Run prettier on save
-- vim.cmd("autocmd BufWritePre *.js,*.ts,*.svelte,*.json Prettier")
-- vim.cmd("autocmd BufWriteCmd *.js,*.ts,*.svelte,*.json Prettier")
-- vim.cmd("autocmd BufWritePost *.js,*.ts,*.svelte,*.json Prettier")
-- vim.cmd("autocmd BufWritePre *.js,*.ts,*.svelte,*.json lua vim.lsp.buf.formatting_sync()")
-- vim.cmd("autocmd BufWritePre *.js,*.ts,*.svelte,*.json lua vim.lsp.buf.format()")
-- https://www.reddit.com/r/neovim/comments/pb2vd6/lsp_auto_format_on_save_causes_buffer_change/ or use efm formatter

-- https://github.com/jose-elias-alvarez/null-ls.nvim/discussions/324
-- formatting.prettierd.with({
--    extra_filetypes = { "svelte" },
-- }),

-- highlight current line & goodies
-- TODO: move to git?
-- use 'jamischarles/nvim-cursorline'
-- require('nvim-cursorline').setup {
--   cursorline = {
--     enable = false,
--     timeout = 500,
--     number = false,
--   },
--   cursorword = {
--     enable = true,
--     min_length = 3,
--     hl = { underline = true },
--   }
-- }

-- gps context
-- use {
--     "SmiteshP/nvim-navic",
--     requires = "neovim/nvim-lspconfig"
-- }

-- better tag matching (including git conflict markers)
-- use 'andymass/vim-matchup'

-- Ctags-like plugin that shows all the fns for a file
-- Using lsp-saga instead
-- use({
-- 	"stevearc/aerial.nvim",
-- 	config = function()
-- 		require("aerial").setup({
-- 			backends = { "treesitter", "lsp", "markdown", "man" },
-- 			filter_kind = false,
-- 			-- filter_kind = {
-- 			-- 	"Class",
-- 			-- 	"Constructor",
-- 			-- 	"Enum",
-- 			-- 	"Function",
-- 			-- 	"Interface",
-- 			-- 	"Module",
-- 			-- 	"Method",
-- 			-- 	"Struct",
-- 			-- },
--
-- 			-- attach aerial to LSP for ctags-like interface
-- 			-- require("aerial").on_attach(client, bufnr)
-- 			-- Toggle the aerial window with <leader>a
-- 			on_attach = function(bufnr)
-- 				-- Jump forwards/backwards with '{' and '}'
-- 				vim.api.nvim_buf_set_keymap(bufnr, "n", "{", "<cmd>AerialPrev<CR>", {})
-- 				vim.api.nvim_buf_set_keymap(bufnr, "n", "}", "<cmd>AerialNext<CR>", {})
-- 				-- Jump up the tree with '[[' or ']]'
-- 				vim.api.nvim_buf_set_keymap(bufnr, "n", "[[", "<cmd>AerialPrevUp<CR>", {})
-- 				vim.api.nvim_buf_set_keymap(bufnr, "n", "]]", "<cmd>AerialNextUp<CR>", {})
-- 			end,
-- 		})
-- 	end,
-- })
-- vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

--use("simrat39/symbols-outline.nvim")
--require("symbols-outline").setup({
--	show_numbers = true,
--	symbol_blacklist = {
--		"Field",
--		"Property",
--	},
--})

-- navigating around the symbols in a file
--use("ziontee113/syntax-tree-surfer")

-- Terminal window on top of code window with easy toggle
-- use({
-- 	"akinsho/toggleterm.nvim",
-- 	tag = "v1.*",
-- 	config = function()
-- 		require("toggleterm").setup()
-- 	end,
-- })

local buf_map = function(bufnr, mode, lhs, rhs, opts)
	vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
		silent = true,
	})
end

--
--
--
-- TODO: Could I build my own displaeyr / viewer based on glow-hover? Or bring another one in?
-- use {
-- 	"JASONews/glow-hover"
-- }
--
--
-- require("glow-hover").setup({
-- 	-- The followings are the default values
-- 	max_width = 50,
-- 	width= 40,
-- 	padding = 10,
-- 	border = "shadow",
-- 	glow_path = "glow",
-- })
-- REQUIRES glow terminal command

-- PROBLEM: Need much better LSPHover look since I use it ALL THE TIME now
-- https://www.reddit.com/r/neovim/comments/tx40m2/is_it_possible_to_improve_lsp_hover_look/
--https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/util.lua
-- better hover framework?
-- use {
--     "lewis6991/hover.nvim",
--     config = function()
--         require("hover").setup {
--             init = function()
--                 -- Require providers
--                 require("hover.providers.lsp")
--                 -- require('hover.providers.gh')
--                 -- require('hover.providers.gh_user')
--                 -- require('hover.providers.jira')
--                 -- require('hover.providers.man')
--                 -- require('hover.providers.dictionary')
--             end,
--             preview_opts = {
--                 border = nil
--             },
--             -- Whether the contents of a currently open hover window should be moved
--             -- to a :h preview-window when pressing the hover keymap.
--             preview_window = false,
--             title = true
--         }
--
--         -- Setup keymaps
-- 		--
-- 		-- map("n", "<C-l>", ":LspHover<CR>")
-- 		-- map("n", "<C- >", ":LspHover<CR>") -- ctrl+space YES
--         vim.keymap.set("n", "<C-l>", require("hover").hover, {desc = "hover.nvim"})
--         vim.keymap.set("n", "<C- >", require("hover").hover_select, {desc = "hover.nvim (select)"}) -- ctrl space
--     end
-- }
local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

-- onattach callback
-- This callback runs whenever a language server attaches to a buffer and is used to set up commands, keybindings, and other buffer-local options
-- No hoisting in lua?
local on_attach = function(client, bufnr)
	vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
	-- vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
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
	-- if client.server_capabilities.document_formatting then
	-- 	vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
	-- end


        -- TODO: Can we limit this to tsserver only?
        client.server_capabilities.document_formatting = false -- disable built in tsserver formatter (we use prettier)
        client.server_capabilities.document_range_formatting = false


	-- format
	if client.supports_method("textDocument/formatting") then
		-- vim.keymap.set("n", "<Leader>f", function()
		-- 	vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
		-- end, { buffer = bufnr, desc = "[lsp] format" })

		-- format on save
		vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
		vim.api.nvim_create_autocmd(event, {
			buffer = bufnr,
			group = group,
			callback = function()
				vim.lsp.buf.format({ bufnr = bufnr, async = async })
			end,
			desc = "[lsp] format on save",
		})
	end

	if client.supports_method("textDocument/rangeFormatting") then
		vim.keymap.set("x", "<Leader>f", function()
			vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
		end, { buffer = bufnr, desc = "[lsp] format" })
	end

	-- quickfix window for lsp errors etc
	require("trouble").setup({})

	-- unmap C-t so we can map it?
	-- vim.api.nvim_del_keymap("n", "<C-t>")
	-- unMap('n', "<C-t>")
	-- SEE inti.lua for trouble mapping

	-- code context info
	-- require('nvim-navic').attach(client, bufnr)
	--
end

-- npm install for these?
-- tsserver doesn't exist? TODO: look at https://www.npmjs.com/package/typescript-language-server

-- require("treesitter-context").setup({
-- 	enable = true,
-- })

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
-- ?Using hover plugin above instead
--
-- FIXME: Maybe we use primarily the Ctrl+ layer as an LSP-type layer of shortcuts?
-- Experiment with this
map("n", "<leader>a", "<cmd>Lspsaga outline<CR>")
vim.keymap.set("n", "<leader>l", ":Lspsaga hover_doc<CR>")
map("n", "<C- >", ":Lspsaga peek_definition<CR>") -- ctrl+space YES

vim.keymap.set("n", "<C-l>", ":Lspsaga show_line_diagnostics<CR>")
vim.keymap.set("n", "<C-s>", ":LspSignatureHelp<CR>") -- Nice!

vim.keymap.set("n", "<Leader>f", ":Lspsaga lsp_finder<CR>") -- find symbol in project. WOOOOOW

-- map("n", "<C-l>", ":LspHover<CR>")
-- map("n", "<C- >", ":LspHover<CR>") -- ctrl+space YES
-- map("n", "<Leader>l", ":LspDiagLine<CR>")

-- Format current buffer with jq command line tool
vim.cmd("command! FormatJSON silent %!jq . %")

-- maybe ctrl-} for moving to next lsp thing?
-- Would be cool to have ctrl- layer for LSP and other diagnostic / code hints & help & renames and corrections... in normal mode...
--
--
--
return {
	name = "lsp-codehinting-syntax-highlighting",
	dependencies = {
		"williamboman/mason.nvim",
		{ "jay-babu/mason-null-ls.nvim", dependencies = { "jose-elias-alvarez/null-ls.nvim" } },

		"neovim/nvim-lspconfig", -- Configurations for Nvim LSP
		{ "jose-elias-alvarez/null-ls.nvim", dependencies = { "nvim-lua/plenary.nvim" } }, --
		"jose-elias-alvarez/typescript.nvim",
		{ "williamboman/mason-lspconfig.nvim", dependencies = { "neovim/nvim-lspconfig" } },

		-- Formatting
		{ "wesleimp/stylua.nvim", dependencies = { "nvim-lua/plenary.nvim" } }, -- lua formatting
		{
			"MunifTanjim/prettier.nvim",
			opts = {
				bin = "prettierd", -- or `'prettierd'` (v0.22+)
				filetypes = {
					"css",
					"graphql",
					"html",
					"javascript",
					"svelte",
					"javascriptreact",
					"json",
					"less",
					"markdown",
					"scss",
					"typescript",
					"typescriptreact",
					"yaml",
				},
			},
		}, -- prettier for JS/TS
                -- RUST (including auto-format)
                {'rust-lang/rust.vim'},

                -- ensure rust lsp features
                {
                  'mrcjkb/rustaceanvim',
                  version = '^3', -- Recommended
                  ft = { 'rust' },
                  server = {
                    on_attach = on_attach
                  },
                },




		-- linting ESLINT ENABLE 1/2
		"MunifTanjim/eslint.nvim",

		-- Syntax highlighting
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			-- run = "volta install typescript-language-server" -- FIXME: is this even working?
		},

		"jparise/vim-graphql", -- NOT lua :(

		"norcalli/nvim-colorizer.lua", -- coloring hex colors

		-- { "nvim-treesitter/nvim-treesitter-context", dependencies = { "nvim-treesitter/nvim-treesitter" } }, -- context nav (tells you what element you are in and the bounds)

		-- NAVIGATING by symbol. SYMBOL hopping / jumping
		{
			"ray-x/navigator.lua",
			dependencies = {
				{ "ray-x/guihua.lua", build = "cd lua/fzy && make" },
				{ "neovim/nvim-lspconfig" },
			},
		},
		"nvim-lua/plenary.nvim", -- async lua lib writing easier async. needed for some of these deps

		-- Quickfix window with lsp errors etc
		{
			"folke/trouble.nvim",
			dependencies = { "kyazdani42/nvim-web-devicons" },
		},

		----------------------------------------------------
		-- HOVER improved for LSP-hover ---------------------
		----------------------------------------------------
		-- Read: https://github.com/neovim/nvim-lspconfig
		-- TODO: TRY THIS https://github.com/glepnir/lspsaga.nvim
                -- TODO: Tweak and configure this more...
                -- TODO: try guard.nvim # for linting...  
		{ --// WOOOOW. so good
			"glepnir/lspsaga.nvim",
			branch = "main",
			event = "BufRead",
			config = function()
				require("lspsaga").setup({
                                  ui = {
                                    -- turns off the ANNOYING lightbulb icon
                                    code_action = ''
                                  }
                                })
			end,
		},
	},
	config = function()
		-----------------------
		-- LSP DEP MANAGEMENT. USE MASON so we can avoid having to manually npm install deps etc
		-- https://github.com/williamboman/mason.nvim
		-----------------------
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				-- "sumneko_lua",
				"rust_analyzer",
				-- "tsserver",
				"svelte",
				"stylelint_lsp",
				"tailwindcss",
				"jsonls",
				-- "eslint",  -- ESLINT 3/3
				"cssls",
			},
		})

		-- formatting
                --let g:rustfmt_autosave = 1
                vim.g.rustfmt_autosave = 1 -- enable autosave in rust files
		-- require("mason-null-ls").setup({
		-- 	ensure_installed = { "stylua", "jq", "prettier", "prettierd",  }, --eslint, eslint_d
		-- })

		-- MasonInstall

		-- this seems to break syntax highlighting because it cannot find a typescript-language-server lsp?
		-- TODO: Trying this one instead
		-- https://github.com/jose-elias-alvarez/typescript.nvim
		-- IF we keep having problems, try using the one from Deno (built in) Deno TS lsp
		--
		-- https://github.com/jose-elias-alvarez/typescript.nvim
                --  USE MASON for installing lsp deps
		require("nvim-treesitter.configs").setup({
			-- use tree-sitter based syntax highlighting
			highlight = {
				enable = true,
				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},
			ensure_installed = {
				"json",
				"lua",
				"vim", -- needed for the lua files to highlight properly for some reason
				"graphql",
				"rust",
				"svelte",
				"typescript",
				"tsx",
				"javascript",
				"css",
				"fish",
				"markdown",
			},
		})

		-- TODO
		vim.api.nvim_set_hl(0, "@text.comment", { link = "Identifier" })

		-- coloring hex colors
		require("colorizer").setup({
			css = {
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true,
			},
			less = {
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true,
			},
		})

		-- TODO: Move the lsp stuff into its own?
		-- LANGUAGE SERVER CONFIGS ---------------------
		-- CONFIGURING ALL THE language servers for LSP

		-- require("navigator").setup() TODO: try later?

		-- local lspconfig = require("lspconfig")

                -- appears to fix the annoying tsserver typing lag issues
                --https://github.com/jose-elias-alvarez/typescript.nvim
                --https://www.reddit.com/r/neovim/comments/s6o051/nvim_lsp_tsserver_diagnostic_slow/
                require("typescript").setup({
                  disable_commands = false, -- prevent the plugin from creating Vim commands
                  debug = true, -- enable debug logging for commands
                  go_to_source_definition = {
                    fallback = true, -- fall back to standard LSP definition on failure
                  },
                  server = { -- pass options to lspconfig's setup method
                  on_attach = on_attach
                },
              })

		-- lspconfig.tsserver.setup({
		-- 	-- cb that runs whenever we open a file that tsserver supports
		-- 	on_attach = function(client, bufnr)
		-- 		client.server_capabilities.document_formatting = false -- disable built in tsserver formatter (we use prettier)
		-- 		client.server_capabilities.document_range_formatting = false
		-- 		local ts_utils = require("nvim-lsp-ts-utils")
		-- 		ts_utils.setup({})
		-- 		ts_utils.setup_client(client)
		-- 		-- buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
		-- 		-- buf_map(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
		-- 		-- buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")
		-- 		on_attach(client, bufnr)
		-- 	end,
		-- })

		local null_ls = require("null-ls")

		-- for :LSPFormatting command
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		-- require("null-ls").setup({
		--
		-- 	-- you can reuse a shared lspconfig on_attach callback here
		-- 	on_attach = function(client, bufnr)
		-- 		if client.supports_method("textDocument/formatting") then
		-- 			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		-- 			vim.api.nvim_create_autocmd("BufWritePre", {
		-- 				group = augroup,
		-- 				buffer = bufnr,
		-- 				callback = function()
		-- 					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
		-- 					vim.lsp.buf.format()
		-- 				end,
		-- 			})
		-- 		end
		-- 	end,
		-- })
		--
		--
		require("prettier").setup({
			cli_options = {
				-- https://prettier.io/docs/en/cli.html#--config-precedence
				-- config_precedence = "prefer-file", -- or "cli-override" or "file-override"
				config_precedence = "cli-override", -- use this config EVEN if prettier config files are found
                                print_width = 80
			},
		})

                -- ESLINT ? 2/3
		null_ls.setup({})
		-- null_ls.setup({
		-- 	sources = {
  --                         -- eslint is configged after this
		-- 		-- null_ls.builtins.diagnostics.eslint_d,
		-- 		-- null_ls.builtins.code_actions.eslint_d,
		-- 		null_ls.builtins.formatting.prettierd.with({
		-- 			filetypes = {
		-- 				"html",
		-- 				"json",
		-- 				"svelte",
		-- 				"markdown",
		-- 				"css",
		-- 				"javascript",
		-- 				"javascriptreact",
		-- 				"typescript",
		-- 			},
		-- 		}),
		-- 	},
		-- 	on_attach = on_attach,
		-- })

		-- ESLINT config -- ENABLE / DISABLE HERE 3/3
                -- REBOOT needed of nvim to take effect
                -- https://stackoverflow.com/questions/74655190/eslint-d-eslint-error-failed-to-load-plugin-import-declared-in-eslintrc
		require("eslint").setup({
			bin = "eslint_d", -- eslint or `eslint_d`
			code_actions = {
				enable = true, -- ESLINT 3/3
				apply_on_save = {
					enable = true,
					types = { "directive", "problem", "suggestion", "layout" },
				},
				disable_rule_comment = {
					enable = false,
					location = "separate_line", -- or `same_line`
				},
			},
			diagnostics = {
				enable = true,
				report_unused_disable_directives = false,
				run_on = "type", -- or `save`
			},
		})

		-- require("null-ls").builtins.formatting.stylua,

		-- LSP for LUA
		-- https://formulae.brew.sh/formula/lua-language-server
		-- https://jdhao.github.io/2021/08/12/nvim_sumneko_lua_conf/

		--https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/sumneko_lua.lua
		-- require("lspconfig").sumneko_lua.setup({
		-- 	commands = {
		-- 		Format = {
		-- 			function()
		-- 				require("stylua").format()
		-- 			end,
		-- 		},
		-- 	},
		-- 	settings = {
		-- 		Lua = {
		-- 			runtime = {
		-- 				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
		-- 				version = "LuaJIT",
		-- 			},
		-- 			diagnostics = {
		-- 				-- Get the language server to recognize the `vim` global
		-- 				globals = { "vim" },
		-- 			},
		-- 			workspace = {
		-- 				-- Make the server aware of Neovim runtime files
		-- 				library = vim.api.nvim_get_runtime_file("", true),
		-- 			},
		-- 			-- Do not send telemetry data containing a randomized but unique identifier
		-- 			telemetry = {
		-- 				enable = false,
		-- 			},
		-- 		},
		-- 	},
		-- })

		-- DISABLED
		-- require("treesitter-context").setup({
		-- 	enable = false, -- Enable this plugin (Can be enabled/disabled later via commands)
		-- 	max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
		-- 	trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
		-- 	patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
		-- 		-- For all filetypes
		-- 		-- Note that setting an entry here replaces all other patterns for this entry.
		-- 		-- By setting the 'default' entry below, you can control which nodes you want to
		-- 		-- appear in the context window.
		-- 		default = {
		-- 			"class",
		-- 			"function",
		-- 			"method",
		-- 			-- 'for', -- These won't appear in the context
		-- 			-- 'while',
		-- 			-- 'if',
		-- 			-- 'switch',
		-- 			-- 'case',
		-- 		},
		-- 		-- Example for a specific filetype.
		-- 		-- If a pattern is missing, *open a PR* so everyone can benefit.
		-- 		--   rust = {
		-- 		--       'impl_item',
		-- 		--   },
		-- 	},
		-- 	exact_patterns = {
		-- 		-- Example for a specific filetype with Lua patterns
		-- 		-- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
		-- 		-- exactly match "impl_item" only)
		-- 		-- rust = true,
		-- 	},
		--
		-- 	-- [!] The options below are exposed but shouldn't require your attention,
		-- 	--     you can safely ignore them.
		--
		-- 	zindex = 20, -- The Z-index of the context window
		-- 	mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
		-- })
	end,
}
