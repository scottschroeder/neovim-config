local map = require("vimrc.config.mapping").map
local log = require("vimrc.log")


local function close_quickfix()
  log.trace("close quickfix buffer")
  vim.cmd([[cclose]])
end

local function severity_lsp_to_vim(severity)
  if type(severity) == 'string' then
    severity = vim.lsp.protocol.DiagnosticSeverity[severity]
  end
  return severity
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local get_diagnostics = function (opts)
  -- Opt handling from vim.lisp.diagnostic.set_qflist
  opts = opts or {}
  if opts.severity then
    opts.severity = severity_lsp_to_vim(opts.severity)
  elseif opts.severity_limit then
    opts.severity = {min=severity_lsp_to_vim(opts.severity_limit)}
  end

  if opts.client_id then
    opts.client_id = nil
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
  end

  local open = vim.F.if_nil(opts.open, true)
  local title = opts.title or "Diagnostics"
  local items = vim.diagnostic.toqflist(diagnostics)
  vim.fn.setqflist({}, ' ', {title=title, items=items})
  if open then 
    vim.api.nvim_command("copen")
  end
end

map("n", "<M-q>", magic_quickfix)

return {
  magic_quickfix = magic_quickfix,
  close_quickfix = close_quickfix,
}

