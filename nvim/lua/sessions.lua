----------------------------
-- SESSION Management
------------------	

-- moved this down below
-- require('auto-session').setup {
-- 	log_level = 'info',
-- 	auto_restore_enabled = false, -- don't restore by default
-- 	auto_session_suppress_dirs = {'~/', '~/Projects'}
-- }

return {
	name = "sessions",
	dependencies = {
{'rmagatti/auto-session', opts = {
	log_level = 'info',
	auto_restore_enabled = false, -- don't restore by default
	auto_session_suppress_dirs = {'~/', '~/Projects'}

}}
	},
}
