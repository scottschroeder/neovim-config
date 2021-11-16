local log = require("vimrc.log")

local is_entry

local Entry = require("vimrc.project.class")(function(e, path)
  if is_entry(path) then
    log.trace("OK entry", path)
    e.path = path.path
  else
    log.trace("NOT entry", path)
    e.path = path
  end
end)

local function try_entry(o)
  return o:is_a(Entry)
end

is_entry = function(o)
  err, res = pcall(try_entry, o)
  log.trace("err", err, "res", res)
  return not error and res
end

function Entry:to_config()
  return {
    path = self.path,
  }
end

local List = require("vimrc.project.class")(function(l, data)
  local items = {}
  for k, e in pairs(data.items) do
    items[#items+1] = Entry(e)
  end

  l.source = data.source
  l.sync = data.sync
  l.items = items
end)

function List:to_config()
  local items = {}
  for k, e in pairs(self.items) do
    items[#items+1] = e:to_config()
  end
  return {
    source = self.source,
    items = items,
  }
end

function List:sync_file(data_dir)
  return data_dir:joinpath(self.source .. ".json")
end

function List:load_file(data_dir, source)
  local sync_file = data_dir:joinpath(source .. ".json")
  local data = vim.json.decode(sync_file:read())
  return List(data)
end

function List:do_sync(data_dir)
  self:sync_file(data_dir):write(vim.json.encode(self:to_config()), 'w')
end


local Sources = require("vimrc.project.class")(function(s)
  s.sources = {}
end)

function Sources:add(list)
  assert(list:is_a(List), "item was not a list")
  self.sources[list.source] = list
end


function Sources:get_all_paths()
  local all_paths = {}
  for k, src in pairs(self.sources) do
    for i, pth in pairs(src.items) do
      all_paths[#all_paths+1] = pth.path
    end
  end
  return all_paths
end


return {
  Entry = Entry,
  List = List,
  Sources = Sources,
}
