local log = require("vimrc.log")
local buf_var_name = "__project_root_dir"
local fs = require("vimrc.project.fs")
local Path = require("plenary.path")

local function get_buf_root(bufn)
  local status, res = pcall(vim.api.nvim_buf_get_var,bufn, buf_var_name)

  if not status then
    return nil
  end
  return res
end


local M = {}

function M.set_buf_root(bufn, root_dir)
  if root_dir == nil then
    root_dir = ""
  end
  return vim.api.nvim_buf_set_var(bufn, buf_var_name, root_dir)
end


function M.rooter()
  local root = get_buf_root(0)
  if root == nil then
    local this_buffer = vim.api.nvim_buf_get_name(0)
    log.trace("unknown root for", this_buffer, "searching...")
    root = fs.associated_project(Path:new(this_buffer))
    M.set_buf_root(0, root)
  end

  if root then
    fs.change_directory(root)
  end
end


return M
