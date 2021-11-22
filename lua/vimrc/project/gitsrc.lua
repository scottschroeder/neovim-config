local fs = require("vimrc.project.fs")
local Job = require("plenary.job")
local log = require("vimrc.log")
local Path = require("plenary.path")
local List = require("vimrc.project.list").List


local M = {}

local function add_entry(project_dir)
  log.trace("add project:", project_dir)
  local p = Path:new(project_dir)
  log.trace("with path", tostring(p))
  local title = fs.get_name(p)
  log.trace("got title", title)

  M.list:add({
    path = project_dir,
    title = title,
  })
end

local function kickoff_fetch(base_dir)
  -- fd -H --base-directory ~/src --type d '\.git$' . -x echo {//}
  Job:new({
    command = "fd",
    args = {
      '-H',
      '--base-directory',
      base_dir,
      '--type',
      'd',
      '\\.git$',
      '.',
      '-x',
      'echo',
      '{//}'
    },
    on_exit=function(j, return_val)
      if return_val > 0 then
        -- log.warn("unable to run `fd`")
        return
      end
      for _, project in pairs(j:result()) do
        local project_dir = base_dir .. "/" .. project
        add_entry(project_dir)
      end
    end,
  }):start()
end


function M.init(root)
  M.list = List()
  pcall(kickoff_fetch, root)
end

function M.get_list()
  if M.list == nil then
    return {}
  end
  return M.list.items or {}
end

return M
