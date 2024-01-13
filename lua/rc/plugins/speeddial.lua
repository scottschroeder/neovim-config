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
          }
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
