
local M = {}

function M.projects()
	local p = vim.api.nvim_get_var("PROJECTION_PROJECTS")
	if p == nil then
		p = {}
	end
	return p
end

local function set_projects(projects)
	vim.g.PROJECTION_PROJECTS = projects
end

function M.add_project(new_project)
	local p = M.projects()
	p[#p+1] = new_project
	set_projects(p)
end

function M.switch_project(p)
	vim.api.nvim_command("lcd " .. p)
end

function M.pprojects()
	for _, v in ipairs(M.projects()) do
		print(v)
	end
end

return M
