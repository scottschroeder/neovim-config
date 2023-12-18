return {
  { "nvim-tree/nvim-web-devicons",     lazy = true },
  { "nvim-lua/plenary.nvim",           lazy = true },
  { "nvim-treesitter/nvim-treesitter", lazy = true },
  { "j-hui/fidget.nvim" },
  { "ggandor/lightspeed.nvim",         dependencies = "tpope/vim-repeat" },
  { 'stevearc/dressing.nvim' },         -- appearance of the vim.ui.select & vim.ui.input modals
  {
    "quickfix",
    enabled = true,
    dir = vim.fn.stdpath("config") .. "/lua/" .. "quickfix",
    config = function()
      local qf = require("quickfix")
      local map = require("rc.utils.map").map

      map("n", "<M-q>", qf.magic_quickfix, { desc = "Magic Quickfix" })
      map("n", "<C-q>", qf.diagnostic_quickfix, { desc = "Diagnostic Quickfix" })
      map("n", "]q", ":cn<CR>", { desc = "Next Quickfix" })
      map("n", "[q", ":cp<CR>", { desc = "Prev Quickfix" })
    end
  },
}
