local log = require("vimrc.log")

local ok, heirline = require("vimrc.utils").safe_reloader("heirline")
if not ok then
  return
end

local is_active = require("heirline.conditions").is_active
local buffer_matches = require("heirline.conditions").buffer_matches
local has_diagnostics = require("heirline.conditions").has_diagnostics
local is_git_repo = require("heirline.conditions").is_git_repo
local lsp_attached = require("heirline.conditions").lsp_attached

local utils = require("heirline.utils")
local surround = require("heirline.utils").surround

-- Set the statusbar to be the entire bottom line, not per-window
vim.opt.laststatus = 3

local colors = require("vimrc.plugins.heirline.colors").colors

-- local colors = require("vimrc.plugins.heirline.colors").colors
-- local filename = {
--   provider = "statusline: %f",
--   hl = {
--     fg = colors.dark_red,
--     bg = colors.blue
--   },
--   condition = function()
--     return true
--   end,
--   on_click = {
--     callback = function(self, minwid, nclicks, button)
--       log.warn("don't touch my garbage!")
--     end,
--     name = "click_anywhere_statusline",
--   },
-- }
--

local Align = { provider = "%=" }
local Space = { provider = " " }
local surround_round = { "", "" }
local forward_arrow = ""

local function bold_if_active(component)
  local hl = function()
    local color
    log.info(is_active(), os.time())
    if (math.floor(os.time()) % 2)  == 0 then
      color = colors.red
    else
      color = colors.green
    end

    return {
      bold = is_active(),
      fg = color,
    }
  end

  return {
    {
      condition = is_active,
      hl = {
        fg = colors.orange,
        bg = colors.lightbg,
        bold = true,
        force = true,
      },
      component
    },
    {
      condition = function()
        return not is_active()
      end,
      component
    },
  }
  -- return {
  --   hl = function()
  --     return {bold = is_active()}
  --   end,
  --   component
  -- }
end

local statusline = {
  hl = { bg = colors.line_bg },
  require("vimrc.plugins.heirline.mode").ViMode,
  Space,
  require("vimrc.plugins.heirline.lsp").LSPActive,
  Space,
  -- require("vimrc.plugins.heirline.lsp").LSPMessages,
  require("vimrc.plugins.heirline.diagnostic").Diagnostics,
  Space,
  surround({ '[', ']' }, nil, require("vimrc.plugins.heirline.project").ProjectName),
  Space,
  require("vimrc.plugins.heirline.lsp").Gps,
  Align,
  require("vimrc.plugins.heirline.git").GitBranch,
  Space,
  require("vimrc.plugins.heirline.files").Ruler,
  require("vimrc.plugins.heirline.files").ScrollBar,
  Space,
  surround({ '[', ']' }, nil, require("vimrc.plugins.heirline.files").FileSize),
}
local winline = {
  hl = { bg = colors.line_bg },
  -- require("vimrc.plugins.heirline.files").FileType,
  -- TODO project name
  require("vimrc.plugins.heirline.files").FileNameBlock,
  Align,
  require("vimrc.plugins.heirline.git").GitChanges,
}


local winline_ignore_tree = {
  condition = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    return not bufname:match('NvimTree_%d+$')
  end,
  winline
}


heirline.setup(statusline, winline_ignore_tree)
