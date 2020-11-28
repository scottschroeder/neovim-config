-- tools.lua

local M = {}
local api = vim.api

function M.unload(module_name)
	package.loaded[module_name] = nil
end

function M.unload_auto()
	local ok, modules = pcall(api.nvim_get_var, "lua_autoloads")
	if ok then
		for _, m in pairs(modules) do
			M.unload(m)
		end
	end
end

function M.reload_vimrc()
	local vimrc = os.getenv("MYVIMRC")
	api.nvim_command("source " .. vimrc)
end

function M.reload_nvim()
	M.unload_auto()
	M.reload_vimrc()
end

return M

