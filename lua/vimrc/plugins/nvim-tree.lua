local g = vim.g
local cmd = vim.cmd
local opt = require("vimrc.config.option").opt

local map = require("vimrc.config.mapping").map
local win_open = require("nvim-tree.lib").win_open


local function toggle_nvim_tree()
    if win_open() then
        cmd("NvimTreeClose")
    else
        -- cmd("NvimTreeFindFile")
        require'nvim-tree'.find_file(true)
    end
    local winnr = require("nvim-tree.lib").Tree.winnr()
    -- TODO this doesn't work
    if winnr ~= nil then
      vim.api.nvim_win_set_option(
        winnr,
        "signcolumn",
        "no"
      )
    end
    -- opt("w", "signcolumn", "no")
end

map("n", "<Leader>k", toggle_nvim_tree)

g.nvim_tree_ignore = { '.git', 'node_modules', '.cache' }
g.nvim_tree_auto_close = 1 -- close when its the last window
g.nvim_tree_tab_open = 1 -- persist open between tabs
g.nvim_tree_follow = 1 -- persist open between tabs
