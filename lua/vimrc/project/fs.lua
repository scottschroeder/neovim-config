local log = require("vimrc.log")
local Path = require("plenary.path")

local M = {}

function M.change_directory(path)
  path = Path:new(path)
  if path:exists() then
    vim.fn.execute("cd " .. tostring(path:absolute()), "silent")
    return true
  else
    log.warn("path does not exist", path)
    return false
  end
end



return M
