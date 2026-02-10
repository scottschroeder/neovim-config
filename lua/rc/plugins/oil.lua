return {
  "stevearc/oil.nvim",
  -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  config = function()
    local oil = require("oil")

    oil.setup({
      skip_confirm_for_simple_edits = true,
      win_options = {
        wrap = true,
      },
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-r>"] = "actions.refresh",
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _bufnr)
          return name == ".."
        end,
      },
    })

    local map = require("rc.utils.map").map

    map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
}
