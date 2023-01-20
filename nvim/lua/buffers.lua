-----------------------
-- BUFFER managment
-- ---------------------------
local map = require("utils").mapKey
-- use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons'}
-- use 'rcarriga/nvim-notify'
-- use 'MunifTanjim/nui.nvim' -- simple floating window/popup manager
-- use 'alex-popov-tech/timer.nvim' -- set timer expiration on window

--
--
vim.opt.termguicolors = true


-- TRYING Cokeline

-- local modified_active_fg_color = get_hex('BufferCurrentMod', 'fg')
-- local modified_active_bg_color = get_hex('BufferCurrentMod', 'bg')
-- local modified_inactive_fg_color = get_hex('BufferCurrentMod', 'fg')
-- local modified_inactive_bg_color = get_hex('BufferCurrentMod', 'bg')
--


-- FIXME: use HL groups since those will be modified by the theme
local colors = {
	black = "#383a42",
	yellow = "#f6c177"

}





-- require('bufferline').setup {}
-- require('bufferline').setup {
--   options = {
--     mode = "buffers", -- set to "tabs" to only show tabpages instead
--     numbers = "buffer_id", -- | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
--       close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
--       right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
--       left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
--       middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
--       -- NOTE: this plugin is designed with this icon in mind,
--       -- and so changing this is NOT recommended, this is intended
--       -- as an escape hatch for people who cannot bear it for whatever reason
--       indicator_icon = '▎',
--       buffer_close_icon = '',
--       modified_icon = '●',
--       close_icon = '',
--       left_trunc_marker = '',
--       right_trunc_marker = '',
--       --- name_formatter can be used to change the buffer's label in the bufferline.
--       --- Please note some names can/will break the
--       --- bufferline so use this at your discretion knowing that it has
--       --- some limitations that will *NOT* be fixed.
--       name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
--         -- remove extension from markdown files for example
--         if buf.name:match('%.md') then
--           return vim.fn.fnamemodify(buf.name, ':t:r')
--         end
--       end,
--       max_name_length = 24,
--       max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
--       tab_size = 18,
--       diagnostics = "nvim_lsp",
--       diagnostics_update_in_insert = true,
--       diagnostics_indicator = function(count, level, diagnostics_dict, context)
--         -- return "("..count.."):"..level..""
--         local icon = level:match("error") and " " or ""
--         return " " .. icon .. count
--         -- local icon = level:match("error") and " " or " "
--       end,
--       -- NOTE: this will be called a lot so don't do any heavy processing here
--       custom_filter = function(buf_number, buf_numbers)
--         -- filter out filetypes you don't want to see
--         if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
--           return true
--         end
--         -- filter out by buffer name
--         if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
--           return true
--         end
--         -- filter out based on arbitrary rules
--         -- e.g. filter out vim wiki buffer from tabline in your work repo
--         if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
--           return true
--         end
--         -- filter out by it's index number in list (don't show first buffer)
--         if buf_numbers[1] ~= buf_number then
--           return true
--         end
--       end,
--       -- offsets = {{filetype = "NvimTree", text = "File Explorer" | function , text_align = "left" | "center" | "right"}},
--       color_icons = true, -- whether or not to add the filetype icon highlights
--       show_buffer_icons = true, -- disable filetype icons for buffers
--       show_buffer_close_icons = false,
--       show_buffer_default_icon = true, -- whether or not an unrecognised filetype should show a default icon
--       show_close_icon = false,
--       show_tab_indicators = false,
--       persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
--       -- can also be a table containing 2 custom separators
--       -- [focused and unfocused]. eg: { '|', '|' }
--       -- separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
--       -- enforce_regular_tabs = false | true,
--       always_show_bufferline = true,
--       custom_areas = {
--         -- Please note that this function will be called a lot and should be as inexpensive as possible so it does not block rendering the tabline.
--         right = function()
--           local result = {}
--           local seve = vim.diagnostic.severity
--           local error = #vim.diagnostic.get(0, {severity = seve.ERROR})
--           local warning = #vim.diagnostic.get(0, {severity = seve.WARN})
--           local info = #vim.diagnostic.get(0, {severity = seve.INFO})
--           local hint = #vim.diagnostic.get(0, {severity = seve.HINT})
--
--           if error ~= 0 then
--             table.insert(result, {text = "  " .. error, guifg = "#EC5241"})
--           end
--
--           if warning ~= 0 then
--             table.insert(result, {text = "  " .. warning, guifg = "#EFB839"})
--           end
--
--           if hint ~= 0 then
--             table.insert(result, {text = "  " .. hint, guifg = "#A3BA5E"})
--           end
--
--           if info ~= 0 then
--             table.insert(result, {text = "  " .. info, guifg = "#7EA9A7"})
--           end
--           return result
--         end,
--       }
--       -- sort_by = 'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
--         -- add custom logic
--         -- return buffer_a.modified > buffer_b.modified
--       -- end
--     }
--   }


  ----------------------
  -- NOTIFICATIONS popup on buffer switch
  -- ---------------------------------
