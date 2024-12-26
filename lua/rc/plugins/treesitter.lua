return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts_config = require("nvim-treesitter.configs")

    ts_config.setup({
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "diff",
        "go",
        "hcl",
        "html",
        "javascript",
        "json",
        "ledger",
        "lua",
        "luadoc",
        "php",
        "python",
        "query",
        "regex",
        "rust",
        "sql",
        "terraform",
        "toml",
        "vim",
        "vimdoc",
      },
      sync_install = true,
      auto_install = false,
      highlight = {
        enable = true,
        use_languagetree = true
      }
    })
  end
}
