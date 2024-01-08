return {
  {
    "scottschroeder/speeddial.nvim",
    dir = "~/src/github/scottschroeder/speeddial.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("speeddial").setup({
        sources = {
          {
            project = {
              name = "Demo",
              vcs_root = "~/src/local/neovim-config",
            }
          },
          {
            project = {
              name = "Demo2",
              vcs_root = "~/src/local/neovim-config2",
            }
          }
        }
      })
    end
  },
}
