

local function format_current_buffer()
  vim.lsp.buf.formatting_sync(nil, 100)
end

return {
    format_current_buffer=format_current_buffer
}
