local ts_config = require("nvim-treesitter.configs")
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.org = {
  install_info = {
    url = 'https://github.com/milisims/tree-sitter-org',
    revision = 'main',
    files = {'src/parser.c', 'src/scanner.cc'},
  },
  filetype = 'org',
}

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
        "org",
        "php",
        "python",
        "regex",
        "rust",
        "toml",
    },
    highlight = {
        enable = true,
        disable = {"org"},
        additional_vim_regex_highlighting = {"org"},
        use_languagetree = true
    }
}
