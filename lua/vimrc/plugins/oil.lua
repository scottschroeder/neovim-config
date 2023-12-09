local log = require("vimrc.log")
local ok, oil = pcall(require, "oil")
if not ok then
  log.warn("oil not installed")
  return
end

-- i want oil to not confirm twice

oil.setup({
  columns = {
    "icon",
    -- "permissions",
    -- "size",
    -- "mtime",
  },
  view_options = {
    show_hidden = true,
  }
})

local map = require("vimrc.config.mapping").map
map("n", "<Leader>fd", function()
  oil.open_float(oil.get_current_dir())
end, { desc = "Oil Open Buffer Directory" })
map("n", "<Leader>fp", function()
  local project = require("vimrc.project")
  local entry = project.get_existing_project_for_buf(0)
  if entry == nil then
    log.warn("no project found")
    oil.open_float(oil.get_current_dir())
    return
  end
  oil.open_float(entry.path)
end, { desc = "Oil Open Project" })
