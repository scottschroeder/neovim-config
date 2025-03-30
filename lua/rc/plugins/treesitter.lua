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
        "dockerfile",
        "dot",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "graphql",
        "hcl",
        "helm",
        "html",
        "javascript",
        "jinja",
        "jq",
        "json",
        "ledger",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "php",
        "proto",
        "python",
        "query",
        "regex",
        "rust",
        "sql",
        "ssh_config",
        "tera",
        "terraform",
        "tmux",
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
