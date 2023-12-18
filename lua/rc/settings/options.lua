local opt = require("rc.utils.option").opt

opt("o", "hidden", true) -- Hides buffers instead of closing them
opt("o", "backup", false)
opt("b", "swapfile", false)
opt("o", "mouse", "a")

opt("o", "cmdheight", 1)
opt("o", "updatetime", 250)

opt("w", "signcolumn", "yes")
opt("w", "list", true)
opt("o", "listchars", { 'tab:▸░', 'trail:·', 'extends:»', 'precedes:«', 'nbsp:⣿' })
opt("w", "number", true)     -- show line numbers
opt("w", "numberwidth", 2)
opt("w", "cursorline", true) -- cursor line is highlighted
opt("o", "scrolloff", 3)     -- keep cursorline away from the edge
opt("o", "lazyredraw", true)
opt("o", "title", true)

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

vim.cmd("syntax enable")
vim.cmd("syntax on")
vim.cmd("filetype on")
