local gen_cap = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  local blink_ok, blink_cmp = pcall(require, "blink.cmp")
  if blink_ok then
    blink_cmp.get_lsp_capabilities(capabilities)
  end

  return capabilities
end

return {
  capabilities = gen_cap(),
}
