local finders = require("telescope.finders")

local strings = require("plenary.strings")
local entry_display = require("telescope.pickers.entry_display")

local M = {}


local function display_source(project)
  local src = project.source or "unknown"
  return "[" .. src .. "]"
end

function M.project_finder(opts, projects, precedence)
  precedence = precedence or {}

  local entry_merger = function(a, b)
    if a == nil then
      return b
    end
    if b == nil then
      return a
    end
    local time = math.max(a.time, b.time)
    a.time = time
    b.time = time
    for _, pri in pairs(precedence) do
      if a.source == pri then
        return a
      end
      if b.source == pri then
        return b
      end
    end
    return b
  end

  local widths = {
    title = 0,
    source = 0,
  }

  local dedup_projects = {}

  -- Loop over all of the projects and find the maximum length of
  -- each of the keys
  for _, entry in pairs(projects) do

    local project_display = {
      title = entry:get_title(),
      source = display_source(entry),
    }
    for key, value in pairs(widths) do
      widths[key] = math.max(value, strings.strdisplaywidth(project_display[key] or ''))
    end


    dedup_projects[entry.path] = entry_merger(dedup_projects[entry.path], entry)
  end

  local project_list = {}
  for _, e in pairs(dedup_projects) do
    project_list[#project_list+1] = e
  end

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = widths.title },
      { width = widths.source },
    }
  }

  local make_display = function(project)
    return displayer {
      { project.title },
      { display_source(project) }
    }
  end

  return finders.new_table {
      results = project_list,
      entry_maker = function(project)
        project.value = project.path
        project.ordinal = project:get_title()
        project.display = make_display
        return project
      end,
    }
end

return M
