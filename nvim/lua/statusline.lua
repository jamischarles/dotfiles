-------------------
-- STATUS LINE
-------------------




local colors = {
	red = "#ca1243",
	grey = "#a0a1a7",
	black = "#383a42",
	white = "#f3f3f3",
	light_green = "#83a598",
	orange = "#fe8019",
	green = "#8ec07c",
}

local theme = {
	normal = {
		a = { fg = colors.white, bg = colors.black },
		b = { fg = colors.white, bg = colors.grey },
		c = { fg = colors.black, bg = colors.white },
		z = { fg = colors.white, bg = colors.black },
	},
	insert = { a = { fg = colors.black, bg = colors.light_green } },
	visual = { a = { fg = colors.black, bg = colors.orange } },
	replace = { a = { fg = colors.black, bg = colors.green } },
}

-- :h filename-modifiers
--require("nvim-web-devicons").get_icon_by_filetype(filetype, opts)
-- 	local fname = vim.fn.expand('%:~:.')
--
-- 	local icon, _ = require'nvim-web-devicons'.get_icon_color(vim.bo.filetype)
--
-- 	return fname .. " %1*" .. icon .. "%*"
-- end

function options()
	return { bg = colors.red }
	-- icon = {},
	-- color = function(section)
	-- 	  return { bg = vim.bo.modified and '#f6c177', fg = vim.bo.modified and colors.black}
	--   end
end


-- function fileIcon()
-- 	local icon, color = require'nvim-web-devicons'.get_icon_color(vim.bo.filetype, "lua")
--
-- 	if vim.bo.modified then
-- 		return {'', align='right', color={fg='red'}}
-- 	else
-- 		return {'', align='left', color={fg='green'}}
-- 	end
-- end



