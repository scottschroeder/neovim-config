local log = require("vimrc.log")
local ok, nvimtree = pcall(require, "nvim-tree")

local function toggle_builtin()
  if ok then
    nvimtree.toggle(true)
  else
    log.warn("nvim-tree not found")
  end
end

local map = require("vimrc.config.mapping").map
map("n", "<Leader>k", toggle_builtin)

if ok then

  nvimtree.setup {
    auto_close = true,
    open_on_tab = true,
    update_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = false,
    },
    filters = {
      custom = {
        '.git', 'node_modules', '.cache'
      }
    }
  }

end
