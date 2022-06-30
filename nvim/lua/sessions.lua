----------------------------
-- SESSION Management
------------------	
local use = require('packer').use
use 'rmagatti/auto-session'


require('auto-session').setup {
	log_level = 'info',
	auto_restore_enabled = false, -- don't restore by default
	auto_session_suppress_dirs = {'~/', '~/Projects'}
}
