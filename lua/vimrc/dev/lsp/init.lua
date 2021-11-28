local usercmd = require("vimrc.config.mapping").cmd

usercmd("LspAttachThisBuffer", function()
  require("vimrc.dev.lsp.utils").reattach_if_lsp_lost()
end)

-- severity_sort means that errors are reported before warnings and hints
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  severity_sort = true,
})

-- vim.cmd([[autocmd CursorHold,CursorHoldI,BufWritePost * :LspAttachThisBuffer]])
