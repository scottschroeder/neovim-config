local define_octo_review_bindings = function()
  local au_group = vim.api.nvim_create_augroup("rc.settings.buffer.octo_review", { clear = true })

  local map_prefix = require("rc.utils.map").prefix
  local buf_map = require('rc.utils.map').buf_map

  local octo_map = function(mode, lhs, rhs, opt)
    buf_map(0, mode, lhs, rhs, opt)
  end

  local set_keymaps = function()
    if vim.bo.filetype ~= "octo" then
      map_prefix("<leader>O", "Octo", { buffer = 0 })
      map_prefix("<leader>R", "Review Management", { buffer = 0 })
      octo_map("n", "<leader>Rs", ":Octo review start<CR>", { noremap = true, desc = "Start" })
      octo_map("n", "<leader>RS", ":Octo review submit<CR>", { noremap = true, desc = "Submit" })
      octo_map("n", "<leader>Rr", ":Octo review resume<CR>", { noremap = true, desc = "Resume" })
      octo_map("n", "<leader>Rd", ":Octo review discard<CR>", { noremap = true, desc = "Discard" })
      octo_map("n", "<leader>Rc", ":Octo review comments<CR>", { noremap = true, desc = "View Pending Review Comments" })
      octo_map("n", "<leader>Rp", ":Octo review commit<CR>", { noremap = true, desc = "Pick specific commit to review" })
      octo_map("n", "<leader>Re", ":Octo review close<CR>", { noremap = true, desc = "Exit Review" })
      octo_map("n", "<leader>Ob", ":Octo pr browser<CR>", { noremap = true, desc = "Open in Browswer" })
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
