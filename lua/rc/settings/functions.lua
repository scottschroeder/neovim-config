M = {}


M.reload_all = function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      local modifiable = vim.api.nvim_get_option_value("modifiable", {
        buf = buf,
      })

      if name ~= "" then
        if vim.fn.filereadable(name) == 0 then
          -- File doesn't exist: wipe the buffer
          vim.api.nvim_buf_delete(buf, { force = true })
        elseif modifiable then
          -- File exists: force reload
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("e!")
          end)
        end
      end
    end
  end
end




return M
