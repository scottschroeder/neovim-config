local log = require("vimrc.log")
local map = require("vimrc.config.mapping").map
local ok, tabby = pcall(require,"tabby")
if not ok then
  log.warn("unable to load tabby")
  return
end

tabby.setup({
  tabline = require("tabby.presets").active_wins_at_tail
})

map("n", "<leader>ta", ":$tabnew<CR>", {noremap = true})
map("n", "<leader>tc", ":tabclose<CR>", { noremap = true })
map("n", "<leader>to", ":tabonly<CR>", { noremap = true })
map("n", "<leader>tn", ":tabn<CR>", { noremap = true })
map("n", "<leader>tp", ":tabp<CR>", { noremap = true })
map("n", "<S-Right>", ":tabn<CR>", { noremap = true })
map("n", "<S-Left>", ":tabp<CR>", { noremap = true })
map("n", "<leader>tmp", ":-tabmove<CR>", { noremap = true })
map("n", "<leader>tmn", ":+tabmove<CR>", { noremap = true })
