local map_prefix = require("rc.utils.map").prefix
local map = require("rc.utils.map").map

LOG("lsp init")
-- Generic LSP commands
map_prefix("<leader>l", "LSP")
map("n", "<leader>ls", ":LspInfo<CR>", { desc = "Info" })


-- severity_sort means that errors are reported before warnings and hints
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    severity_sort = true,
  }
)

local additional_servers = { "bashls", "dockerls", "dotls", "graphql", "jsonls", "terraformls", "pyright" }

for _, server_name in ipairs(additional_servers) do
  require('lspconfig')[server_name].setup {
    on_attach = require("lsp.attach").on_attach,
    capabilities = require("lsp.capabilities").capabilities,
  }
end

require("lsp.lang.golang")
