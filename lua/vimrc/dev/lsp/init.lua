local usercmd = require("vimrc.config.mapping").cmd

-- severity_sort means that errors are reported before warnings and hints
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  severity_sort = true,
})
