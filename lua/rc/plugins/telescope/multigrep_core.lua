local M = {}

local function empty_filter_state()
  return {
    include_regexes = {},
    exclude_regexes = {},
    is_valid = true,
  }
end

M.empty_filter_state = empty_filter_state

function M.parse_prompt(prompt)
  prompt = prompt or ""

  local segments = {}
  local segment_start = 1

  while true do
    local delim_start, delim_end = prompt:find("%s%s+", segment_start)
    if not delim_start then
      table.insert(segments, prompt:sub(segment_start))
      break
    end

    table.insert(segments, prompt:sub(segment_start, delim_start - 1))
    segment_start = delim_end + 1
  end

  local file_filters = {}
  for idx = 2, #segments do
    local segment = segments[idx]
    if segment ~= "" then
      local exclude = false
      if segment:sub(1, 1) == "!" then
        exclude = true
        segment = segment:sub(2)
      end

      if segment ~= "" then
        table.insert(file_filters, {
          pattern = segment,
          exclude = exclude,
        })
      end
    end
  end

  return {
    prompt = prompt,
    pattern = segments[1] or "",
    file_filters = file_filters,
  }
end

function M.compile_file_regex(pattern)
  local case_prefix = pattern:find("%u") and "\\C" or "\\c"
  return vim.regex(case_prefix .. pattern)
end

function M.compile_file_filters(file_filters, compile_regex)
  compile_regex = compile_regex or M.compile_file_regex

  local state = empty_filter_state()

  for _, filter in ipairs(file_filters or {}) do
    local ok_regex, compiled_regex = pcall(compile_regex, filter.pattern)
    if not ok_regex then
      state.is_valid = false
      break
    end

    if filter.exclude then
      table.insert(state.exclude_regexes, compiled_regex)
    else
      table.insert(state.include_regexes, compiled_regex)
    end
  end

  return state
end

function M.filter_entry(entry, filter_state)
  if not entry then
    return nil
  end

  filter_state = filter_state or empty_filter_state()
  if not filter_state.is_valid then
    return nil
  end

  if #filter_state.include_regexes == 0 and #filter_state.exclude_regexes == 0 then
    return entry
  end

  local filename = entry.filename or ""

  if #filter_state.include_regexes > 0 then
    local include_match = false
    for _, regex in ipairs(filter_state.include_regexes) do
      if regex:match_str(filename) then
        include_match = true
        break
      end
    end

    if not include_match then
      return nil
    end
  end

  for _, regex in ipairs(filter_state.exclude_regexes) do
    if regex:match_str(filename) then
      return nil
    end
  end

  return entry
end

function M.push_history(history, prompt, cwd, max_entries)
  if not prompt or prompt == "" then
    return false
  end

  local parsed = M.parse_prompt(prompt)
  local latest = history[#history]
  if latest and latest.prompt == parsed.prompt and latest.cwd == cwd then
    return false
  end

  table.insert(history, {
    prompt = parsed.prompt,
    pattern = parsed.pattern,
    file_filters = parsed.file_filters,
    cwd = cwd,
    ts = os.time(),
  })

  max_entries = max_entries or 100
  if #history > max_entries then
    table.remove(history, 1)
  end

  return true
end

function M.build_history_items(history, cwd)
  local items = {}
  local seen = {}

  for idx = #history, 1, -1 do
    local entry = history[idx]
    local key = string.format("%s\0%s", entry.prompt or "", entry.cwd or cwd or "")

    if not seen[key] then
      seen[key] = true
      table.insert(items, entry)
    end
  end

  return items
end

function M.format_history_item(item)
  local file_filters = item.file_filters or {}
  local parts = { item.prompt }

  if #file_filters > 0 then
    local rendered_filters = {}
    for _, filter in ipairs(file_filters) do
      local prefix = filter.exclude and "!" or ""
      table.insert(rendered_filters, prefix .. "/" .. filter.pattern .. "/")
    end

    table.insert(parts, "[" .. table.concat(rendered_filters, " ") .. "]")
  end

  if item.cwd and item.cwd ~= "" then
    table.insert(parts, "{" .. vim.fn.fnamemodify(item.cwd, ":t") .. "}")
  end

  return table.concat(parts, " ")
end

return M
