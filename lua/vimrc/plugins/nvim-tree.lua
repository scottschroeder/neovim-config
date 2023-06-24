local log = require("vimrc.log")
local ok, nvimtree = pcall(require, "nvim-tree")
if not ok then
  log.warn("could not load module:", "nvim-tree")
  return
end

local api = require("nvim-tree.api")

local function toggle_builtin()
  api.tree.toggle { find_file = false, focus = true }
end

local map = require("vimrc.config.mapping").map
map("n", "<Leader>k", toggle_builtin, { desc = "NvimTree" })

if ok then
  nvimtree.setup {
    update_cwd          = true,
    respect_buf_cwd     = true,
    update_focused_file = {
      enable = true,
      update_cwd = false,
    },
    filters             = {
      -- custom = {
      --   '\\.git', 'node_modules', '\\.cache'
      -- }
    },
    actions             = {
      open_file = {
        window_picker = {
          -- ENABLE TO ASK WHICH WINDOW
          enable = false,
        }
      }
    },
    renderer            = {
      highlight_git = true,
    },
    diagnostics         = {
      enable = true,
    }
  }
end
