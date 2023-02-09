local log = require("vimrc.log")
local has_whichkey, whichkey = pcall(require, "which-key")

local keybind = function(mode, lhs, rhs, opts)
  -- log.trace("lhs", lhs, "mode", mode, "opts", opts)
  if has_whichkey then
    opts = opts or {}
    opts.mode = mode
    local desc = opts.desc or "UNKNOWN"
    whichkey.register({
      [lhs] = { rhs, desc }
    }, opts)
  else
    return vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local prefix = function(lhs, name)
  if has_whichkey then
    whichkey.register({
      [lhs] = { name = name }
    })
  end
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
  prefix = prefix,
  buf_map = buf_map,
  cmd = cmd,
}
