return {
  {
    "kosayoda/nvim-lightbulb",
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true }
      })
    end

  },
  -- { "RishabhRD/nvim-lsputils", dependencies = "RishabhRD/popfix" },
  {
    "aznhe21/actions-preview.nvim",
    -- config = function()
    --   vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
    -- end,
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    config = function()
      require("lsp-inlayhints").setup({})
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lsp")
    end
  },
}
