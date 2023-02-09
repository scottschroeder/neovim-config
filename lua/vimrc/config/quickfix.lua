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
  opts = opts or {}

  -- Extract a few options to select behavior
  local toggle = vim.F.if_nil(opts.toggle, true)
  local force_diagnostics = vim.F.if_nil(opts.force_diagnostics, false)
  local open = vim.F.if_nil(opts.open, true)

  -- close qf if its open
  if toggle and is_open() then
    close_quickfix()
    return
  end

  -- if qf has items, open qf
  if not force_diagnostics then
    local old_items = vim.fn.getqflist()
    if #old_items > 0 then
      if open then
        open_quickfix()
      end
      return
    end
  end

  -- Fetch diagnostics: Try errors only first, but then fallback to all diagnostics.
  local errors = get_diagnostics({severity = vim.diagnostic.severity.ERROR})
  local diagnostics = {}
  if next(errors) ~= nil then
    diagnostics = errors
  else
    diagnostics = get_diagnostics({})
  end

  -- If there is nothing to display, close qf
  if next(diagnostics) == nil then
    close_quickfix()
    return
  end

  -- Set the qf to our diagnostics
  local title = opts.title or "Diagnostics"
  local items = vim.diagnostic.toqflist(diagnostics)
  vim.fn.setqflist({}, ' ', {title=title, items=items})
  if open then
    open_quickfix()
  end
end

local diagnostic_quickfix = function (opts)
  opts = opts or {}
  opts["force_diagnostics"] = true
  magic_quickfix(opts)
end

map("n", "<M-q>", magic_quickfix, { desc = "Magic Quickfix" })
map("n", "<C-q>", diagnostic_quickfix, { desc = "Diagnostic Quickfix" })

return {
  magic_quickfix = magic_quickfix,
  open_quickfix = open_quickfix,
  close_quickfix = close_quickfix,
}

