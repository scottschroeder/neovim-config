
local blacklist_buffer_var_name = "blacklist_this_buffer_from_reloads"

local is_lsp_connected = function(bufnr)
  return #vim.lsp.buf_get_clients(bufnr) > 0
end

local active_client = function()
  local buf_ft = vim.api.nvim_buf_get_option(0,'filetype')
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return nil
  end

  for _,client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes,buf_ft) ~= -1 then
      return client.id
    end
  end
  return nil
end

local is_buf_blacklisted = function(bufnr)
  local ok, val = pcall(vim.api.nvim_buf_get_var, bufnr, blacklist_buffer_var_name)
  return ok and val == true
end


local reattach_if_lsp_lost = function()
  if is_buf_blacklisted(0) then
    return
  end

  if is_lsp_connected() then
    return
  end

  local cid = active_client()
  if cid == nil then
    return
  end

  vim.lsp.buf_attach_client(0,cid)
  if not is_lsp_connected() then
    print("failed to attach to LSP client!")
    vim.api.nvim_buf_set_var(0, blacklist_buffer_var_name, true)
  end
end

return {
  reattach_if_lsp_lost = reattach_if_lsp_lost,
  is_buf_blacklisted = is_buf_blacklisted,
}
