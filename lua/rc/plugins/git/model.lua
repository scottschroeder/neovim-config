local M = {}

local type_priority = {
  local_branch = 1,
  remote_branch = 2,
  tag = 3,
  ref = 4,
}

local type_label = {
  local_branch = "branch",
  remote_branch = "remote",
  tag = "tag",
  ref = "ref",
}

local function starts_with(str, prefix)
  return str:sub(1, #prefix) == prefix
end

local function split_tab(line)
  local out = {}
  for part in (line .. "\t"):gmatch("(.-)\t") do
    table.insert(out, part)
  end
  return out
end

function M.classify_ref(full_ref)
  if starts_with(full_ref, "refs/heads/") then
    return "local_branch", full_ref:sub(#"refs/heads/" + 1)
  end
  if starts_with(full_ref, "refs/remotes/") then
    return "remote_branch", full_ref:sub(#"refs/remotes/" + 1)
  end
  if starts_with(full_ref, "refs/tags/") then
    return "tag", full_ref:sub(#"refs/tags/" + 1)
  end
  return "ref", full_ref
end

function M.parse_recent_ref_line(line)
  local parts = split_tab(line)
  local full_ref = parts[1] or ""
  local object_sha = parts[2] or ""
  local peeled_sha = parts[3] or ""
  local date = parts[4] or ""
  local age = parts[5] or ""
  local ref_type, short_ref = M.classify_ref(full_ref)
  local sha = peeled_sha ~= "" and peeled_sha or object_sha

  local is_valid_remote_branch = ref_type ~= "remote_branch" or short_ref:find("/", 1, true) ~= nil
  local is_remote_head = ref_type == "remote_branch" and short_ref:match("/HEAD$") ~= nil
  if short_ref == "" or sha == "" or not is_valid_remote_branch or is_remote_head then
    return nil
  end

  return {
    full_ref = full_ref,
    ref = short_ref,
    sha = sha,
    short_sha = sha:sub(1, 7),
    date = date,
    age = age,
    ref_type = ref_type,
  }
end

function M.group_recent_refs(recent_refs, stack_refs)
  local stack_set = {}
  for _, ref in ipairs(stack_refs or {}) do
    stack_set[ref] = true
  end

  local grouped = {}
  local ordered_shas = {}

  for _, info in ipairs(recent_refs or {}) do
    local key = info.sha
    local current = grouped[key]
    if not current then
      current = {
        sha = info.sha,
        short_sha = info.short_sha,
        primary_ref = info.ref,
        primary_type = info.ref_type,
        aliases = {},
        alias_seen = {},
        date = info.date,
        age = info.age,
        is_stack = false,
      }
      grouped[key] = current
      table.insert(ordered_shas, key)
    end

    if not current.alias_seen[info.ref] then
      current.alias_seen[info.ref] = true
      table.insert(current.aliases, info.ref)
    end

    if stack_set[info.ref] then
      current.is_stack = true
    end

    local current_priority = type_priority[current.primary_type] or type_priority.ref
    local candidate_priority = type_priority[info.ref_type] or type_priority.ref
    if candidate_priority < current_priority then
      current.primary_ref = info.ref
      current.primary_type = info.ref_type
    end
  end

  local ordered_items = {}
  for _, sha in ipairs(ordered_shas) do
    table.insert(ordered_items, grouped[sha])
  end
  return ordered_items
end

function M.format_option_label(item)
  local aliases = {}
  for _, alias in ipairs(item.aliases or {}) do
    if alias ~= item.primary_ref then
      table.insert(aliases, alias)
    end
  end
  local alias_text = #aliases > 0 and (" (" .. table.concat(aliases, ", ") .. ")") or ""
  local stack_text = item.is_stack and "[stack] " or ""
  local kind = type_label[item.primary_type] or "ref"
  return string.format("%s %s[%s] %s%s %s (%s)", item.short_sha, stack_text, kind, item.primary_ref, alias_text,
    item.date, item.age)
end

function M.build_options(grouped_items, clipboard_ref)
  local options = {}
  local seen_by_sha = {}

  if clipboard_ref then
    local selected = nil
    for _, item in ipairs(grouped_items) do
      if item.sha == clipboard_ref.sha then
        selected = item
        break
      end
    end

    if selected then
      if not seen_by_sha[selected.sha] then
        table.insert(options, {
          ref = selected.primary_ref,
          primary_ref = selected.primary_ref,
          aliases = selected.aliases,
          sha = selected.sha,
          label = "clipboard: " .. M.format_option_label(selected),
        })
        seen_by_sha[selected.sha] = true
      end
    else
      if not seen_by_sha[clipboard_ref.sha] then
        table.insert(options, {
          ref = clipboard_ref.ref,
          sha = clipboard_ref.sha,
          label = string.format("clipboard: %s [%s]", clipboard_ref.ref, clipboard_ref.short_sha),
        })
        seen_by_sha[clipboard_ref.sha] = true
      end
    end
  end

  for _, item in ipairs(grouped_items) do
    if item and not seen_by_sha[item.sha] then
      table.insert(options, {
        ref = item.primary_ref,
        primary_ref = item.primary_ref,
        aliases = item.aliases,
        sha = item.sha,
        label = M.format_option_label(item),
      })
      seen_by_sha[item.sha] = true
    end
  end

  return options
end

function M.resolve_choice_ref(choice, resolve_commit_sha)
  if not choice then
    return nil
  end

  local sha = choice and choice.sha or nil
  if not sha then
    return choice.ref
  end

  local preferred = choice.ref
  if preferred and resolve_commit_sha(preferred) == sha then
    return preferred
  end

  if choice.primary_ref and resolve_commit_sha(choice.primary_ref) == sha then
    return choice.primary_ref
  end

  if choice.aliases then
    for _, alias in ipairs(choice.aliases) do
      if resolve_commit_sha(alias) == sha then
        return alias
      end
    end
  end

  return sha
end

return M