return {
	name="statusline",
	dependencies = {
		"kyazdani42/nvim-web-devicons", -- (for lualine) 
		"nvim-lualine/lualine.nvim",

		"cocopon/iceberg.vim", -- "++ (Blue + purple)
		"EdenEast/nightfox.nvim", -- ++ Dark during the day. Has 10 themes inside. Very configurable.
		"stillwwater/vim-nebula", -- ++ NICE in light AND Dark (nightshift decent)
		-- DARK themes I like (fox ones)
		"ghifarit53/tokyonight-vim", --NICE. try it out more similar to night owl
	},
	config = function()

		-- Put proper separators and gaps between components in sections
		local function process_sections(sections)
			for name, section in pairs(sections) do
				local left = name:sub(9, 10) < "x"
				for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
					table.insert(section, pos * 2, { empty, color = { fg = colors.white, bg = colors.white } })
				end
				for id, comp in ipairs(section) do
					if type(comp) ~= "table" then
						comp = { comp }
						section[id] = comp
					end
					comp.separator = left and { right = "" } or { left = "" }
				end
			end
			return sections
		end



		local empty = require("lualine.component"):extend()
		function empty:draw(default_highlight)
			self.status = ""
			self.applied_separator = ""
			self:apply_highlights(default_highlight)
			self:apply_section_separators()
			return self.status
		end



		-- util to get current highlight color
		--https://www.reddit.com/r/neovim/comments/oxddk9/how_do_i_get_the_value_from_a_highlight_group/
		local function get_color(group, attr)
			return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
		end

		local function search_result()
			if vim.v.hlsearch == 0 then
				return ""
			end
			local last_search = vim.fn.getreg("/")
			if not last_search or last_search == "" then
				return ""
			end
			local searchcount = vim.fn.searchcount({ maxcount = 9999 })
			return last_search .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
		end

		local function isBufMod()
			if vim.bo.modified then
				return true
			end
			return false
			-- return '+'
			-- elseif vim.bo.modifiable == false or vim.bo.readonly == true then
			--   return '-'
			-- end
			-- return ''
		end


		function getFileIcon()
			local icon, _ = require("nvim-web-devicons").get_icon_color(vim.bo.filetype)
			return { icon, align = "right" }
		end

		function getFileIconColor()
			local _, color = require("nvim-web-devicons").get_icon_color(vim.bo.filetype)
			return { fg = color }
		end

		local function filename()
			-- :h filename-modifiers
			--require("nvim-web-devicons").get_icon_by_filetype(filetype, opts)
			local fname = vim.fn.expand("%:~:.") -- file name to root
			-- fname = vim.fn.expand('%:~:h') -- folder name
			-- fname = vim.fn.expand('%:.:h') -- folder name relative to cwd (where we openend vim from) 
			-- fname = vim.fn.expand('%:~:h:s?dev??') -- folder name relative to cwd (where we openend vim from) 

			-- get folder path, but remove ~/dev and ~/dev_freelance from path
			fname = vim.fn.expand('%:p:h:s?/Users/jacharles/dev_freelance/??:s?/Users/jacharles/dev/??') -- folder name relative to cwd (where we openend vim from) 
			-- TODO: use :S for shell command to get project root...

			return fname

			-- vim.bo is buffer local variables (like the comment type etc)
			-- local icon = require("nvim-web-devicons").get_icon_by_filetype(vim.bo.filetype)
			-- how can I set the options color in here?
			--'
			--

			-- { 'filename', icons_enabled = true, file_status = true, path = 3, icon = {'', align='right', color={fg='green'}} }, --1,3 are decent
		end

		-- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#changing-filename-color-based-on--modified-status
		-- creating our own version of filename component
		local filenameComponent = require("lualine.components.filename"):extend()
		local highlight = require'lualine.highlight'
		local niceColor = get_color("lualine_c_normal")
		-- get_color('StatusLine') -- default color
		local default_status_colors = { saved = niceColor, modified = '#f6c177' }

		function filenameComponent:init(options)
			filenameComponent.super.init(self, options)
			self.status_colors = {
				saved = highlight.create_component_highlight_group(
				{bg = default_status_colors.saved}, 'filename_status_saved', self.options),
				modified = highlight.create_component_highlight_group(
				{fg = colors.black, bg = default_status_colors.modified}, 'filename_status_modified', self.options),
			}
			if self.options.color == nil then self.options.color = '' end



			-- local icon, _ = require("nvim-web-devicons").get_icon_color(vim.bo.filetype)
			-- self.options.icon = {icon, align='right'}
		end

		function filenameComponent:update_status()
			local data = filenameComponent.super.update_status(self)

			-- copied from https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/components/filetype.lua#L34
			local f_name, f_extension = vim.fn.expand('%:t'), vim.fn.expand('%:e')
			f_extension = f_extension ~= '' and f_extension or vim.bo.filetype
			local icon, icon_highlight_group = require("nvim-web-devicons").get_icon(f_name, f_extension)

			-- local icon, _ = require("nvim-web-devicons").get_icon_color(vim.bo.filetype)
			-- print("data")
			-- print(data)

			-- local bgColor = vim.bo.modified and self.status_colors.modified or "red"


			-- highlight the whole component (colors the text basically)
			if vim.bo.modified then
				data = highlight.component_format_highlight( self.status_colors.modified ) .. data
			end


			if icon then
				data =  data .. " " .. icon
			end
			-- vim.bo.modified and self.status_colors.modified or self.status_colors.saved

			-- self.options.icon = {icon, align='right'}
			return data
		end


		-- options passed automagically to lualaine.
		--
		require("lualine").setup({
			{
				theme = "auto",
				-- theme = theme,
				component_separators = "",
				section_separators = { left = "", right = "" },
			},
			sections = process_sections({
				-- lualine_a = { { 'mode', fmt = function(str) return str:sub(1,1) end } },
				-- lualine_a = { { "mode" } },
				-- modes a group has certain colors associated etc.. good to know...
				lualine_a = {{"mode"}, { filenameComponent, file_status = false }, },
				-- lualine_b = {{'windows'}},
				lualine_b = {search_result},
				-- lualine_b = { { filenameComponent, file_status = false }, },
				lualine_c = {
					-- 'branch',
					-- 'diff',
					-- { search_result },
					{
						"diagnostics",
						source = { "nvim" },
						sections = { "error" },
						diagnostics_color = { error = { bg = colors.red, fg = colors.white } },
					},
					{
						"diagnostics",
						source = { "nvim" },
						sections = { "warn" },
						diagnostics_color = { warn = { bg = colors.orange, fg = colors.white } },
					},
					-- { filename,icons_enabled=true, icon = function(section) return {'', align='right', color={fg='green'}} end,}, -- return { fg = vim.bo.modified and '#aa3355' or '#33aa88' } },
					-- at what level are functions allowed?
					-- function() return filenameComponent() end,
					{
						filename,
						icons_enabled = true,
						color = function()
							return { fg = vim.bo.modified and colors.black, bg = vim.bo.modified and "#f6c177" }
						end,
					},
					-- icon = {getFileIcon(), align = 'right', color= getFileIconColor() } },
					-- { filename,icons_enabled=true, icon = {getFileIcon(), align = 'right', color= function(section) return{fg= vim.bo.modified and getFileIconColor()} end} },
					-- color = function(section)
					--  return { fg = vim.bo.modified and '#aa3355' or '#33aa88' }
					-- icon={'', color={fg = "blue"}}},
					--   end,icon={'',   color={fg = vim.bo.modified and "#aa3355"}}}, -- return { fg = vim.bo.modified and '#aa3355' or '#33aa88' } },
					-- { filename,icons_enabled=true, icon={'',   color={fg = vim.bo.modified and "#aa3355"}}}, -- return { fg = vim.bo.modified and '#aa3355' or '#33aa88' } },
					-- TODO: Make this a function call

					-- { filename, unpack(fileNameOpts())},

					-- { 'filename', icons_enabled = true, file_status = true, path = 3, icon = {'', align='right', color={fg='green'}} }, --1,3 are decent
					-- { modified, color = {fg=colors.red, bg = colors.red } },  -- FIXME: use the theme color here? Some flavor of it?
					-- return buffer.is_modified and get_hex('GitSignsChange', 'fg')
					{
						"%w",
						cond = function()
							return vim.wo.previewwindow
						end,
					},
					{
						"%r",
						cond = function()
							return vim.bo.readonly
						end,
					},
					{
						"%q",
						cond = function()
							return vim.bo.buftype == "quickfix"
						end,
					},
					-- require('nvim-navic').get_location, cond = require('nvim-navic').is_available },
				},
				lualine_x = {},
				lualine_y = { "filetype" },
				lualine_z = { "%l:%c", "%p%%/%L" },
			}),
			inactive_sections = {
				lualine_c = { "%f %y %m" },
				lualine_x = {},
			},
		})



	end
}


-- print(get_color("Normal", "bg#"))
--
-- --------------------------------------------
