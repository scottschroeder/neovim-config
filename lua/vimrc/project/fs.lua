local log = require("vimrc.log")
local Path = require("plenary.path")

local M = {}



function M.extract_name(config_line)
  local s, e = config_line:find("github.com/[^/]+/[^/]+")
  if s then
    local offset = #"github.com/"
    return config_line:sub(s+offset, e)
  end
  return nil
end

local function read_remote(config_line)
  local s, e = config_line:find('\[remote ""')

end

function M.github_name(path)
  log.trace("attempt to name:", tostring(path))
  local gitconfig = Path:new(path:absolute() .. "/.git/config")
  local ok, lines = pcall(Path.readlines,gitconfig)
  if not ok then
    return nil
  end
  for _, line in pairs(lines) do
    local res = M.extract_name(line)
    if res ~= nil then
      return res
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
  -- log.trace("trygetname", tostring(path))
  local name = M.github_name(path)
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
