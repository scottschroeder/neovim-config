local conditions = require("heirline.conditions")
local palette = require("rc.settings.color.palette")
local colors = palette.colors.simple

local M = {}

M.LSPActive = {
  condition = conditions.lsp_attached,

  -- You can keep it simple,
  -- provider = " [LSP]",

  -- Or complicate things a bit and get the servers names
  provider  = function()
    local names = {}
    local buf_clients = vim.lsp.get_clients({
      bufnr = 0
    })
    for i, server in pairs(buf_clients) do
      table.insert(names, server.name)
    end
    return " [" .. table.concat(names, " ") .. "]"
  end,
  hl        = function() return { fg = colors.green, bold = true } end,
}



-- TODO is this broken because lsp-status is out-of-date?
-- M.LSPMessages = {
--     provider = require("lsp-status").status,
--     hl = { fg = colors.gray },
-- }
--
M.Navic = {
  condition = function()
    local ok, navic = pcall(require, "nvim-navic")
    return ok and navic.is_available()
  end,
  provider = function()
    local ok, navic = pcall(require, "nvim-navic")
    if not ok then
      return ""
    end
    return navic.get_location()
  end,
  hl = function() return { fg = colors.gray0 } end,
}

return M
