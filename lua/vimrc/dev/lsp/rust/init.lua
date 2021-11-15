local lsp_status = require('lsp-status')

-- https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
USER = vim.fn.expand('$USER')

local home = vim.fn.expand("$HOME")
local lspconfig = require('lspconfig')

local lsp_installer_servers = require'nvim-lsp-installer.servers'

local server_available, requested_server = lsp_installer_servers.get_server("rust_analyzer")
if server_available then

    requested_server:on_ready(function ()
        local opts = {
          on_attach = require("vimrc.dev.attach").on_attach,
          capabilities = lsp_status.capabilities,
          settings = {
            ["rust-analyzer"] = {
                  ["rust-analyzer.cargo.loadOutDirsFromCheck"]= true,
                  ["rust-analyzer.highlightingOn"]= true,
                  ["rust-analyzer.procMacro.enable"]= true,
                  checkOnSave = {
                    command = "clippy"
                  },
            }
          },
        }
        requested_server:setup(opts)
    end)
    if not requested_server:is_installed() then
        -- Queue the server to be installed
        requested_server:install()
    end
  end


