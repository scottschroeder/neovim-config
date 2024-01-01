return {
  "nvim-treesitter/nvim-treesitter",
  lazy = true,
  build = ":TSUpdate",
  config = function()
    local ts_config = require("nvim-treesitter.configs")

    ts_config.setup({
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "go",
        "html",
        "javascript",
        "json",
        "ledger",
        "lua",
        "php",
        "python",
        "regex",
        "rust",
        "sql",
        "toml",
      },
      highlight = {
        enable = true,
        use_languagetree = true
      }
    })
  end
}
