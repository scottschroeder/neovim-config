return {
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lua/plenary.nvim",       lazy = true },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({})
    end
  },
  {
    "ggandor/leap.nvim",
    dependencies = "tpope/vim-repeat",
    config = function()
      require("leap").create_default_mappings()
    end
  },
  { 'stevearc/dressing.nvim' },                                                              -- appearance of the vim.ui.select & vim.ui.input modals
  { 'norcalli/nvim-colorizer.lua', config = function() require("colorizer").setup({}) end }, -- highlight color codes
  require("rc.utils.miniplugin").define_config("quickfix", function()
    local qf = require("quickfix")
    local map = require("rc.utils.map").map
    local diagnostics = require("diagnostics")

    map("n", "<M-q>", function()
      diagnostics.set_line_mode(false)
      qf.magic_quickfix()
    end, { desc = "Magic Quickfix" })
    map("n", "<C-q>", function()
      diagnostics.set_line_mode(true)
      qf.diagnostic_quickfix()
    end, { desc = "Diagnostic Quickfix" })
    map("n", "]q", ":cn<CR>", { desc = "Next Quickfix" })
    map("n", "[q", ":cp<CR>", { desc = "Prev Quickfix" })
  end
  ),
  require("rc.utils.miniplugin").define_config("autoresize", function()
    local az = require("autoresize")
    az.setup()
  end
  ),
  require("rc.utils.miniplugin").define_config("golang", function()
    local golang = require("golang")
    local map = require("rc.utils.map").map
    local cmd = require("rc.utils.map").cmd


    cmd("GoTestSwitch", golang.switch_implementation_and_test,
      { desc = "Switch between test and implementation file" })

    map("n", "<leader>gt", golang.switch_implementation_and_test,
      { desc = "Switch between test and implementation file" })
    map("n", "<leader>lp", golang.public_private_swap,
      { desc = "Toggle Public/Private Visability" })
  end
  ),
}
