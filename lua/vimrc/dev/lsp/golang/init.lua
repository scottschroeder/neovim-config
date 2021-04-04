local lsp_status = require('lsp-status')

require'lspconfig'.gopls.setup{
    on_attach = require("vimrc.dev.attach").on_attach,
    capabilities = lsp_status.capabilities,
}
