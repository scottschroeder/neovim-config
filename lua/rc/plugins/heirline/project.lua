local M = {}

M.ProjectName = {
  init = function() end,
  condition = function()
    return false
    -- TODO
    -- self.name = "PROJECTNAME"
    -- local entry = require("vimrc.project").get_existing_project_for_buf(0)
    -- if entry == nil then
    --   return false
    -- end

    -- self.name = entry.title
    -- return true
  end,
  provider = function(self)
    return self.name
  end,
}

return M
