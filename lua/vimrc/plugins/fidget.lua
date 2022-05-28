
local log = require("vimrc.log")

local ok, fidget = pcall(require, "fidget")
if not ok then
  log.warn("could not load module:", "fidget")
  return
end

fidget.setup({})
