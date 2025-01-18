local M = {}

M.setup = function()
  vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = vim.api.nvim_create_augroup("EqualizeSplits", {}),
    callback = function()
      local current_tab = vim.api.nvim_get_current_tabpage()
      vim.cmd("tabdo wincmd =")
      vim.api.nvim_set_current_tabpage(current_tab)
    end,
    desc = "Resize splits with terminal window",
  })
end

return M
