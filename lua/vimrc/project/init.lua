local M = {}
local initialized = false
local identifier = "projecticle"
local log = require("vimrc.log")
local cmd = require("vimrc.config.mapping").cmd

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

local function data_dir()
  local p = path.new(vim.fn.stdpath("data"))
  return p:joinpath(identifier)
end

local function hacks()

  local sources = src.Sources()
  local e1 = src.Entry({path="~"})
  local e2 = src.Entry({path="~/src/github/scottschroeder/neovim-config"})
  local l1 = src.List({
    source = "setup",
    name = "Hacks",
    sync = false,
    items = {e1, e2}
  })
  sources:add(l1)
  -- log.trace("sources:", sources:get_all_paths())

  sources.sources["setup"]:do_sync(data_dir())
  M.sources = sources
  local s2 = src.List:load_file(data_dir(), "setup")
  log.trace("s2:", s2)

  local s3 = src.List:load_file(data_dir(), "recent")
  log.trace("s3:", s3)
end

local function create_bindings()
  cmd("ProjectList", function()
    -- log.info(M.sources:get_all_paths())
  end)
end

function M.setup(opts)
  if initialized then
    return
  end
  log.trace("init plugin", identifier)
  M.config = check_config(opts)
  data_dir():mkdir({exist_ok = true, parents=true})
  create_bindings()
  hacks()
  initialized = true
end



return M
