local conditions = require("heirline.conditions")
local colors = require("vimrc.plugins.heirline.colors").colors

local M = {}

-- TODO this should be set already, we shouldn't need to default
local function get_defined_sign_or(name, default)
    local sign_info = vim.fn.sign_getdefined(name)
    if sign_info and #sign_info > 1 then
      return sign_info[1].text
    end
    return default
end

M.Diagnostics = {

  -- condition = conditions.has_diagnostics,

  static = {
    error_icon = get_defined_sign_or("DiagnosticSignError", ""),
    warn_icon = get_defined_sign_or("DiagnosticSignWarn", ""),
    info_icon = get_defined_sign_or("DiagnosticSignInfo", ""),
    hint_icon = get_defined_sign_or("DiagnosticSignHint", ""),
    healthy_icon = "",
  },

  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,

  {
    provider = "[",
  },
  {
    provider = function(self)
      return not conditions.has_diagnostics() and self.healthy_icon
    end,
    hl = { fg = colors.diag.healthy, bold = true },
  },
  {
    provider = function(self)
      -- 0 is just another output, we can decide to print it or not!
      return self.errors > 0 and (self.error_icon .. self.errors .. " ")
    end,
    hl = { fg = colors.diag.error },
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
    end,
    hl = { fg = colors.diag.warn },
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info .. " ")
    end,
    hl = { fg = colors.diag.info },
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = { fg = colors.diag.hint },
  },
  {
    provider = "]",
  },
}

return M
