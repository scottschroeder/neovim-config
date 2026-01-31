local log = require("rc.log")

-- local ok, heirline = require("vimrc.utils").safe_reloader("heirline")
-- if not ok then
--   return
-- end
local heirline = require("heirline")

local is_active = require("heirline.conditions").is_active
local buffer_matches = require("heirline.conditions").buffer_matches
local has_diagnostics = require("heirline.conditions").has_diagnostics
local is_git_repo = require("heirline.conditions").is_git_repo
local lsp_attached = require("heirline.conditions").lsp_attached

local utils = require("heirline.utils")
local surround = require("heirline.utils").surround

-- Set the statusbar to be the entire bottom line, not per-window
vim.opt.laststatus = 3

local palette = require("rc.settings.color.palette")
local colors = palette.colors.simple

local Align = { provider = "%=" }
local Space = { provider = " " }
local surround_round = { "", "" }
local forward_arrow = ""

local statusline = {
  hl = function() return { bg = palette.backgrounds()[3] } end,
  require("rc.plugins.heirline.mode").ViMode,
  Space,
  require("rc.plugins.heirline.lsp").LSPActive,
  Space,
  -- require("rc.plugins.heirline.lsp").LSPMessages,
  require("rc.plugins.heirline.diagnostic").Diagnostics,
  -- Space,
  -- surround({ '[', ']' }, nil, require("rc.plugins.heirline.project").ProjectName),
  Space,
  require("rc.plugins.heirline.lsp").Navic,
  Align,
  require("rc.plugins.heirline.git").GitBranch,
  Space,
  require("rc.plugins.heirline.files").Ruler,
  require("rc.plugins.heirline.files").ScrollBar,
  Space,
  surround({ '[', ']' }, nil, require("rc.plugins.heirline.files").FileSize),
}

local should_ignore_window = function()
  if buffer_matches({
        buftype = { "nofile", "prompt", "help", "quickfix" },
        filetype = { "^git.*", "fugitive" },
      }) then
    return true
  end

  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname:match('NvimTree_%d+$') then
    return true
  end

  local winconfig = vim.api.nvim_win_get_config(0)
  if winconfig.relative ~= "" then
    return true
  end

  return false
end

local winline = {
  fallthrough = false,
  {
    require("rc.plugins.heirline.files").FileType,
    Space,
    hl = function() return { bg = palette.backgrounds()[3] } end,
    require("rc.plugins.heirline.files").FileNameBlock,
    Align,
    require("rc.plugins.heirline.git").GitChanges,
  },
}

heirline.setup({
  statusline = statusline,
  winbar = winline,
  -- winline_ignore_tree = winline_ignore_tree,
  opts = {
    disable_winbar_cb = function(args)
      local bufname = vim.api.nvim_buf_get_name(0)

      if bufname:match('NvimTree_%d+$') then
        return true
      end

      local winconfig = vim.api.nvim_win_get_config(0)
      if winconfig.relative ~= "" then
        return true
      end

      local buf = args.buf
      local buftype = vim.tbl_contains(
        { "prompt", "nofile", "help", "quickfix" },
        vim.bo[buf].buftype
      )
      local filetype = vim.tbl_contains({ "gitcommit", "fugitive" }, vim.bo[buf].filetype)
      if buftype or filetype then
        return true
      end
      return false
    end,
  }
})
