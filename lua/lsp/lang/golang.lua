-- local ok_inlay_hints, inlay_hints = pcall(require, "inlay-hints")

require('lspconfig').gopls.setup {
  on_attach = function(c, b)
    require("lsp.attach").on_attach(c, b)
    -- if ok_inlay_hints then
    --   inlay_hints.on_attach(c, b)
    -- end
  end,
  capabilities = require("lsp.capabilities").capabilities,
  settings = {
    gopls = {
      experimentalPostfixCompletions = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      }
    },
  },
}
