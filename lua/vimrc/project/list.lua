local log = require("vimrc.log")
local Path = require("plenary.path")

local Entry = require("vimrc.project.class")(function(e, opts)
  opts = opts or {}
  e.path = Path:new(Path:new(opts.path):expand()):absolute()
  e.title = opts.title
end)

function Entry:get_title()
  if self.title then
    return self.title
  else
    return self.path
  end
end

function Entry:to_path()
  return Path:new(Path:new(self.path):expand())
end


function Entry:to_config()
  return {
    path = self.path,
    title = self.title,
  }
end

local List = require("vimrc.project.class")(function(l, data)
  data = data or {}
  local items = {}
  if data.items then
    for _, e in pairs(data.items) do
      items[#items+1] = Entry(e)
    end
  end

  l.source = data.source
  l.name = data.name or l.source
  l.sync = data.sync
  l.items = items
end)

function List:to_config()
  local items = {}
  for _, e in pairs(self.items) do
    items[#items+1] = e:to_config()
  end
  return {
    name = self.name,
    items = items,
  }
end

function List:sync_file(data_dir)
  return data_dir:joinpath(self.source .. ".json")
end

function List:add(data)
  self.items[#self.items+1] = Entry(data)
end

local function try_read_file(file)
  local ok, contents = pcall(file.read, file)
  if not ok then
    log.debug("file", tostring(file), "not found, using empty list")
    return {}
  end

  local res
  ok, res = pcall(vim.json.decode, contents)
  if not ok then
    log.warn("file", tostring(file), "did not contain valid json:", contents)
    return {}
  end
  return res
end

function List:load_file(data_dir, source)
  local sync_file = data_dir:joinpath(source .. ".json")
  local data = try_read_file(sync_file)
  data.source = source
  data.sync = true
  return List(data)
end

function List:do_sync(data_dir)
  local sync_path = self:sync_file(data_dir)
  log.trace("write", self.name, "(", self.source, ") to:", tostring(sync_path))
  sync_path:write(vim.json.encode(self:to_config()), 'w')
end


local Sources = require("vimrc.project.class")(function(s)
  s.sources = {}
end)

function Sources:add(list)
  assert(list:is_a(List), "item was not a list")
  self.sources[list.source] = list
end


function Sources:get_projects()
  local all_paths = {}
  for _, src in pairs(self.sources) do
    for _, entry in pairs(src.items) do
      all_paths[#all_paths+1] = entry
    end
  end
  table.sort(all_paths, function(a, b)
    return a.path > b.path
  end)
  return all_paths
end


return {
  Entry = Entry,
  List = List,
  Sources = Sources,
}
