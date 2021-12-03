local fs = require("vimrc.project.fs")

local M = {}

function M.init()
  M.sources = {}
end

function M.add(func)
  M.sources[#M.sources+1] = func
end

function M.get_projects()
  local all_paths = {}
  for _, gen_src in pairs(M.sources) do
    for _, entry in pairs(gen_src()) do
      all_paths[#all_paths+1] = entry
    end
  end
  table.sort(all_paths, function(a, b)
    return a.path > b.path
  end)
  return all_paths
end

function M.find_entry(path)
  local best_match = nil
  local longest_match = 0
  for _, gen_src in pairs(M.sources) do
    for _, entry in pairs(gen_src()) do
      if fs.is_sub_folder(path, entry.path) then
        if #entry.path > longest_match then
          longest_match = #entry.path
          best_match = entry
        end
      end
    end
  end
  return best_match
end

return M

