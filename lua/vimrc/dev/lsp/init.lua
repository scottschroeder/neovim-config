local usercmd = require("vimrc.config.mapping").cmd

usercmd("LspAttachThisBuffer", function()
  require("vimrc.dev.lsp.utils").reattach_if_lsp_lost()
end)

vim.cmd([[autocmd CursorHold,CursorHoldI,BufWritePost * :LspAttachThisBuffer]])
