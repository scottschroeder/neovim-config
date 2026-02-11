local gen_cap = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  if vim.lsp.config and not vim.lsp.config["*"] then
    vim.lsp.config("*", {})
  end

  local blink_ok, blink_cmp = pcall(require, "blink.cmp")
  if blink_ok then
    capabilities = blink_cmp.get_lsp_capabilities(capabilities)
  end

  return capabilities
end

return {
  capabilities = gen_cap(),
}
