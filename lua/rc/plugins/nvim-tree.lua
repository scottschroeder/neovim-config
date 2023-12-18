return {
  {
    "kyazdani42/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = true,
    keys = "<leader>k",
    config = function()
      local api = require("nvim-tree.api")

      local function toggle_builtin()
        api.tree.toggle { find_file = false, focus = true }
      end

      local map = require("rc.utils.map").map
      map("n", "<Leader>k", toggle_builtin, { desc = "NvimTree" })

      require("nvim-tree").setup {
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
  }
}
