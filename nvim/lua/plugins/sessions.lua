----------------------------
-- SESSION Management
------------------
--
-- TODO: Look at this
-- https://github.com/echasnovski/mini.nvim#minisessions

-- moved this down below
-- require('auto-session').setup {
-- 	log_level = 'info',
-- 	auto_restore_enabled = false, -- don't restore by default
-- 	auto_session_suppress_dirs = {'~/', '~/Projects'}
-- }

return {
  -- {
  --   "Shatur/neovim-session-manager",
  --   opts = {
  --     autoload_mode = "disabled",
  --   }
  -- },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
      -- Set to 0 to always save
      need = 0, -- 1
    },
    init = function()
      -- set up commands
      -- vim.api.nvim_create_user_command("SessionLoad", "lua require('persistence').select()", {})
      vim.api.nvim_create_user_command("SessionLoad", "lua require('persistence').select()", {})
      vim.api.nvim_create_user_command("SessionLoadLast", "lua require('persistence').load({ last = true })", {})
    end
  }
}
