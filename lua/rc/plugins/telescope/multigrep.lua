local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local M = {}
local live_multigrep

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

local build_history_items = function(cwd)
  local items = {}
  local seen = {}

  for idx = #search_history, 1, -1 do
    local entry = search_history[idx]
    local key = string.format("%s\0%s", entry.prompt or "", entry.cwd or cwd or "")

    if not seen[key] then
      seen[key] = true
      table.insert(items, entry)
    end
  end

  return items
end

local format_history_item = function(item)
  local parts = { item.prompt }
  if item.glob ~= "" then
    table.insert(parts, "[" .. item.glob .. "]")
  end

  if item.cwd and item.cwd ~= "" then
    table.insert(parts, "{" .. vim.fn.fnamemodify(item.cwd, ":t") .. "}")
  end

  return table.concat(parts, " ")
end

live_multigrep = function(opts)
  opts = opts or {}

  opts.cwd = opts.cwd or vim.uv.cwd()

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
