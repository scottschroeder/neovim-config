local path = require("plenary.path")
local log = require("vimrc.log")
local cmd = require("vimrc.config.mapping").cmd
local src = require("vimrc.project.list")
local project_finder = require("vimrc.project.telescope")
local project_actions = require("vimrc.project.actions")
local recent = require("vimrc.project.recent")
local rooter = require("vimrc.project.rooter")
local fs = require("vimrc.project.fs")


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
        git_roots = {},
        extras = {},
        sources = {

        },
        precedence = {
          "extras",
          "git",
          "recent",
        }
    })
end

local function data_dir()
  local p = path.new(vim.fn.stdpath("data"))
  return p:joinpath(identifier)
end

local function define_autogroup()
  vim.cmd([[
  augroup vimrc_project
    autocmd! 
    autocmd BufReadPre,FileReadPre * :lua require("vimrc.project").observe_file()
    autocmd VimEnter,BufReadPost,BufEnter * nested :lua require("vimrc.project.rooter").rooter()
  augroup END
  ]])
end

local function create_bindings()
  cmd("ProjectList", function()
    M.project({})
  end)
  define_autogroup()
end

function M.setup(opts)
  if initialized then
    return
  end
  M.config = check_config(opts)
  data_dir():mkdir({exist_ok = true, parents=true})
  recent.init(data_dir())
  require("vimrc.project.gitsrc").init(M.config.git_roots)
  create_bindings()

  local sources = src.Sources()
  sources:add(function()
    return recent.get_list()
  end)
  sources:add(function()
    return require("vimrc.project.gitsrc").get_list()
  end)
  local extras = {}
  for _, e_opts in pairs(M.config.extras) do
    local p = path:new(e_opts.path):expand()
    extras[#extras+1] = src.Entry({
      path = p,
      title = e_opts.title or fs.get_name(path:new(p)),
      source = "extras",
    })
  end
  sources:add(function ()
    return extras
  end)
  M.sources = sources
  initialized = true
end

function M.project(opts)
  if not initialized then
    log.warn("project config requires setup({})")
    return
  end

  pickers.new(opts or {}, {
    prompt_title = 'Select a project',
    results_title = 'Projects',
    finder = project_finder.project_finder(opts, M.sources:get_projects(), M.config.precedence),
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)

      local refresh_projects = function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local finder = project_finder.project_finder(opts, M.sources:get_projects(), M.config.precedence)
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

function M.observe_file()
  local this_buffer = vim.api.nvim_buf_get_name(0)
  log.trace("observe", this_buffer)
  local root = recent.check_add(path:new(this_buffer))
  rooter.set_buf_root(0, root)
end

return M
