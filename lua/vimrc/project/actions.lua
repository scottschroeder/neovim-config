local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local transform_mod = require('telescope.actions.mt').transform_mod
local fs = require("vimrc.project.fs")


local M = {}
--
-- Extracts project path from current buffer selection
M.get_selected_path = function(prompt_bufnr)
  return actions_state.get_selected_entry(prompt_bufnr).value
end

-- Find files within the selected project using the
-- Telescope builtin `find_files`.
M.find_project_files = function(prompt_bufnr, hidden_files)
  local project_path = M.get_selected_path(prompt_bufnr)
  actions._close(prompt_bufnr, true)
  local cd_successful = fs.change_directory(project_path)
  if cd_successful then builtin.find_files({cwd = project_path, hidden = hidden_files}) end
end

return M
