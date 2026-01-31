local show_diagnostics = true
local virtual_lines = false

local set_diagnostic_display = function(opts)
  opts = opts or {}

  local enabled = vim.F.if_nil(opts.enabled, true)
  local line_mode = vim.F.if_nil(opts.virtual_lines, false)

  if not enabled then
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = false,
    })
  else
    vim.diagnostic.config({
      virtual_text = not line_mode,
      virtual_lines = line_mode,
    })
  end
end


local update_diagnostic_display = function()
  set_diagnostic_display({
    enabled = show_diagnostics,
    virtual_lines = virtual_lines,
  })
end


local toggle_diagnostics = function()
  show_diagnostics = not show_diagnostics
  update_diagnostic_display()
end

local toggle_line_mode = function()
  virtual_lines = not virtual_lines
  update_diagnostic_display()
end

local set_line_mode = function(enabled)
  virtual_lines = enabled
  update_diagnostic_display()
end

local setup = function(opts)
  opts = opts or {}
  show_diagnostics = vim.F.if_nil(opts.enabled, true)
  virtual_lines = vim.F.if_nil(opts.virtual_lines, false)

  update_diagnostic_display()
end


return {
  toggle_diagnostics = toggle_diagnostics,
  toggle_line_mode = toggle_line_mode,
  set_line_mode = set_line_mode,
  setup = setup,
}
