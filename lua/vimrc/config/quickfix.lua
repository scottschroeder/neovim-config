local map = require("vimrc.config.mapping").map
local log = require("vimrc.log")


local open_quickfix = function ()
    vim.api.nvim_command("botright cwindow")
end

local function close_quickfix()
  vim.cmd([[cclose]])
end

local function severity_lsp_to_vim(severity)
  if type(severity) == 'string' then
    severity = vim.lsp.protocol.DiagnosticSeverity[severity]
  end
  return severity
end

local get_diagnostics = function (opts)
  -- Opt handling from vim.lisp.diagnostic.set_qflist
  opts = opts or {}
  if opts.severity then
    opts.severity = severity_lsp_to_vim(opts.severity)
  elseif opts.severity_limit then
    opts.severity = {min=severity_lsp_to_vim(opts.severity_limit)}
  end

  if not opts.client_id then
    local buf_clients = vim.lsp.buf_get_clients(0)
    for k, _ in pairs(buf_clients) do
      opts.namespace = vim.lsp.diagnostic.get_namespace(k)
      break
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

local magic_quickfix = function (opts)
  log.trace("run magic quickfix")
  if is_open() then
    close_quickfix()
    return
  end

  opts = opts or {}

  local errors = get_diagnostics({severity = vim.diagnostic.severity.ERROR})
  local diagnostics = {}
  if next(errors) ~= nil then
    diagnostics = errors
  else
    diagnostics = get_diagnostics({})
  end
  if next(diagnostics) == nil then
    close_quickfix()
    return
  end

  local open = vim.F.if_nil(opts.open, true)
  local title = opts.title or "Diagnostics"
  local items = vim.diagnostic.toqflist(diagnostics)
  vim.fn.setqflist({}, ' ', {title=title, items=items})
  if open then 
    open_quickfix()
  end
end


map("n", "<M-q>", magic_quickfix)

return {
  magic_quickfix = magic_quickfix,
  open_quickfix = open_quickfix,
  close_quickfix = close_quickfix,
}

