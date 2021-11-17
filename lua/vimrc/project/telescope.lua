local log = require("vimrc.log")
local finders = require("telescope.finders")
local Path = require("plenary.path")

local strings = require("plenary.strings")
local entry_display = require("telescope.pickers.entry_display")

local M = {}

function M.project_finder(opts, projects)
  local display_type = opts.display_type
  local widths = {
    title = 0,
    display_path = 0,
  }

  -- Loop over all of the projects and find the maximum length of
  -- each of the keys
  for _, entry in pairs(projects) do
    local project_path = entry:to_path()
    log.trace("path", project_path)
    local project_display = {
      title = entry:get_title(),
      path = tostring(project_path),
      display_path = '',
    }
    if display_type == 'full' then
      project_display.display_path = '[' .. project_display.path .. ']'
    end
    local project_path_exists = project_path:exists()
    log.trace("check exist", tostring(project_path), project_path_exists)
    if not project_path_exists then
      project_display.title = project_display.title .. " [deleted]"
    end
    for key, value in pairs(widths) do
      widths[key] = math.max(value, strings.strdisplaywidth(project_display[key] or ''))
    end
  end

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = widths.title },
      { width = widths.display_path },
    }
  }
  local make_display = function(project)
    return displayer {
      { project.title },
      { project.display_path }
    }
  end

  return finders.new_table {
      results = projects,
      entry_maker = function(project)
        project.value = tostring(project:to_path())
        project.ordinal = project:get_title()
        project.display = make_display
        log.trace("show project entry", project)
        return project
      end,
    }
end

return M
