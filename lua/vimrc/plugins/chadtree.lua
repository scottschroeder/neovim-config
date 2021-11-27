local log = require("vimrc.log")
local map = require("vimrc.config.mapping").map

local ok, chadtree = pcall(require, "chadtree")

vim.api.nvim_set_var("chadtree_settings", {
  options = {
    close_on_open = false,
  },
  theme = {
    text_colour_set = "nerdtree_syntax_dark",
  },
})


local toggle_chadtree = function ()
  if ok then
    pcall(chadtree.Open)
  else
    log.warn("chadtree not ok")
  end
end

local M = {}
function M.unload_chadtree()
  if not ok then
    return
  end
  local did_stop = chadtree.Stop()
  log.trace("run chadtree.Stop()", did_stop)
  -- require("plenary.reload").reload_module("chadtree", true)
  -- ok = false
end


map("n", "<Leader>k", toggle_chadtree)

return M
