local g = vim.g

g.auto_save = 1
g.auto_save_silent = 1
g.auto_save_write_all_buffers = 1

g.auto_save_presave_hook = 'lua require("vimrc.plugins.vim-auto-save").abort_files()'

local abort_buf_named = function(bufname)
  -- Files named 'PopList #XX' from the https://github.com/RishabhRD/popfix repo
  local sep = package.config:sub(1,1)
  if bufname:match('.*'..sep.. "PopList #" .. '[0-9]+$') ~= nil then
    return true
  end

  return false
end

local abort_files = function()
  local thisBuf = vim.api.nvim_get_current_buf()
  local bufName = vim.api.nvim_buf_get_name(thisBuf)


  if abort_buf_named(bufName) then
    g.auto_save_abort = 1
  else
    g.auto_save_abort = 0
  end
end

return {
  abort_files = abort_files,
}
