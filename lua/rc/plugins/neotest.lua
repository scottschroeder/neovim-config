return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-go",
    "mrcjkb/rustaceanvim",
  },
  config = function()
    local map = require("rc.utils.map").map
    local map_prefix = require("rc.utils.map").prefix

    map_prefix("<leader>T", "[T]ests")

    -- The diagnostics are not working
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, neotest_ns)

    local neotest = require("neotest")
    neotest.setup({
      output = {
        enabled = true,
      },
      diagnostic = {
        enabled = true,
      },
      adapters = {
        require("neotest-go")({
          recursive_run = true,
        }),

        require("rustaceanvim.neotest"),
      },
    })

    map("n", "<leader>TT", function()
      neotest.summary.toggle()
    end, { desc = "Toggle Tests" })
  end,
}
