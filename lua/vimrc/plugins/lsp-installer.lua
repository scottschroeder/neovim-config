local log = require("vimrc.log")
local ok, nvim_lsp_installer = pcall(require, "nvim-lsp-installer")
if not ok then
  log.warn("lsp installer not installed")
  return
end

nvim_lsp_installer.setup({
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
})
