-- severity_sort means that errors are reported before warnings and hints
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  severity_sort = true,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local additional_servers = { "bashls", "dockerls", "dotls", "jsonls", "terraformls", "pyright" }

for _, server_name in ipairs(additional_servers) do
  require('lspconfig')[server_name].setup {
    on_attach = require("vimrc.dev.attach").on_attach,
    capabilities = capabilities,
    -- capabilities = lsp_status.capabilities,
  }
end
