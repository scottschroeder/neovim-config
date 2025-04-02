return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      go = { 'golangcilint' },
    }
    local augroup = vim.api.nvim_create_augroup("background lint", {})

    -- local goci = lint.linters.golangcilint
    -- INSPECT(goci)

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
      desc = "Run linters on save",
      group = augroup,
      callback = function()
        -- try_lint without arguments runs the linters defined in `linters_by_ft`
        -- for the current filetype
        require("lint").try_lint()
      end,
    })
  end,
}
