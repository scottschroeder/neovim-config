local log = require("vimrc.log")
local ok, diffview = pcall(require, "diffview")
if not ok then
  log.warn("diffview not installed")
  return
end

diffview.setup({})



local map = require("vimrc.config.mapping").map

map("n", "<Leader>gd", ":DiffviewOpen<CR>", { desc = "Diff" })
map("n", "<Leader>gD", ":DiffviewOpen origin/HEAD<CR>", { desc = "Diff Origin" })
