-- local ok_inlay_hints, inlay_hints = pcall(require, "inlay-hints")
--
local do_import_on_save = true

vim.lsp.config('gopls', {
  on_attach = function(c, b)
    require("lsp.attach").on_attach(c, b)
    local buf_map = require('rc.utils.map').buf_map

    local toggle_import_on_save = function()
      do_import_on_save = not do_import_on_save
      if do_import_on_save then
        vim.notify("Organize imports on save: ON")
      else
        vim.notify("Organize imports on save: OFF")
      end
    end

    buf_map(b, "n", "<leader>li", toggle_import_on_save, { desc = "Toggle organize imports on save" })

    vim.api.nvim_create_autocmd("BufWritePre",
      {
        buffer = b,
        callback = function()
          if not do_import_on_save then
            return
          end
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
      gofumpt = true,
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
})
vim.lsp.enable('gopls')
