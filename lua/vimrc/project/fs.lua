local log = require("vimrc.log")
local Path = require("plenary.path")
local gitutil = require("vimrc.project.gitutil")

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
  local name = gitutil.parse_repo_name_from_git_path(path:absolute())
  if name then return name end
  return nil
end


function M.get_name(path)
  local name = M.try_get_name(path)
  if name then return name end
  local components = vim.split(path:absolute(), "/")
  return components[#components]
end

return M
