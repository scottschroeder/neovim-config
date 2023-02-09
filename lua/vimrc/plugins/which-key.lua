local log = require("vimrc.log")
local ok, whichkey = pcall(require, "which-key")
if not ok then
  log.warn("unable to load whichkey")
  return
end

vim.o.timeout = true
vim.o.timeoutlen = 300
-- neighbors
whichkey.setup({
  plugins = {
    spelling = {
      enabled = true
    }
  }
})

