local has_whichkey, whichkey = pcall(require, "which-key")

local keybind = function(mode, lhs, rhs, opts)
  -- log.trace("lhs", lhs, "mode", mode, "opts", opts)
  opts = opts or {}

  -- DO NOT LET WHICHKEY MAP SOMETHING WITHOUT A MODE
  -- IT ENDS UP MAPPING `a%` which causes a delay for "append"

  -- there is a mapping (built into neovim) for matchit
  -- that enables moving around between matching if/end or ()
  -- when in visual mode. This is bound to `a%` in `x` mode, but which-key
  -- likes wait for input every time I hit `a` even in normal mode (append).
  --
  -- https://github.com/neovim/neovim/blob/master/runtime/pack/dist/opt/matchit/plugin/matchit.vim#L85
  if has_whichkey and mode ~= "" then
    opts.mode = mode
    local desc = opts.desc or "UNKNOWN"
    whichkey.register({
      [lhs] = { rhs, desc }
    }, opts)
  else
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local prefix = function(lhs, name, opts)
  if opts == nil then
    opts = {}
  end
  if has_whichkey then
    whichkey.register({
      [lhs] = { name = name }
    }, opts)
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
