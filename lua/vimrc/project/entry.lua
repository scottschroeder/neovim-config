local log = require("vimrc.log")
local Path = require("plenary.path")

local Entry = require("vimrc.project.class")(function(e, opts)
  opts = opts or {}
  e.path = Path:new(Path:new(opts.path):expand()):absolute()
  e.title = opts.title
  e.source = opts.source or "unknown"
  e.time = opts.time or 0
end)

function Entry:get_title()
  if self.title then
    return self.title
  else
    return self.path
  end
end

function Entry:to_path()
  return Path:new(self.path)
end

function Entry:to_config()
  return {
    path = self.path,
    title = self.title,
    source = self.source,
    time = self.time,
  }
end

return Entry
