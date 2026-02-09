local M = {}

M.define_config = function(name, f)
  return {
    name,
    enabled = true,
    dir = vim.fn.stdpath("config") .. "/lua/" .. name,
    config = f,
  }
end

return M
