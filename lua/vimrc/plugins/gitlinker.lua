local log = require("vimrc.log")
local map = require("vimrc.config.mapping").map

local ok, gitlinker = pcall(require, "gitlinker")
if not ok then
  log.warn("gitlinker not installed")
  return
end


gitlinker.setup({
  mappings = nil,
  opts = {
    add_current_line_on_normal_mode = false,
  },
})

map("n", "<leader>gy", function() gitlinker.get_buf_range_url("n", {}) end)
map("v", "<leader>gy", function() gitlinker.get_buf_range_url("v", {}) end)
map('n', '<leader>gB',
  function()
    gitlinker.get_repo_url({ action_callback = require "gitlinker.actions".open_in_browser })
  end
)
