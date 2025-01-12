-- local ok_inlay_hints, inlay_hints = pcall(require, "inlay-hints")

require('lspconfig').gopls.setup {
  on_attach = function(c, b)
    require("lsp.attach").on_attach(c, b)

    vim.api.nvim_create_autocmd("BufWritePre",
      {
        buffer = b,
        callback = function()
          local params = vim.lsp.util.make_range_params()
          params.context = { only = { "source.organizeImports" } }
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
          for _, res in pairs(result or {}) do
            for _, action in pairs(res.result or {}) do
              if action.edit then
                vim.lsp
                    .util.apply_workspace_edit(action.edit, "utf-8")
              end
            end
          end
        end,
      })
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
