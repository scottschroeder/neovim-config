local log = require("vimrc.log")

local ok, autosave = pcall(require, "auto-save")
if not ok then
  log.warn("auto-save.nvim not installed")
  return
end

autosave.setup({})
