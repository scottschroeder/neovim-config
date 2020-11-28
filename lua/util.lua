-- util.lua

local M = {}

M.proxy = {}
M.proxy_save = {}

function M.setenv(k, v)
	vim.api.nvim_exec("let $" .. k .. " = '" .. v .. "'", false)
end

function M.set_proxy(overrides)
	for k, v in pairs(overrides) do
		M.proxy[k] = v
	end
end

function M.show_proxy()
	for k, v in pairs(M.proxy) do
		print(k, v)
	end
end

function M.proxy_enabled()
	if M.proxy_save ~= {} then
		M.proxy_disable()
	end

	for k, v in pairs(M.proxy) do
		M.proxy_save[k] = os.getenv(k)
		M.setenv(k, v)
	end
end

function M.proxy_disable()
	for k, _ in pairs(M.proxy) do
		local v = M.proxy_save[k]
		if v ~= nil then
			M.setenv(k, v)
		else
			M.setenv(k, "") -- there is no unset :(
		end
	end
	M.proxy_save = {}
end

function M.with_proxy(f, ...)
	M.proxy_enabled()
	local ret = f(...)
	M.proxy_disable()
	return ret
end

function M.file_readable(name)
	local f=io.open(name,"r")
	if f~=nil then
		io.close(f)
		return true
	else
		return false
	end
end

function M.shell(cmd)
	return vim.api.nvim_exec("silent !" .. cmd, true)
end

function M.has_feature(feature)
	local viml = [[
	if has('%s')
      echo 1
	else
	  echo 0
	endif
	]]
	local cmd = string.format(viml, feature)
	local output = vim.api.nvim_exec(cmd, true)
	return "1" == output
end



-- set options
-- from: https://github.com/jamestthompson3/vimConfig
function M.setOptions(options)
	for k, v in pairs(options) do
		if v == true or v == false then
			vim.api.nvim_command('set ' .. k)
		elseif type(v) == 'table' then
			local values = ''
			for k2, v2 in pairs(v) do
				if k2 == 1 then
					values = values .. v2
				else
					values = values .. ',' .. v2
				end
			end
			vim.api.nvim_command('set ' .. k .. '=' .. values)
		else
			vim.api.nvim_command('set ' .. k .. '=' .. v)
		end
	end
end

return M
