local M = {}

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function sanitize_candidate(value)
  local cleaned = trim(value)
  cleaned = cleaned:gsub("^[%(%[{<`'\"]+", "")
  cleaned = cleaned:gsub("[%]%)%}>`'\",:;]+$", "")
  return cleaned
end

local function add_candidate(candidates, seen, value)
  if not value or value == "" then
    return
  end

  local cleaned = sanitize_candidate(value)
  if cleaned == "" or seen[cleaned] then
    return
  end

  seen[cleaned] = true
  table.insert(candidates, cleaned)
end

function M.parse_candidates(line, opts)
  opts = opts or {}
  local min_hex_len = opts.min_hex_len or 5
  local candidates = {}
  local seen = {}

  if not line or line == "" then
    return candidates
  end

  add_candidate(candidates, seen, line)
  add_candidate(candidates, seen, line:match("^%S+"))
  for hex in line:gmatch("([0-9a-fA-F]+)") do
    if #hex >= min_hex_len then
      add_candidate(candidates, seen, hex)
    end
  end

  return candidates
end

function M.find_valid_ref(register_values, resolve_commit_sha, opts)
  opts = opts or {}
  local min_hex_len = opts.min_hex_len or 5

  for _, raw in ipairs(register_values or {}) do
    if raw and raw ~= "" then
      local first_line = raw:match("^[^\r\n]+")
      local line = first_line and trim(first_line) or ""
      if line ~= "" then
        local candidates = M.parse_candidates(line, { min_hex_len = min_hex_len })
        for _, candidate in ipairs(candidates) do
          local is_hex = candidate:match("^[0-9a-fA-F]+$") ~= nil
          if not is_hex or #candidate >= min_hex_len then
            local sha = resolve_commit_sha(candidate)
            if sha then
              return {
                ref = candidate,
                sha = sha,
                short_sha = sha:sub(1, 7),
              }
            end
          end
        end
      end
    end
  end

  return nil
end

return M
