-- https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
USER = vim.fn.expand('$USER')

local home = vim.fn.expand("$HOME")
local lspconfig = require('lspconfig')

local ra_bin = home .. "/.hab/build/rust-analyzer/bin/rust-analyzer"

if vim.fn.empty(vim.fn.glob(ra_bin)) > 0 then
    return
end

lspconfig.rust_analyzer.setup {
    cmd = {ra_bin},
    filetypes = { "rust" },
    root_dir = lspconfig.util.root_pattern("Cargo.toml", "rust-project.json"),
    settings = {
      ["rust-analyzer"] = {}
    },
}

