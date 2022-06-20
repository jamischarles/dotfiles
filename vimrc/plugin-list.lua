-- TODO LUA VIM:
-- Split files by UI feature / functionality... like (buffers), then consider having their own requires there as well...

------------------
-- Set up PACKER (lua package manager). Doing it this way ensures it'll be
---------------------
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)

  use 'wbthomason/packer.nvim' -- needs to be here so it doesn't always ask to remove itself during install

  -- syntax sugar (matching closing brace)
  use "windwp/nvim-autopairs"


  -- File nav / finding
  use { 'ibhagwan/fzf-lua',
    -- optional for icon support
    requires = { 'kyazdani42/nvim-web-devicons' }
  }


  use {
    'nvim-telescope/telescope.nvim', -- Like fzf but with Lua
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use { -- load files based on frecency
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require"telescope".load_extension("frecency")
    end,
    requires = {"tami5/sqlite.lua"}
  }

  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- use {
  --   "nvim-telescope/telescope-fzy-native.nvim",
  --   config = function()
  --     require"telescope".load_extension("frecency")
  --   end
  -- }



  use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons'}


  -- Syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- Git / sign columns
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      -- is this like a constructor?
      require('gitsigns').setup()
    end
  }


-- Autocomplete
-- FIXME: Should we move this part to a "autocomplete" file as well?
use 'neovim/nvim-lspconfig'
use 'hrsh7th/cmp-nvim-lsp'
use 'hrsh7th/cmp-buffer'
use 'hrsh7th/cmp-path'
use 'hrsh7th/cmp-cmdline'
use 'hrsh7th/nvim-cmp'


  -- use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' } -- git diff viewer

  -- Indent guides
  use "lukas-reineke/indent-blankline.nvim"

  -- Ctags-like plugin that shows all the fns for a file
  use {
    'stevearc/aerial.nvim',
    config = function() require('aerial').setup() end
  }
  -- navigating around the symbols in a file
  use "ziontee113/syntax-tree-surfer"



  -- LSP config stuff
  use 'nvim-lua/plenary.nvim' -- async lua lib writing easier async. needed for some of these deps
  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
  use 'jose-elias-alvarez/null-ls.nvim' --
  use 'jose-elias-alvarez/nvim-lsp-ts-utils'

  -- Terminal window on top of code window with easy toggle
  use {"akinsho/toggleterm.nvim", tag = 'v1.*', config = function()
    require("toggleterm").setup() end
  }


  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons"
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)


