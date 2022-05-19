local lsp_status = require('lsp-status')
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require'lspconfig'.gopls.setup{
    on_attach = require("vimrc.dev.attach").on_attach,
    capabilities = capabilities,
    -- capabilities = lsp_status.capabilities,
}
