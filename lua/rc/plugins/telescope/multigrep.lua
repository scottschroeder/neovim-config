local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local core = require("rc.plugins.telescope.multigrep_core")
local M = {}
local live_multigrep

local search_history = {}
local max_history_entries = 100

local push_history = function(prompt, cwd)
  core.push_history(search_history, prompt, cwd, max_history_entries)
end

local build_history_items = function(cwd)
  return core.build_history_items(search_history, cwd)
end

local format_history_item = function(item)
  return core.format_history_item(item)
end

local get_prompt_text = function(prompt_bufnr)
  local prompt_text = nil
  local ok_picker, current_picker = pcall(action_state.get_current_picker, prompt_bufnr)

  if ok_picker and current_picker and current_picker._get_prompt then
    local ok_prompt, prompt = pcall(function()
      return current_picker:_get_prompt()
    end)
    if ok_prompt then
      prompt_text = prompt
    end
  end

  if prompt_text == nil then
    local ok_line, lines = pcall(vim.api.nvim_buf_get_lines, prompt_bufnr, 0, 1, false)
    if ok_line then
      prompt_text = lines[1] or ""
      if ok_picker and current_picker and type(current_picker.prompt_prefix) == "string" then
        local prefix = current_picker.prompt_prefix
        if prefix ~= "" and prompt_text:sub(1, #prefix) == prefix then
          prompt_text = prompt_text:sub(#prefix + 1)
        end
      end
    end
  end

  if prompt_text == nil then
    prompt_text = action_state.get_current_line()
  end

  return prompt_text
end

live_multigrep = function(opts)
  opts = opts or {}

  opts.cwd = opts.cwd or vim.uv.cwd()
  local current_filter_state = core.empty_filter_state()
  local base_entry_maker = make_entry.gen_from_vimgrep(opts)

  local filtered_entry_maker = function(line)
    local entry = base_entry_maker(line)
    return core.filter_entry(entry, current_filter_state)
  end

  local finder = finders.new_async_job({
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        current_filter_state = core.empty_filter_state()
        return nil
      end

      local parsed = core.parse_prompt(prompt)
      current_filter_state = core.compile_file_filters(parsed.file_filters)

      if parsed.pattern == "" then
        return nil
      end

      local args = { "rg" }
      if parsed.pattern ~= "" then
        table.insert(args, "-e")
        table.insert(args, parsed.pattern)
      end

      return vim.tbl_flatten({
        args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
      })
    end,
    cwd = opts.cwd,
    entry_maker = filtered_entry_maker,
  })

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = "Multi Grep (text  include  !exclude)",
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = require("telescope.sorters").empty(),
      attach_mappings = function(prompt_bufnr, map)
        vim.api.nvim_create_autocmd("BufWipeout", {
          buffer = prompt_bufnr,
          once = true,
          callback = function()
            local prompt_text = get_prompt_text(prompt_bufnr)
            push_history(prompt_text, opts.cwd)
          end,
        })

        local clear_prompt = function()
          local current_picker = action_state.get_current_picker(prompt_bufnr)
          current_picker:reset_prompt()
          current_picker:set_prompt("")
        end

        local open_history_selector = function()
          local history_items = build_history_items(opts.cwd)
          if #history_items == 0 then
            clear_prompt()
            return
          end

          local reopen_opts = vim.deepcopy(opts)

          actions.close(prompt_bufnr)

          vim.schedule(function()
            vim.ui.select(history_items, {
              prompt = "Search History",
              format_item = format_history_item,
            }, function(choice)
              local next_opts = vim.deepcopy(reopen_opts)

              if choice then
                next_opts.default_text = choice.prompt
              else
                next_opts.default_text = ""
              end

              live_multigrep(next_opts)
            end)
          end)
        end

        map("i", "<C-g>", open_history_selector)
        map("n", "<C-g>", open_history_selector)
        map("i", "<C-u>", clear_prompt)
        map("n", "<C-u>", clear_prompt)

        return true
      end,
    })
    :find()
end

M.live_multigrep = live_multigrep

return M
