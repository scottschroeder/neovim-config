local log = require("vimrc.log")

local ok, autoclose = pcall(require, "autoclose")
if not ok then
  log.warn("could not load module:", "autoclose")
  return
end

autoclose.setup({})
