local log = require("vimrc.log")
local map = require("vimrc.config.mapping").map
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local ok, mason_path = pcall(require, "mason-core.path")
if not ok then
  log.warn("mason-core not installed")
  return
end

local extension_path = mason_path.package_prefix("codelldb") .. "/extension"
local codelldb_path = extension_path .. '/adapter/codelldb'
local liblldb_path = extension_path .. '/lldb/lib/liblldb.so'

-- log.debug("codelldb", codelldb_path)
-- log.debug("lib", liblldb_path)
-- local adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
-- log.debug("adapter", adapter)

local opts = {
  tools = {
    hover_with_actions = false,
  },
  server = {
    on_attach = function(...)
      require("vimrc.dev.attach").on_attach(...)
      map({ "n", "v" }, "gD", ":RustOpenExternalDocs<CR>", { desc = "Open Rust Documentation" })
    end,
    capabilities = capabilities,
    settings = {
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
            enable = true
          },
        },
        procMacro = {
          enable = true
        },
        checkOnSave = {
          command = "clippy"
        },
      }
    },
  },
  dap = {
    adapter = require('rust-tools.dap').get_codelldb_adapter(
      codelldb_path, liblldb_path)
  }
}


require('rust-tools').setup(opts)