-- require("notify")("My super important message")
-- local plugin = "My Awesome Plugin"

-- vim.notify = require("notify")-- set messages to come to the popup
--
-- vim.notify("This is an error message.\nSomething went wrong!", "error", {
--   title = plugin,
--   on_open = function()
--     vim.notify("Attempting recovery.", vim.log.levels.WARN, {
--       title = plugin,
--     })
--     local timer = vim.loop.new_timer()
--     timer:start(2000, 0, function()
--       vim.notify({ "Fixing problem.", "Please wait..." }, "info", {
--         title = plugin,
--         timeout = 3000,
--         on_close = function()
--           vim.notify("Problem solved", nil, { title = plugin })
--           vim.notify("Error code 0x0395AF", 1, { title = plugin })
--         end,
--       })
--     end)
--   end,
-- })
--

-- :h notify-render
--
-- local notify = require('notify')
-- notify.setup{
-- 	title = plugin,
-- 	timeout = 1,
-- 	render = "minimal",
-- 	minimum_width=800,
-- 	background_colour="#000000",
-- 	stages="slide",
-- 	highlights = {
-- 		title = "#000000",
-- 		icon = "#eeeeee",
-- 		border = "#eeeeee",
-- 		body = "#eeeeee"
-- 	}
-- }

-- vim.cmd[[highlight link NotifyINFOBody guibg=#171717]]
-- vim.cmd[[highlight! link NotifyINFOTitle NotifyINFOBody]] -- force point one highlight color at another
-- vim.cmd[[highlight ColorColumn guibg=#171717]]

-- notify filenumber when we enter a new buffer
  -- vim.api.nvim_create_autocmd({"BufEnter"}, { -- do we need both? BufWinEnter
	 --  -- update CLI command for manual frecency
	 --  -- command = ':silent !fre --add ' .. vim.fn.expand('%')  -- FIXME: Find lua api of this?
	 --  callback = function()
		--   -- TODO: debounce this. Hide old ones. You should never see more than one 
		--   local pathname = vim.fn.expand('%:h')
		--   -- notify.dismiss({}) -- hide all the other notifications
  --         -- notify.notify(pathname)
	 --  end
  -- })
  --

  -- map("n", "<tab>", ':lua require"cokeline/mappings".by_step("switch", 1)<CR>') --moves it around
  map("n", "<tab>", '<cmd>lua  require"cokeline/mappings".by_step("focus", 1)<CR>') -- <cmd> makes it silent
  map("n", "<S-tab>", '<cmd>lua require"cokeline/mappings".by_step("focus", -1)<CR>')
-- map("n", "<tab>", ":BufferLineCycleNext<CR>")
-- map("n", "<S-tab>", ":BufferLineCyclePrev<CR>")
map("n", "<leader><leader>", ":edit #<CR>") -- go to last open buffer
-- " nnoremap <leader><leader> <C-^>| " Goto last buffer
-- map("n", "<leader>q", ":CloseCurrentBufferOrWindow<CR>")
map("n", "<leader>q", ":bdelete<CR>")
map("n", "<leader>o", ":only<CR>") -- Close all other windows

map("n", "<leader><leader>", ":e#<CR>") -- switch to last opened buffer




--------------------------
--EXPERIMENTAL
-----------------------------------
-- Docs: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup

--local Popup = require("nui.popup")
--local event = require("nui.utils.autocmd").event


-- mount/open the component
-- popup:mount()

-- unmount component when cursor leaves buffer
-- popup:on(event.BufLeave, function()
--   popup:unmount()
-- end)

-- set content


-- vim.api.nvim_create_autocmd({"BufEnter"}, { -- do we need both? BufWinEnter
-- -- update CLI command for manual frecency
-- -- command = ':silent !fre --add ' .. vim.fn.expand('%')  -- FIXME: Find lua api of this?
-- 	callback = function()
--
-- 		local popup = Popup({
-- 			enter = false,
-- 			focusable = false,
-- 			border = {
-- 				style = "rounded",
-- 				padding = { 1, 20 },
-- 				-- text = {
-- 				-- 	top = "Buffer path",
-- 				-- 	top_align = "center",
-- 				-- },
-- 			},
-- 			position = "10%",
-- 			size = {
-- 				width = "40%",
-- 				height = "3%",
-- 			},
-- 			buf_options = {
-- 				modifiable = true,
-- 				readonly = false,
-- 			},
-- 			win_options = {
-- 				winblend = 0,
-- 				winhighlight = "Normal:Normal,FloatBorder:Normal",
-- 			},
-- 		})
--
--
-- 		-- TODO: debounce this. Hide old ones. You should never see more than one
-- 		local pathname = "   " .. vim.fn.expand('%:~') -- :h filename-modifiers
-- 		vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { pathname})
-- 		popup:mount()
--
-- 		-- adjust layout
-- 		popup:set_layout({
-- 			relative = "win",
-- 			size = {
-- 				width = 44,
-- 				height = 2,
-- 			},
-- 			position = {
-- 				row = 8,
-- 				col = 30,
-- 			},
-- 		})
--
-- 		vim.defer_fn(function()
-- 			popup:unmount()
-- 		end, 500)
-- 		-- popup:unmount()
-- 	end
-- })

-- TODO: convert this to Lua
-- function breakhabits.createmappings(keys, message)
    -- for key in a:keys
    --     call nvim_set_keymap('n', key, ':call BreakHabitsWindow(' . string(a:message). ')<CR>', {'silent': v:true, 'nowait': v:true, 'noremap': v:true})
    -- endfor
-- end

-- function! BreakHabitsWindow(message) abort
--     -- Define the size of the floating window
--     local width = 50
--     local height = 10
--
--     -- Create the scratch buffer displayed in the floating window
--     local buf = vim.api.nvim_create_buf(false, true)
--
--     -- create the lines to draw a box
--     local horizontal_border = '+' .. repeat('-', width - 2) . '+'
--     local empty_line = '|' . repeat(' ', width - 2) . '|'
--     local lines = flatten([horizontal_border, map(range(height-2), 'empty_line'), horizontal_border])
--     -- set the box in the buffer
--     vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
--
--     -- " Create the lines for the centered message and put them in the buffer
--     -- local offset = 0
--     -- for line in message
--     --     let start_col = (width - len(line))/2
--     --     let end_col = start_col + len(line)
--     --     let current_row = height/2-len(a:message)/2 + offset
--     --     let offset = offset + 1
--     --     call nvim_buf_set_text(buf, current_row, start_col, current_row, end_col, [line])
--     -- end
--
--     --" Set mappings in the buffer to close the window easily
--     -- local closingKeys = ['<Esc>', '<CR>', '<Leader>']
--     -- for closingKey in closingKeys
--     --     call nvim_buf_set_keymap(buf, 'n', closingKey, ':close<CR>', {'silent': v:true, 'nowait': v:true, 'noremap': v:true})
--     -- forend
--
--     -- Create the floating window
--     local ui = vim.api.nvim_list_uis()[0]
-- 	local opts = {
-- 		'relative'= 'editor',
-- 		'width'= width,
-- 		'height'= height,
-- 		'col'= (ui.width/2) - (width/2),
-- 		'row'= (ui.height/2) - (height/2),
-- 		'anchor'= 'NW',
-- 		'style'= 'minimal'
-- 	}
--     local win = vim.api.nvim_open_win(buf, 1, opts)
--
--     -- Change highlighting
--     vim.api.nvim_win_set_option(win, 'winhl', 'Normal:ErrorFloat')
-- end
--



--
return {
	name="buffers",
	dependencies = {{
		'noib3/nvim-cokeline',
		dependencies = {'kyazdani42/nvim-web-devicons'}, -- If you want devicons
		-- options passed to require(cokeline).setup(opts) -- automagically called
		config = function()

			local get_hex = require('cokeline/utils').get_hex
			require('cokeline').setup({
	default_hl = {
		fg = function(buffer)



			return buffer.is_modified and buffer.is_focused and colors.black
			 -- or buffer.is_modified and  get_hex('ColorColumn', ' bg')
			  or buffer.is_modified and get_hex('BufferCurrentMod', 'fg')
			or  buffer.is_focused
			and get_hex('ColorColumn', 'bg')

			or get_hex('Normal', 'fg')
		end,
		bg = function(buffer)
			-- return buffer.is_modified and buffer.is_focused  and get_hex('GitSignsChange', 'fg')
			return buffer.is_modified and buffer.is_focused and colors.yellow
			-- or buffer.is_modified and get_hex('GitSignsChange', 'fg')
			 -- or buffer.is_modified and get_hex('BufferInactiveMod', 'fg')

			or
			buffer.is_focused
			and get_hex('Normal', 'fg')
			or get_hex('ColorColumn', 'bg')
		end,
	},

  components = {
    -- {
    --   text = ' ',
    -- },
    {
      text = function(buffer) return ' ' .. buffer.devicon.icon end,
      fg = function(buffer) return buffer.devicon.color end,
    },
    {
      text = function(buffer) return buffer.unique_prefix end,
      fg = get_hex('Comment', 'fg'),
      style = 'italic',
    },
    {
      text = function(buffer) return buffer.filename .. ' ' end,
    },
    -- {
    --   text = '',
    --   delete_buffer_on_left_click = true,
    -- },
	--
    {
		text = function(buffer )
          return buffer.is_modified and " ●" or ''
        end,
    },
    {
      text = ' ',
    },
  },
})
		end,
	}}
	
	-- config=function()
	-- end,
}
