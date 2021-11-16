local M = {}
local initialized = false
local identifier = "projecticle"
local log = require("vimrc.log")
local async = require "plenary.async"

local src = require("vimrc.project.list")

local path = require("plenary.path")

local function check_config(opts)
    opts = opts or {}
    vim.validate({config = {opts, 'table', true}})
    return vim.tbl_deep_extend('keep', opts, {
        do_thing = true,
        sub_thing = {
            other = true,
            list = {'a', 'b', 'c'},
            optthing = nil
        },
        key_map = {
            open = '<Leader>p',
        },
    })
end


local function load(name)
  local json_path = M.data_dir():joinpath(name .. ".json")
  log.trace("read file", json_path:__tostring())
  local json_data = json_path:read()
  local data = vim.json.decode(json_data)
  log.trace(data)
  return data
end

local function hacks()
  local data = load("foo")

  local sources = src.Sources()
  local e1 = src.Entry("foo")
  local e2 = src.Entry("bar")
  local l1 = src.List({
    source = "setup",
    sync = false,
    items = {e1, e2}
  })
  sources:add(l1)
  log.trace("sources:", sources:get_all_paths())

  sources.sources["setup"]:do_sync(M.data_dir())

  local s2 = src.List:load_file(M.data_dir(), "setup")
  log.trace("s2:", sources:get_all_paths())

end

function M.setup(opts)
  if initialized then
    return
  end
  log.trace("init plugin", identifier)
  M.config = check_config(opts)
  M.data_dir():mkdir({exist_ok = true, parents=true})
  hacks()
  initialized = true
end

function M.data_dir()
  local p = path.new(vim.fn.stdpath("data"))
  return p:joinpath(identifier)
end

return M
