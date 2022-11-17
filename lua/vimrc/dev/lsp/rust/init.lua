local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Instead of
-- lspconfig.rust_analyzer.setup { ... }
-- We use rust-tools, and place all expected args under `server = {...}`

require('rust-tools').setup({
  tools = {
    hover_with_actions = false,
  },
  server = {
    on_attach = require("vimrc.dev.attach").on_attach,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importGranularity = "crate",
          importPrefix = "self",
        },
        cargo = {
          loadOutDirsFromCheck = true
        },
        procMacro = {
          enable = true
        },
        checkOnSave = {
          command = "clippy"
        },
      }
    },
  }
})
