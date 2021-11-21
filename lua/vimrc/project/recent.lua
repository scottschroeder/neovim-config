local log = require("vimrc.log")
local Path = require("plenary.path")
local Entry = require("vimrc.project.list").Entry
local List = require("vimrc.project.list").List
local fs = require("vimrc.project.fs")

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

local M = {}

function M.init(data_dir)
  M.data_dir = data_dir
  M.load()
end

function M.save()
  M.list:do_sync(M.data_dir)
end

function M.load()
  M.list = List:load_file(M.data_dir, "recent")
  M.list.name = "Recent"
end

function M.check_add(path)
  local filepath = path:absolute()
  log.trace("do check_add", filepath)
  for _, entry in pairs(M.list.items) do
    if starts_with(filepath, entry.path) then
      log.trace("already saved", filepath, "is in", entry.path)
      return entry.path
    end
  end

  local project_dir = fs.associated_project(path)
  if not project_dir then
    log.trace("not a project:", filepath)
    return nil
  end
  log.trace("part of a new project:", project_dir)

  local title = fs.try_get_name(Path:new(project_dir))

  log.trace("try load")
  M.load()
  log.trace("did load")
  log.trace("adding", title, project_dir)
  M.list:add({
    path = project_dir,
    title = title,
  })
  log.trace("try save")
  M.save()
  return project_dir
end

return M
