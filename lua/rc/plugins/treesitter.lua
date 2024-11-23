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
        "hcl",
        "html",
        "javascript",
        "json",
        "ledger",
        "lua",
        "luadoc",
        "php",
        "python",
        "regex",
        "rust",
        "sql",
        "terraform",
        "toml",
        "vim",
        "vimdoc",
      },
      highlight = {
        enable = true,
        use_languagetree = true
      }
    })
  end
}
