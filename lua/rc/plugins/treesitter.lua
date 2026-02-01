return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ok, ts_config = pcall(require, "nvim-treesitter.configs")
    if not ok then
      ok, ts_config = pcall(require, "nvim-treesitter.config")
    end
    if not ok then
      require("rc.log").error("nvim-treesitter config module not found")
      return
    end

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
      },
      indent = { enable = true },
    })
  end
}
