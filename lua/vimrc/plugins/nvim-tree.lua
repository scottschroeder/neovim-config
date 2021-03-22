local g = vim.g
local cmd = vim.cmd

local map = require("vimrc.config.mapping").map

local is_open_var = "vimrc_nvim_tree_enabled"

local function is_tree_open() 
   ok, is_open = pcall(vim.api.nvim_get_var, is_open_var)
   if not ok then
       return false
   end
   return is_open
end

local function set_tree(status) 
    vim.api.nvim_set_var(is_open_var, status)
end

local function toggle_nvim_tree()
    if is_tree_open() then
        set_tree(false)
        cmd("NvimTreeClose")
    else
        set_tree(true)
        cmd("NvimTreeFindFile")
    end
end

map("n", "<Leader>k", toggle_nvim_tree)

g.nvim_tree_ignore = { '.git', 'node_modules', '.cache' }
g.nvim_tree_auto_close = 1 -- close when its the last window
g.nvim_tree_tab_open = 1 -- persist open between tabs
