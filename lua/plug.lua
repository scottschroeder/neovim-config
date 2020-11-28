-- plug.lua
--
-- Helpers for managing the plugin manager helper

local util = require("util")
local home = os.getenv("HOME")
local M = {}

local plug_url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
local plug_dir = "/.vim/plugged"

local function get_plug_package_path()
	local path = home .. "/.config/nvim/autoload/plug.vim"
	return path
end

local function download_plug_package()
	curl = "curl -fLo " .. get_plug_package_path() .. " --create-dirs " .. plug_url
	util.with_proxy(util.shell, curl)
end

local function cmd_plug_begin()
	full_path = home .. plug_dir
	local cmd = "call plug#begin('" .. full_path .. "')"
	vim.api.nvim_command(cmd)
end

local function cmd_plug_end()
	vim.api.nvim_command("call plug#end()")
end

local function is_valid_string(s)
	return type(s) == "string" and s ~= ""
end

local function cmd_plug(pkg, settings)
	local cmd = "Plug '" .. pkg .. "'"
	if is_valid_string(settings) then
		cmd = cmd .. ", " .. settings
	end
	vim.api.nvim_command(cmd)
end

function M.is_plug_installed()
	return util.file_readable(get_plug_package_path())
end

function M.check_or_get_plug()
	if not M.is_plug_installed() then
		download_plug_package()
	end
end

function M.configure_plugins(plugins)
	M.check_or_get_plug()
	cmd_plug_begin()
	for name, settings in pairs(plugins) do
		cmd_plug(name, settings)
	end
	cmd_plug_end()
end

return M
