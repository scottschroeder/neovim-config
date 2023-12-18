return
{
  'pwntester/octo.nvim',
  enabled = true,
  lazy = true,
  cmd = "Octo",
  -- dir = "/home/manager/plugins/octo.nvim",
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    vim.g.octo_viewer = "scottschroeder"

    require("octo").setup({
      mappings = {
        review_diff = {
          add_review_comment = { lhs = "<leader>Oc", desc = "add a new review comment" },
          add_review_suggestion = { lhs = "<leader>Os", desc = "add a new review suggestion" },
          focus_files = { lhs = "<leader>Oe", desc = "move focus to changed file panel" },
          toggle_files = { lhs = "<leader>Ob", desc = "hide/show changed files panel" },
          next_thread = { lhs = "]t", desc = "move to next thread" },
          prev_thread = { lhs = "[t", desc = "move to previous thread" },
          select_next_entry = { lhs = "]e", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[e", desc = "move to next changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          toggle_viewed = { lhs = "<leader>Ox", desc = "toggle viewer viewed state" },
          goto_file = { lhs = "gf", desc = "go to file" },
        },
      }
    })

    -- Create bindings to start/resume/submit reviews?
    -- Unbind anything that could merge a PR
  end,
}

