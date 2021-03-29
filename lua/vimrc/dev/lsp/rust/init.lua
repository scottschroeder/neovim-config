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
    on_attach = require("vimrc.dev.attach").on_attach,
    settings = {
      ["rust-analyzer"] = {
            ["rust-analyzer.cargo.loadOutDirsFromCheck"]= true,
            ["rust-analyzer.highlightingOn"]= true,
            ["rust-analyzer.procMacro.enable"]= true,
      }
    },
}


vim.cmd([[autocmd CursorHold,CursorHoldI,BufEnter,BufWinEnter,TabEnter,BufWritePost,BufRead *.rs :lua require'lsp_extensions'.inlay_hints{ enabled = { "ChainingHint", "TypeHint", "ParameterHint" } }]])
