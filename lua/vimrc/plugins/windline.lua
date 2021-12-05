local log = require("vimrc.log")
local has_windline, windline = pcall(require, 'windline')

if not has_windline then
  log.warn("no windline")
  return
end

