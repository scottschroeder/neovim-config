local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local colors = require("vimrc.plugins.heirline.colors").colors

local M = {}

M.ProjectName = {
  init = function(self)
  end,
  condition = function(self)
    self.name = "PROJECTNAME"
    local entry = require("vimrc.project").get_existing_project_for_buf(0)
    if entry == nil then
      return false
    end

    self.name = entry.title
    return true
  end,
  provider = function(self)
    return self.name
  end
}

return M
