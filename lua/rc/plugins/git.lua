return {
  {
    "tpope/vim-fugitive",
    lazy = true,
    keys = "<leader>g",
    config = function()
      local map = require("rc.utils.map").map
      map("n", "<Leader>gs", ":Git<CR>", { desc = "Fugitive" })
    end
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    lazy = true,
    keys = "<leader>g",
    config = function()
      local map = require("rc.utils.map").map
      require("diffview").setup({})
      map("n", "<Leader>gd", ":DiffviewOpen<CR>", { desc = "Diff" })
      map("n", "<Leader>gD", ":DiffviewOpen origin/HEAD<CR>", { desc = "Diff Origin" })
    end
  },
  {
    'ruifm/gitlinker.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    lazy = true,
    keys = "<leader>g",
    config = function()
      local gitlinker = require("gitlinker")
      gitlinker.setup({
        mappings = nil,
        opts = {
          add_current_line_on_normal_mode = false,
        },
      })

      local map = require("rc.utils.map").map
      map("n", "<leader>gy", function() gitlinker.get_buf_range_url("n", {}) end, { desc = "Link to GitHub" })
      map("v", "<leader>gy", function() gitlinker.get_buf_range_url("v", {}) end, { desc = "Link to GitHub" })
      map('n', '<leader>gG',
        function()
          gitlinker.get_repo_url({ action_callback = require "gitlinker.actions".open_in_browser })
        end
        , { desc = "Open in GitHub" }
      )
    end

  },
}
