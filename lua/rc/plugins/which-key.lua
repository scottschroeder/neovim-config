return {
  "folke/which-key.nvim",
  lazy = true,
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300

    require("which-key").setup({
      plugins = {
        spelling = {
          enabled = true
        }
      }
    })
  end
}
