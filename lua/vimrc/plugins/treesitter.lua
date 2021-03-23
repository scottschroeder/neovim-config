local ts_config = require("nvim-treesitter.configs")

ts_config.setup {
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "php",
        "python",
        "regex",
        "rust",
        "toml",
    },
    highlight = {
        enable = true,
        use_languagetree = true
    }
}
