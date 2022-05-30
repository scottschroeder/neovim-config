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
    update_cwd          = true,
    respect_buf_cwd     = true,
    update_focused_file = {
      enable = true,
      update_cwd = false,
    },
    filters             = {
      custom = {
        '.git', 'node_modules', '.cache'
      }
    },
    actions = {
      open_file = {
        window_picker = {
          -- ENABLE TO ASK WHICH WINDOW
          enable = false,
        }
      }
    },
    view                = {
      signcolumn = "no",
    },
    renderer = {
      highlight_git = true,
    },
    diagnostics = {
      enable = true,
    }
  }

end
