local log = require("vimrc.log")
local ok, mason = pcall(require, "mason")
if not ok then
  log.warn("mason not installed")
  return
end
local ok, mason_lsp_config = pcall(require, "mason-lspconfig")
if not ok then
  log.warn("mason-lspconfig not installed")
  return
end

mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

mason_lsp_config.setup({
  ensure_installed = { "lua_ls", "rust_analyzer", "gopls"}
})
