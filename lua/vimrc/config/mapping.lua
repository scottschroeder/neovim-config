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

local function fmt_vim_call(id)
    -- local info = debug.getinfo(1,'S');
    return ":lua require('vimrc.config.mapping').call_bound(" .. id .. ")<CR>"
end

local function fmt_expr_call(id)
    return "v:lua.call_bound(" .. id .. ")"
end

local function map(mode, lhs, rhs, opts)
    local options = {}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    if type(rhs) == "function" then 
        local id = new_binding(rhs)
        if options.expr == true then
            rhs = fmt_expr_call(id)
        else
            rhs = fmt_vim_call(id)
        end
        options = vim.tbl_extend("force", options, {silent=true})
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

return {
    call_bound = call_bound,
    map = map,
}
