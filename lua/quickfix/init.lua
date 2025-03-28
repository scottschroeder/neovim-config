local map = require("rc.utils.map").map
local log = require("rc.log")


local open_quickfix = function()
  vim.api.nvim_command("botright cwindow")
end

local function close_quickfix()
  vim.cmd([[cclose]])
end

local function set_qf_open_if_content()
  local qfitems = vim.fn.getqflist()
  if #qfitems > 0 then
    open_quickfix()
  else
    close_quickfix()
  end
end

local function severity_lsp_to_vim(severity)
  if type(severity) == 'string' then
    severity = vim.lsp.protocol.DiagnosticSeverity[severity]
  end
  return severity
end

local get_diagnostics = function(opts)
  -- Opt handling from vim.lisp.diagnostic.set_qflist
  opts = opts or {}
  if opts.severity then
    opts.severity = severity_lsp_to_vim(opts.severity)
  elseif opts.severity_limit then
    opts.severity = { min = severity_lsp_to_vim(opts.severity_limit) }
  end

  if not opts.client_id then
    local buf_clients = vim.lsp.get_clients({
      bufnr = 0
    })
    for k, c in pairs(buf_clients) do
      if c["name"] ~= "copilot" then
        opts.namespace = vim.lsp.diagnostic.get_namespace(k)
        break
      else
      end
    end
  else
    opts.namespace = vim.lsp.diagnostic.get_namespace(opts.client_id)
  end

  local workspace = vim.F.if_nil(opts.workspace, true)
  opts.bufnr = not workspace and 0

  local diagnostics = vim.diagnostic.get(nil, opts)
  return diagnostics
end

local get_win_info = function(qftype)
  local ll = qftype == "l" and 1 or 0
  for _, info in ipairs(vim.fn.getwininfo()) do
    if info.quickfix == 1 and info.loclist == ll then
      return info
    end
  end
  return nil
end

local is_open = function(qftype)
  return get_win_info(qftype) ~= nil
end

local load_diagnostics_to_quickfix = function()
  -- Fetch diagnostics: Try errors only first, but then fallback to all diagnostics.
  local errors = get_diagnostics({ severity = vim.diagnostic.severity.ERROR })
  local diagnostics = {}
  if next(errors) ~= nil then
    diagnostics = errors
  else
    diagnostics = get_diagnostics({})
  end

  vim.fn.setqflist({}, ' ', { title = "", items = {} })

  if #diagnostics == 0 then
    return
  end

  local title = "Diagnostics"
  local items = vim.diagnostic.toqflist(diagnostics)
  vim.fn.setqflist({}, ' ', { title = title, items = items })
end

local toggle_quickfix = function(opts)
  log.trace("run magic quickfix")
  opts = opts or {}

  -- Extract a few options to select behavior
  local toggle = vim.F.if_nil(opts.toggle, true)

  -- close qf if its open
  if toggle and is_open() then
    close_quickfix()
    return
  end

  -- if qf has items, open qf
  local prev_qf = vim.fn.getqflist()
  if #prev_qf == 0 then
    load_diagnostics_to_quickfix()
  end

  set_qf_open_if_content()
end


local diagnostic_quickfix = function()
  load_diagnostics_to_quickfix()
  set_qf_open_if_content()
end



return {
  magic_quickfix = toggle_quickfix,
  open_quickfix = open_quickfix,
  close_quickfix = close_quickfix,
  diagnostic_quickfix = diagnostic_quickfix,
}
