local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local M = {}

local search_history = {}
local max_history_entries = 100

local split_prompt = function(prompt)
  local pieces = vim.split(prompt, "  ")
  return {
    prompt = prompt,
    pattern = pieces[1] or "",
    glob = pieces[2] or "",
  }
end

local push_history = function(prompt, cwd)
  if not prompt or prompt == "" then
    return
  end

  local parsed = split_prompt(prompt)
  local latest = search_history[#search_history]
  if latest and latest.prompt == parsed.prompt and latest.cwd == cwd then
    return
  end

  table.insert(search_history, {
    prompt = parsed.prompt,
    pattern = parsed.pattern,
    glob = parsed.glob,
    cwd = cwd,
    ts = os.time(),
  })

  if #search_history > max_history_entries then
    table.remove(search_history, 1)
  end
end

local live_multigrep = function(opts)
  opts = opts or {}

  opts.cwd = opts.cwd or vim.uv.cwd()
  local history_index = nil

  local history_prev = function()
    if #search_history == 0 then
      return nil
    end

    if history_index == nil then
      history_index = #search_history
    else
      history_index = history_index - 1
      if history_index < 1 then
        history_index = #search_history
      end
    end

    return search_history[history_index]
  end

  local finder = finders.new_async_job({
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local parsed = split_prompt(prompt)
      local args = { "rg" }
      if parsed.pattern ~= "" then
        table.insert(args, "-e")
        table.insert(args, parsed.pattern)
      end

      if parsed.glob ~= "" then
        table.insert(args, "-g")
        table.insert(args, parsed.glob)
      end

      return vim.tbl_flatten({
        args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
      })
    end,
    cwd = opts.cwd,
    entry_maker = make_entry.gen_from_vimgrep(opts),
  })

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = "Multi Grep",
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = require("telescope.sorters").empty(),
      attach_mappings = function(prompt_bufnr, map)
        vim.api.nvim_create_autocmd("BufWipeout", {
          buffer = prompt_bufnr,
          once = true,
          callback = function()
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

            push_history(prompt_text, opts.cwd)
          end,
        })

        local use_prev_history = function()
          local history_item = history_prev()
          if not history_item then
            return
          end

          local current_picker = action_state.get_current_picker(prompt_bufnr)
          current_picker:reset_prompt()
          current_picker:set_prompt(history_item.prompt)
        end

        map("i", "<C-g>", use_prev_history)
        map("n", "<C-g>", use_prev_history)

        return true
      end,
    })
    :find()
end

M.live_multigrep = live_multigrep

return M
