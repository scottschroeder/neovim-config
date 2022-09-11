local log = require("vimrc.log")
local map = require("vimrc.config.mapping").map

local ok, dap_go = pcall(require, "dap-go")
if not ok then
  log.warn("dap-go not installed")
  return
end

local M = {}

dap_go.setup()

M.debug_test = function ()
  dap_go.debug_test()
end

return M

