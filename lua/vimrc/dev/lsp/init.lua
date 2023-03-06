local map_prefix = require("vimrc.config.mapping").prefix
local map = require("vimrc.config.mapping").map

-- Generic LSP commands
map_prefix("<leader>l", "LSP")
map("n", "<leader>ls", ":LspInfo<CR>", {desc = "Info"})
map("n", "<leader>lr", ":LspRestart<CR>", {desc = "Restart"})


-- severity_sort means that errors are reported before warnings and hints
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  severity_sort = true,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local additional_servers = { "bashls", "dockerls", "dotls", "graphql", "jsonls", "terraformls", "pyright" }

for _, server_name in ipairs(additional_servers) do
  require('lspconfig')[server_name].setup {
    on_attach = require("vimrc.dev.attach").on_attach,
    capabilities = capabilities,
    -- capabilities = lsp_status.capabilities,
  }
end
