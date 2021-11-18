local path = require("plenary.path")
local log = require("vimrc.log")
local cmd = require("vimrc.config.mapping").cmd
local src = require("vimrc.project.list")
local project_finder = require("vimrc.project.telescope")
local project_actions = require("vimrc.project.actions")
local recent = require("vimrc.project.recent")

local pickers = require("telescope.pickers")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local identifier = "projecticle"

local M = {}

local initialized = false

local function check_config(opts)
    opts = opts or {}
    vim.validate({config = {opts, 'table', true}})
    return vim.tbl_deep_extend('keep', opts, {
        do_thing = true,
        hidden_files = false,
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
  local e1 = {title="$HOME", path="~"}
  local e2 = {title="Neovim Config", path="~/src/github/scottschroeder/neovim-config"}
  local l1 = src.List({
    source = "setup",
    name = "Hacks",
    sync = false,
    items = {e1, e2}
  })
  sources:add(l1)
  sources:add(recent.list)

  M.sources = sources

  -- local myfile = path:new("/home/scott/src/github/scottschroeder/astrometry/index/src/kdtree/fits.rs")
  -- recent.check_add(myfile)
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
  recent.init(data_dir())
  create_bindings()
  hacks()
  initialized = true
end

function M.project(opts)
  pickers.new(opts or {}, {
    prompt_title = 'Select a project',
    results_title = 'Projects',
    finder = project_finder.project_finder(opts, M.sources:get_projects()),
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)

      local refresh_projects = function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local finder = project_finder.project_finder(opts, M.sources:get_projects())
        picker:refresh(finder, { reset_prompt = true })
      end

      -- _actions.add_project:enhance({ post = refresh_projects })
      -- _actions.delete_project:enhance({ post = refresh_projects })
      -- _actions.rename_project:enhance({ post = refresh_projects })

      -- map('n', 'd', _actions.delete_project)
      -- map('n', 'r', _actions.rename_project)
      -- map('n', 'c', _actions.add_project)
      -- map('n', 'f', _actions.find_project_files)
      -- map('n', 'b', _actions.browse_project_files)
      -- map('n', 's', _actions.search_in_project_files)
      -- map('n', 'R', _actions.recent_project_files)
      -- map('n', 'w', _actions.change_working_directory)

      -- map('i', '<c-d>', _actions.delete_project)
      -- map('i', '<c-v>', _actions.rename_project)
      -- map('i', '<c-a>', _actions.add_project)
      -- map('i', '<c-f>', _actions.find_project_files)
      -- map('i', '<c-b>', _actions.browse_project_files)
      -- map('i', '<c-s>', _actions.search_in_project_files)
      -- map('i', '<c-r>', _actions.recent_project_files)
      -- map('i', '<c-w>', _actions.change_working_directory)

      local on_project_selected = function()
        project_actions.find_project_files(prompt_bufnr, M.config.hidden_files)
      end
      actions.select_default:replace(on_project_selected)
      return true
    end
  }):find()
end

return M
