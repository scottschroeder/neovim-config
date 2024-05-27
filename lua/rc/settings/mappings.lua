local map = require("rc.utils.map").map
local map_prefix = require("rc.utils.map").prefix
local usercmd = require("rc.utils.map").cmd


map("", "<C-h>", "<C-w>h", { desc = "move window left" })
map("", "<C-j>", "<C-w>j", { desc = "move window down" })
map("", "<C-k>", "<C-w>k", { desc = "move window up" })
map("", "<C-l>", "<C-w>l", { desc = "move window right" })
--
-- Open new vertical split
map("n", "<leader>w", "<C-w>v<C-w>l", { noremap = true, desc = "New Vertical Split" })
-- Open a new horizontal split
map("n", "<leader>h", "<C-w>s<C-w>j", { noremap = true, desc = "New Horizontal Split" })
-- Close your current split
map("n", "<leader>c", "<C-w>c", { noremap = true, desc = "Close Split" })
-- Close everything except your current split
map("n", "<leader>o", ":only<CR>", { noremap = true, desc = "Close Everything Else" })

-- For my current setup, the unnamed buffer (PRIMARY) is the
-- one that's getting synced.
map({ "n", "v" }, "<Leader>y", '"+y', { desc = "Yank to Clipboard" })

map({ "n", "v" }, "<Leader>/", ':let @/ = ""<CR>', { silent = true, desc = "Clear Search" })

map_prefix("<leader>g", "Git Helpers")


map_prefix("<leader>t", "Tabs")
map("n", "<leader>ta", ":$tabnew<CR>", { noremap = true, desc = "New Tab" })
map("n", "<leader>tc", ":tabclose<CR>", { noremap = true, desc = "Close Tab" })
map("n", "<leader>to", ":tabonly<CR>", { noremap = true, desc = "Close all other tabs" })
map("n", "]t", ":tabn<CR>", { noremap = true, desc = "TabNext" })
map("n", "[t", ":tabp<CR>", { noremap = true, desc = "TabPrev" })

-- Diagnostics
map({ "n" }, "]d", vim.diagnostic.goto_next, { desc = "go to next diagnostic" })
map({ "n" }, "[d", vim.diagnostic.goto_prev, { desc = "go to prev diagnostic" })
map({ "n" }, "L", vim.diagnostic.open_float, { desc = "show line diagnostics" })
usercmd("Scratch", function()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
end)


-- This doesn't really work as expected
map({ "n" }, "<leader>ss", function()
  vim.cmd("Lazy reload LuaSnip")
end, { desc = "reload lua snippets" })
