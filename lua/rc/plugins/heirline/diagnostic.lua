local conditions = require("heirline.conditions")
local palette = require("rc.settings.color.palette")

local M = {}

-- TODO this should be set already, we shouldn't need to default
local function get_defined_sign_or(name, default)
  local sign_info = vim.fn.sign_getdefined(name)
  if sign_info and #sign_info > 1 then
    return sign_info[1].text
  end
  return default
end

local function append_space_if(text, condition)
  if condition then
    return text .. " "
  else
    return text
  end
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

    self.infospace = self.hints > 0
    self.warnspace = self.info > 0 or self.infospace
    self.errorspace = self.warnings > 0 or self.warnspace

  end,

  {
    provider = "[",
  },
  {
    provider = function(self)
      return not conditions.has_diagnostics() and self.healthy_icon
    end,
    hl = function() return { fg = palette.diagnostic().healthy, bold = true } end,
  },
  {
    provider = function(self)
      -- 0 is just another output, we can decide to print it or not!
      return self.errors > 0 and (append_space_if(self.error_icon .. self.errors, self.errorspace))
    end,
    hl = function() return { fg = palette.diagnostic().error } end,
  },
  {
    provider = function(self)
      return self.warnings > 0 and (append_space_if(self.warn_icon .. self.warnings, self.warnspace))
    end,
    hl = function() return { fg = palette.diagnostic().warn } end,
  },
  {
    provider = function(self)
      return self.info > 0 and (append_space_if(self.info_icon .. self.info, self.infospace))
    end,
    hl = function() return { fg = palette.diagnostic().info } end,
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = function() return { fg = palette.diagnostic().hint } end,
  },
  {
    provider = "]",
  },
}

return M
