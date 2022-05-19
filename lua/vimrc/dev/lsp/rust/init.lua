local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require('lspconfig')

lspconfig.rust_analyzer.setup{
      on_attach = require("vimrc.dev.attach").on_attach,
      capabilities = capabilities,
    -- capabilities = lsp_status.capabilities,
}

      -- settings = {
      --   ["rust-analyzer"] = {
      --         ["rust-analyzer.cargo.loadOutDirsFromCheck"]= true,
      --         ["rust-analyzer.highlightingOn"]= true,
      --         ["rust-analyzer.procMacro.enable"]= true,
      --         checkOnSave = {
      --           command = "clippy"
      --         },
      --   }
      -- },
