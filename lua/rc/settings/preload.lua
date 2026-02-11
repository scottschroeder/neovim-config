-- These are the minimal amount of settings I want applied before anything
-- else is loaded.

-- Set the leader immediately so that any applied bindings use
-- the correct leader key
vim.g.mapleader = " "

-- Turn off some builtin plugins
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1

vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1

vim.opt.termguicolors = true -- full GUI colors

-- Initialize vim.lsp.config['*'] so plugins (blink.cmp) can index it at load time
if vim.lsp.config and not vim.lsp.config["*"] then
  vim.lsp.config("*", {})
end
