local usercmd = require("vimrc.config.mapping").cmd
local ts_config = require("nvim-treesitter.configs")
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

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
        disable = {"org"},
        additional_vim_regex_highlighting = {"org"},
        use_languagetree = true
    }
}

local function print_node(node, level)
    local prefix = string.rep("  ", level)
    local node_type = node:type()
    local start_row, start_col, end_row, end_col = node:range()
    print(string.format("%s%s [%d:%d] - [%d:%d]", prefix, node_type, start_row, start_col, end_row, end_col))
    for child in node:iter_children() do
        print_node(child, level + 1)
    end
end

local function print_tree()
    local bufnr = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(bufnr)
    local tree = parser:parse()[1]
    local root_node = tree:root()
    print_node(root_node, 0)
end


usercmd("PrintTSTree", function()
  print_tree()
end)
