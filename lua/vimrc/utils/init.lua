local log = require("vimrc.log")
local M = {}
local api = vim.api



local function lines(str) 
    local result = {}
    for line in str:gmatch '[^\n]+' do
        table.insert(result, line)
    end
    return result
end

function _G.pprint(...)
    return vim.inspect(vim.tbl_map(vim.inspect, {...}))
end

function _G.dbg(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    _G.scratch(unpack(objects))
end

function _G.scratch(text)
    local buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_lines(buf, 0, -1, true, lines(text))
    api.nvim_set_current_buf(buf)
end

function M.unload(module_name)
	package.loaded[module_name] = nil
end

function M.unload_vimrc()
    require("plenary.reload").reload_module("vimrc", true)
end

function M.reload_vimrc()
    require("vimrc.plugins.chadtree").unload_chadtree()
    M.unload_vimrc()
    require("vimrc")
    log.info("vimrc reloaded!")
end

function M.reload_plugin(name)
    require("plenary.reload").reload_module(name, true)
    require(name)
end



return M
