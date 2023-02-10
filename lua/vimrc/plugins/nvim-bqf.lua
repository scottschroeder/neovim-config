local log = require("vimrc.log")
local ok, bqf = pcall(require, "bqf")
if not ok then
  log.warn("bqf not installed")
  return
end

local bqf_pv_timer
bqf.setup ({
    preview = {
      should_preview_cb = function(bufnr, qwinid)
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if bufname:match '^fugitive://' and not vim.api.nvim_buf_is_loaded(bufnr) then
              if bqf_pv_timer and bqf_pv_timer:get_due_in() > 0 then
                  bqf_pv_timer:stop()
                  bqf_pv_timer = nil
              end
              bqf_pv_timer = vim.defer_fn(function()
                  vim.api.nvim_buf_call(bufnr, function()
                      vim.cmd(('do fugitive BufReadCmd %s'):format(bufname))
                  end)
                  require('bqf.preview.handler').open(qwinid, nil, true)
              end, 60)
          end
          return true
      end
  }
})
