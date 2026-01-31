-- Minimal init for headless test runs with plenary.nvim
vim.opt.runtimepath:append(".")

local plenary_paths = {
  vim.fn.getcwd() .. "/plenary.nvim", -- CI
  vim.fn.stdpath("data") .. "/lazy/plenary.nvim", -- Local
}

for _, path in ipairs(plenary_paths) do
  if vim.fn.isdirectory(path) == 1 then
    vim.opt.runtimepath:append(path)
    break
  end
end
