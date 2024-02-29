-------------------------------
-- Building my own ctrl-t telescope plugin...
-------------------------------
-- From https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#customize-buffers-display-to-look-like-leaderf
--
-- WORKS
--
--


return {
  name = "telescope-ctrl-t",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, for file icons
  },
  init = function()
    local my_custom_picker = {}

    local devicons = require "nvim-web-devicons"
    local entry_display = require("telescope.pickers.entry_display")

    local filter = vim.tbl_filter
    local map = vim.tbl_map

    function my_custom_picker.gen_from_buffer_like_leaderf(opts)
      opts = opts or {}
      local default_icons, _ = devicons.get_icon("file", "", { default = true })

      local bufnrs = filter(function(b)
        return 1 == vim.fn.buflisted(b)
      end, vim.api.nvim_list_bufs())

      local max_bufnr = math.max(unpack(bufnrs))
      local bufnr_width = #tostring(max_bufnr)

      local max_bufname = math.max(
        unpack(
          map(function(bufnr)
            return vim.fn.strdisplaywidth(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:t"))
          end, bufnrs)
        )
      )

      local displayer = entry_display.create {
        separator = " ",
        items = {
          { width = bufnr_width },
          { width = 4 },
          { width = vim.fn.strwidth(default_icons) },
          { width = max_bufname },
          { remaining = true },
        },
      }

      local make_display = function(entry)
        return displayer {
          { entry.bufnr,     "TelescopeResultsNumber" },
          { entry.indicator, "TelescopeResultsComment" },
          { entry.devicons,  entry.devicons_highlight },
          entry.file_name,
          { entry.dir_name, "Comment" }
        }
      end

      local shorten_path_name = function(path)
        -- then show the end of the filepath
        -- Q: can we use this to find the project root?
        --https://github.com/nvim-lua/plenary.nvim/blob/master/lua/plenary/path.lua plenary is really useful for path manipulation
        --https://github.com/nvim-lua/plenary.nvim/blob/master/tests/plenary/path_spec.lua (usage)
        local Path = require "plenary.path"
        local cwd = vim.fn.getcwd() -- working directory we opened nvim in...
        local relpath = Path:new(path):normalize(cwd)

        return relpath
      end


      return function(entry)
        local bufname = entry.info.name ~= "" and entry.info.name or "[No Name]"
        local hidden = entry.info.hidden == 1 and "h" or "a"
        local readonly = vim.api.nvim_buf_get_option(entry.bufnr, "readonly") and "=" or " "
        local changed = entry.info.changed == 1 and "+" or " "
        local indicator = entry.flag .. hidden .. readonly .. changed

        local dir_name = vim.fn.fnamemodify(bufname, ":p:h")
        local file_name = vim.fn.fnamemodify(bufname, ":p:t")

        local icons, highlight = devicons.get_icon(bufname, string.match(bufname, "%a+$"), { default = true })

        return {
          valid = true,

          value = bufname,
          ordinal = entry.bufnr .. " : " .. file_name,
          display = make_display,

          bufnr = entry.bufnr,

          lnum = entry.info.lnum ~= 0 and entry.info.lnum or 1,
          indicator = indicator,
          devicons = icons,
          devicons_highlight = highlight,

          file_name = file_name,
          dir_name = shorten_path_name(dir_name),
        }
      end
    end

    return my_custom_picker
  end
}
