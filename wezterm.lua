-- https://wezfurlong.org/wezterm/config/files.html
--
---- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'nightfox'
-- config.color_scheme = 'nordfox'


-- fonts
--https://github.com/wez/wezterm/issues/3774
config.freetype_load_flags = 'NO_HINTING'
-- config.front_end = "WebGpu" -- not sure if this helps??

-- https://wezfurlong.org/wezterm/config/fonts.html
-- https://www.jetbrains.com/lp/mono/#font-family
-- https://superuser.com/questions/1810465/font-size-variable-not-working-wezterm-lua-file
--https://superuser.com/questions/1810465/font-size-variable-not-working-wezterm-lua-file
-- wezterm ls-fonts --list-system -- list fonts available
config.font = wezterm.font('JetBrains Mono', { weight = 'DemiBold' }) -- WHY is it DemiBold instead of SemiBold???
config.font_size = 15

config.keys = {

  -- bind cmd-k just like alacritty and iterm
  {
    key = 'k',
    mods = 'CMD',
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
  },
}



-- and finally, return the configuration to wezterm
return config



-- READING
-- CLI https://wezfurlong.org/wezterm/cli/general.html#synopsis
