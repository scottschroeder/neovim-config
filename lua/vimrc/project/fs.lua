local log = require("vimrc.log")
local Path = require("plenary.path")

local M = {}

local github_re = vim.regex("github.com/[^/]\\+/[^/]\\+")

local function github_name(path)
    
    log.trace("attempt to name:", tostring(path))
    local gitconfig = Path:new(path:absolute() .. "/.git/config")
    for _, line in pairs(gitconfig:readlines()) do
      local s, e = github_re:match_str(line)
      if s then
        local offset = #"github.com/"
        return line:sub(s+1+offset, e)
      end
    end
  return nil
end

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

function M.associated_project(path)
  local base = Path:new(path:expand())
  if base:is_dir() then
    base = base:parent()
  end
  for _, current in pairs(base:parents()) do

    local gitdir = Path:new(current .. "/.git")
    if gitdir:exists() then
      return current
    end

    local hgdir = Path:new(current .. "/.hg")
    if hgdir:exists() then
      return current
    end
  end
  return nil
end


function M.try_get_name(path)
  local name = github_name(path)
  if name then return name end
  return nil
end

return M
