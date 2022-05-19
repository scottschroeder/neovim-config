local keybind = function(mode, lhs, rhs, opts)
  return vim.keymap.set(mode, lhs, rhs, opts)
end

local function buf_map(bufnr, mode, lhs, rhs, opts)
  opts = opts or {}
  opts.buffer = bufnr
  return keybind(mode, lhs, rhs, opts)
end

local cmd = function(name, func, opts)
  opts = opts or {}
  return vim.api.nvim_create_user_command(name, func, opts)
end

return {
    map = keybind,
    buf_map = buf_map,
    cmd = cmd,
}
