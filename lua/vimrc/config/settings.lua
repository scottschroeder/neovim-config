local log = require("vimrc.log")
local opt = require("vimrc.config.option").opt
local map = require("vimrc.config.mapping").map
local map_prefix = require("vimrc.config.mapping").prefix
local usercmd = require("vimrc.config.mapping").cmd
local cmd = vim.cmd

opt("o", "hidden", true) -- Hides buffers instead of closing them
opt("o", "backup", false)
opt("b", "swapfile", false)
opt("o", "mouse", "a")

opt("o", "cmdheight", 1)
opt("o", "updatetime", 250)

opt("w", "signcolumn", "yes")
opt("w", "list", true)
opt("o", "listchars", { 'tab:▸░', 'trail:·', 'extends:»', 'precedes:«', 'nbsp:⣿' })
opt("w", "number", true) -- show line numbers
opt("w", "numberwidth", 2)
opt("w", "cursorline", true) -- cursor line is highlighted
opt("o", "scrolloff", 3) -- keep cursorline away from the edge
opt("o", "lazyredraw", true)

opt("o", "ignorecase", true)
opt("o", "smartcase", true)
opt("o", "wildignorecase", true)
opt("o", "wildmode", { "list:longest", "full" })
opt("o", "wildignore", { "*.swp", "*.bak", "*.pyc", "*.class" })


opt("w", "wrap", false)

local tabwidth = 2
opt("b", "tabstop", tabwidth)
opt("b", "softtabstop", tabwidth)
opt("b", "shiftwidth", tabwidth)
opt("o", "smarttab", true)
opt("b", "expandtab", true)
opt("o", "pastetoggle", "<F12>")

opt("b", "spelllang", "en_us")

cmd "syntax enable"
cmd "syntax on"
cmd "filetype on"

vim.g.mapleader = " "

map("", "<C-h>", "<C-w>h", {desc = "move window left"})
map("", "<C-j>", "<C-w>j", {desc = "move window down"})
map("", "<C-k>", "<C-w>k", {desc = "move window up"})
map("", "<C-l>", "<C-w>l", {desc = "move window right"})

-- Open new vertical split
map("n", "<leader>w", "<C-w>v<C-w>l", { noremap = true, desc = "New Vertical Split" })
-- Open a new horizontal split
map("n", "<leader>h", "<C-w>s<C-w>j", { noremap = true, desc = "New Horizontal Split" })
-- Close your current split
map("n", "<leader>c", "<C-w>c", { noremap = true, desc = "Close Split" })
-- Close everything except your current split
map("n", "<leader>o", ":only<CR>", { noremap = true, desc = "Close Everything Else" })

-- Reload vimrc
map("n", "<leader>sv", require('vimrc.utils').reload_vimrc, {desc = "reload .vimrc"})
map("n", "<leader>ss", function()
  log.info('doing reload of luasnip')
  require("vimrc.utils").reload_plugin("vimrc.plugins.luasnip")
end, {desc = "reload luasnip"})



map("n", "<leader>sd",
  function()
    require("vimrc.utils").reload_plugin("heirline")
    require("vimrc.utils").reload_plugin("vimrc.plugins.heirline")
  end,
  { desc = "reload heirline" }
)
map("n", "<leader>p",
  function()
    -- require("vimrc.project").project({display_type = "full"})
    require("vimrc.project").project(require("telescope.themes").get_dropdown {})
  end , {desc = "Project Picker"}
)

-- Test
map_prefix("<leader>s", "nvim config debug commands")
map("n", "<leader>sf",
  function()
    require("vimrc.project").project_select()
  end, {desc = "Project Select ???"}
)

-- vim's clipboard buffers go to tmux buffer
-- opt("o", "clipboard", "unnamedplus")
-- map("v", "<Leader>y", '"+y')

-- For my current setup, the unnamed buffer (PRIMARY) is the
-- one that's getting synced.
map({ "n", "v" }, "<Leader>y", '"*y', {desc="Yank to Clipboard"})

-- map("n", "<Leader>y", '"+y')
-- map("v", "<Leader>d", '"+d')
-- map("n", "<Leader>d", '"+d')

-- map("n", "<Leader>p", '"+p')
-- map("n", "<Leader>P", '"+P')
-- map("v", "<Leader>p", '"+p')
-- map("v", "<Leader>P", '"+P')

-- Remove search hilighting
map({"n", "v"}, "<Leader>/", ':let @/ = ""<CR>', { silent = true, desc = "Clear Search" })

-- Format the current file
-- These are handled by the attach function. For now we have no other formatters
-- map("n", "<Leader>=", require("vimrc.dev.format").format_current_buffer)
-- map("v", "<Leader>=", require("vimrc.dev.format").format_range)

-- Diagnostics
map({ "n" }, "]d", vim.diagnostic.goto_next, { desc = "go to next diagnostic" })
map({ "n" }, "[d", vim.diagnostic.goto_prev, { desc = "go to prev diagnostic" })
map({ "n" }, "L", vim.diagnostic.open_float, { desc = "show line diagnostics" })
map({ "n" }, "<M-q>", vim.diagnostic.setqflist, { desc = "set quickfix list" })


-- Git
-- TODO are there sub mappings here? can we do them manually?
-- map("n", "<Leader>g", ":Git<CR>", {desc = "Git"})
map("n", "<Leader>gs", ":Git<CR>", {desc = "Fugitive"})
map_prefix("<leader>g", "Git Helpers")
vim.g.fugitive_no_maps = 1

map("n", "j", "gj", { noremap = true })
map("n", "k", "gk", { noremap = true })
map("", "Y", "y$", { noremap = true , desc = "y$"})

map("n", "/", "/\\v", { noremap = true })
map("v", "/", "/\\v", { noremap = true })

usercmd("Wrapon", function()
  opt("w", "wrap", true)
end)

usercmd("Wrapoff", function()
  opt("w", "wrap", false)
end)

usercmd("Scratch", function()
  scratch("")
end)

usercmd("BackgroundToggle", function()
  local palette = require("vimrc.config.palette")
  if vim.o.background == "dark" then
    opt("o", "background", "light")
  else
    opt("o", "background", "dark")
  end
  palette.refresh_palette()
end)
