return {
  {
    "scottschroeder/speeddial.nvim",
    dir = "~/src/github/scottschroeder/speeddial.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      local map = require("rc.utils.map").map

      require("speeddial").setup({
        sources = {
          {
            project = {
              title = "Neovim Config",
              vcs_root = "~/src/github/scottschroeder/neovim-config",
            }
          },
          {
            project = {
              title = "speeddial.nvim",
              vcs_root = "~/src/github/scottschroeder/speeddial.nvim",
            }
          },
          {
            project = {
              title = "Hab Config",
              root = "~/src/github/scottschroeder/hab/configs",
              vcs_root = "~/src/github/scottschroeder/hab",
            }
          },
          {
            git = {
              root = "~/src/github",
              depth = 2,
              source = "GitHub"
            }
          },
          {
            git = {
              base = "~/src/local",
              source = "local"
            }
          },
          -- {
          --   git = {
          --     root = "~/src",
          --     source = "git"
          --   }
          -- },
        }
      })

      map("n", "<leader>p", function()
        require("speeddial").select({
          after = function()
            require('telescope.builtin').find_files({ find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } })
          end
        })
      end, {})
    end
  },
}
