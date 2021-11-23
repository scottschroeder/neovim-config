
local M = {}

function M.format_current_buffer()
  vim.lsp.buf.formatting_sync(nil, 100)
end

function M.format_range()
  vim.lsp.buf.range_formatting()
end

return M
