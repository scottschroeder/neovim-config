local log = require("vimrc.log")
local Entry = require("vimrc.project.entry")

local List = require("vimrc.project.class")(function(l, data)
  data = data or {}
  local items = {}
  if data.items then
    for _, e in pairs(data.items) do
      items[#items+1] = Entry(e)
    end
  end

  l.source = data.source
  l.items = items
end)

function List:to_config()
  local items = {}
  for _, e in pairs(self.items) do
    items[#items+1] = e:to_config()
  end
  return {
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
  return List(data)
end

function List:do_sync(data_dir)
  local sync_path = self:sync_file(data_dir)
  log.trace("write", self.source, "to:", tostring(sync_path))
  sync_path:write(vim.json.encode(self:to_config()), 'w')
end


return List
