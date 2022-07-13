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


  -- FIXME: namespace my stuff
  -- require('colorscheme').deps(use)

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


  -- buffer management
 --use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons'}

  -- statusline




  -- Syntax Support for additional langs (common langs syntax comes from treesitter)
  use 'evanleck/vim-svelte'
  use 'HerringtonDarkholme/yats.vim'
  --" or Plug 'leafgarland/typescript-vim'
  use 'maxmellon/vim-jsx-pretty'

  -- Git / sign columns
  -- use {'lewis6991/gitsigns.nvim', branch = "diffthisfix"}



-- Autocomplete
-- FIXME: Should we move this part to a "autocomplete" file as well?
-- use 'neovim/nvim-lspconfig'


  -- use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' } -- git diff viewer

  -- Indent guides
  use "lukas-reineke/indent-blankline.nvim"


  -- Window management
  -- use {"caenrique/swap-buffers.nvim"}



  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)


