return {
  "mrcjkb/rustaceanvim",
  version = "^4", -- Recommended
  lazy = false, -- This plugin is already lazy
  config = function()
    local buf_map = require("rc.utils.map").buf_map
    local capabilities = require("lsp.capabilities").capabilities

    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {},
      -- LSP configuration
      server = {
        on_attach = function(client, bufnr)
          require("lsp.attach").on_attach(client, bufnr)
          buf_map(bufnr, { "n", "v" }, "gD", function()
            vim.cmd.RustLsp("openDocs")
          end, { desc = "Open Rust Documentation" })

          local function remove_unused_imports()
            -- Create a range covering the entire file
            local params = vim.lsp.util.make_range_params()
            params.context = { only = { "source.removeUnusedImports" } }

            -- Request code actions synchronously
            local responses = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
            if not responses or vim.tbl_isempty(responses) then
              return
            end

            -- Apply the first matching "removeUnusedImports" action we find
            for client_id, res in pairs(responses) do
              for _, action in pairs(res.result or {}) do
                if action.edit then
                  vim.lsp.util.apply_workspace_edit(action.edit, client_id)
                end
                if action.command then
                  vim.lsp.buf.execute_command(action.command)
                end
              end
            end
          end

          buf_map(bufnr, { "n", "v" }, "<Leader>lai", remove_unused_imports, { desc = "remove unused imports" })
        end,
        capabilities = capabilities,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            assist = {
              importGranularity = "crate",
              importPrefix = "self",
            },
            imports = {
              granularity = {
                group = "crate",
              },
              prefix = "self",
            },
            cargo = {
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            procMacro = {
              enable = true,
            },
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      },
      -- DAP configuration
      dap = {
        -- adapter = require('rust-tools.dap').get_codelldb_adapter(
        --   codelldb_path, liblldb_path)
      },
    }
  end,
}
