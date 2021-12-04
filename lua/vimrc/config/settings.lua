
local log = require("vimrc.log")
local opt = require("vimrc.config.option").opt
local map = require("vimrc.config.mapping").map
local usercmd = require("vimrc.config.mapping").cmd
local cmd = vim.cmd

opt("o", "hidden", true) -- Hides buffers instead of closing them
opt("o", "backup", false)
opt("b", "swapfile", false)
opt("o", "mouse", "a")

opt("o", "cmdheight", 1)
opt("o", "updatetime", 250)
opt("o", "background", "dark") -- assume dark background
opt("o", "termguicolors", true) -- full GUI colors

opt("w", "signcolumn", "yes")
opt("w", "list", true)
opt("o", "listchars", {'tab:▸░', 'trail:·', 'extends:»', 'precedes:«', 'nbsp:⣿'})
opt("w", "number", true) -- show line numbers
opt("w", "numberwidth", 2)
opt("w", "cursorline", true) -- cursor line is highlighted
opt("o", "scrolloff", 3) -- keep cursorline away from the edge
opt("o", "lazyredraw", true)

opt("o", "ignorecase", true)
opt("o", "smartcase", true)
opt("o", "wildignorecase", true)
opt("o", "wildmode", {"list:longest", "full"})
opt("o", "wildignore", {"*.swp","*.bak","*.pyc","*.class"})


opt("w", "wrap", false)

local tabwidth = 2
opt("b", "tabstop", tabwidth)
opt("b", "softtabstop", tabwidth)
opt("b", "shiftwidth", tabwidth)
opt("o", "smarttab", true)
opt("b", "expandtab", true )
opt("o", "pastetoggle", "<F12>")

opt("b", "spelllang", "en_us")

cmd "syntax enable"
cmd "syntax on"
cmd "filetype on"

vim.g.mapleader = " "

map("", "<C-h>", "<C-w>h")
map("", "<C-j>", "<C-w>j")
map("", "<C-k>", "<C-w>k")
map("", "<C-l>", "<C-w>l")

-- Open new vertical split
map("n", "<leader>w", "<C-w>v<C-w>l", {noremap = true})
-- Open a new horizontal split
map("n", "<leader>h", "<C-w>s<C-w>j", {noremap = true})
-- Close your current split
map("n", "<leader>c", "<C-w>c", {noremap = true})
-- Close everything except your current split
map("n", "<leader>o", ":only<CR>", {noremap = true})

-- Reload vimrc
map("n", "<leader>sv", require('vimrc.utils').reload_vimrc)


map("n", "<leader>sd",
  function ()
    require("vimrc.utils").reload_plugin("vimrc.project")
    require("vimrc.utils").reload_plugin("vimrc.plugins.project")
    require("vimrc.plugins.project")
  end
)
map("n", "<leader>p",
  function ()
    -- require("vimrc.project").project({display_type = "full"})
    require("vimrc.project").project(require("telescope.themes").get_dropdown{})
  end
)

-- Test
map("n", "<leader>sf",
  function ()
    require("vimrc.project").project_select()
  end
)

-- vim's clipboard buffers go to tmux buffer
-- opt("o", "clipboard", "unnamedplus")
-- map("v", "<Leader>y", '"+y')
-- map("n", "<Leader>y", '"+y')
-- map("v", "<Leader>d", '"+d')
-- map("n", "<Leader>d", '"+d')

-- map("n", "<Leader>p", '"+p')
-- map("n", "<Leader>P", '"+P')
-- map("v", "<Leader>p", '"+p')
-- map("v", "<Leader>P", '"+P')

-- Remove search hilighting
map("n", "<Leader>/", ':let @/ = ""<CR>', {silent = true})
map("v", "<Leader>/", ':let @/ = ""<CR>', {silent = true})

-- Format the current file
map("n", "<Leader>=", require("vimrc.dev.format").format_current_buffer)
map("v", "<Leader>=", require("vimrc.dev.format").format_range)

-- Git
map("n", "<Leader>g", ":Git<CR>")

map("n", "j", "gj", {noremap = true})
map("n", "k", "gk", {noremap = true})
map("", "Y", "y$", {noremap = true})

map("n", "/", "/\\v", {noremap = true})
map("v", "/", "/\\v", {noremap = true})

usercmd("Wrapon", function()
  opt("w", "wrap", true)
end)

usercmd("Wrapoff", function()
  opt("w", "wrap", false)
end)

usercmd("Scratch", function()
  scratch("")
end)

-- LSP

-- map("n", "gd", vim.lsp.buf.definition, {noremap=true})
