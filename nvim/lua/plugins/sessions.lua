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
  {
    "Shatur/neovim-session-manager",
    opts = {
      autoload_mode = "disabled",
    }
  },
}
