local bind_funcs = {}

local function new_binding(f) 
    local next = #bind_funcs+1
    bind_funcs[next]=f
    return next
end

local function call_bound(id)
    bind_funcs[id]()
end

local function fmt_vim_call(id)
    -- local info = debug.getinfo(1,'S');
    return ":lua require('vimrc.config.mapping').call_bound(" .. id .. ")<CR>"
end

local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    if type(rhs) == "function" then 
        local id = new_binding(rhs)
        rhs = fmt_vim_call(id)
        options = vim.tbl_extend("force", options, {silent=true})
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

return {
    call_bound = call_bound,
    map = map,
}