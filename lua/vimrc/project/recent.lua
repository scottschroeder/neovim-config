local log = require("vimrc.log")
local Path = require("plenary.path")
local List = require("vimrc.project.list")
local fs = require("vimrc.project.fs")

local M = {}

function M.init(data_dir)
  M.data_dir = data_dir
  M.load()
  M.trim()
  M.save()
end

function M.trim()
  local new_data = {}
  for _, e in pairs(M.list.items) do
    if e:to_path():exists() then
      new_data[#new_data+1] = e
    end
    M.list.items = new_data
  end
end

function M.save()
  M.list:do_sync(M.data_dir)
end

function M.load()
  M.list = List:load_file(M.data_dir, "recent")
  M.list.name = "Recent"
end

function M.get_list()
  M.load()
  return M.list.items
end

function M.check_add(path)
  local filepath = path:absolute()
  log.trace("do check_add", filepath)
  for _, entry in pairs(M.list.items) do
    if fs.is_sub_folder(filepath, entry.path) then
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

  local title = fs.get_name(Path:new(project_dir))

  log.trace("try load")
  M.load()
  log.trace("did load")
  log.trace("adding", title, project_dir)
  M.list:add({
    path = project_dir,
    title = title,
    source = "recent",
  })
  log.trace("try save")
  M.save()
  return project_dir
end

return M
