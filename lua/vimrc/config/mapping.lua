local bind_funcs = {}

local function new_binding(f) 
    local next = #bind_funcs+1
    bind_funcs[next]=f
    return next
end

local function call_bound(id)
    return bind_funcs[id]()
end

_G.call_bound = call_bound

local function fmt_vimscript_call(id)
    return "lua require('vimrc.config.mapping').call_bound(" .. id .. ")"
end
local function fmt_vim_binding(id)
    -- local info = debug.getinfo(1,'S');
    return ":" .. fmt_vimscript_call(id) .. "<CR>"
end

local function fmt_expr_call(id)
    return "v:lua.call_bound(" .. id .. ")"
end

local map_args = function(rhs, opts)
    local options = {}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    if type(rhs) == "function" then 
        local id = new_binding(rhs)
        if options.expr == true then
            rhs = fmt_expr_call(id)
        else
            rhs = fmt_vim_binding(id)
        end
        options = vim.tbl_extend("force", options, {silent=true})
    end
    return {
      options = options,
      rhs = rhs,
    }
end

local function map(mode, lhs, rhs, opts)
  args = map_args(rhs, opts)
  vim.api.nvim_set_keymap(mode, lhs, args.rhs, args.options)
end

local function buf_map(bufnr, mode, lhs, rhs, opts)
  args = map_args(rhs, opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, args.rhs, args.options)
end

local cmd = function(name, func)
  local id = new_binding(func)
  cmd_str = fmt_vimscript_call(id)
  vim.cmd("command! " .. name .. " " .. cmd_str)
end

return {
    call_bound = call_bound,
    map = map,
    buf_map = buf_map,
    cmd = cmd,
}
