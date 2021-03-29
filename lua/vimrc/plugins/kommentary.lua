
local map = require("vimrc.config.mapping").map


local config = require("kommentary.config")

config.configure_language("default", {
    prefer_single_line_comments = true,
})

require("kommentary")
vim.g.kommentary_create_default_mappings = false

map("n", "<M-/>", '<Plug>kommentary_line_default')
map("v", "<M-/>", '<Plug>kommentary_visual_default')
