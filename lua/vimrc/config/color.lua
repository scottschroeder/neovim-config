local function set_colorscheme(name)
	local cmd = "colorscheme " .. name
	return pcall(vim.api.nvim_command, cmd)
end

local function try_colorschemes(colors)
	for _, c in pairs(colors) do
		if set_colorscheme(c) then
			return
		end
	end
end

try_colorschemes({"gruvbox-material", "desert"})
