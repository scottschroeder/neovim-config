local define_octo_review_bindings = function()
  local au_group = vim.api.nvim_create_augroup("rc.settings.buffer.octo_review", { clear = true })

  local map_prefix = require("rc.utils.map").prefix

  local set_keymaps = function()
    if vim.bo.filetype ~= "octo" then
      map_prefix("<leader>O", "Octo", { buffer = 0 })
    end
  end


  vim.api.nvim_create_autocmd(
    { "BufEnter" },
    {
      pattern = "octo://*",
      callback = set_keymaps,
      desc = "set bindings for reviewing PRs with octo",
      group = au_group,
    }
  )
end


define_octo_review_bindings()
