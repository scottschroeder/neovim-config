local clipboard = require("rc.plugins.git.clipboard")
local git = require("rc.plugins.git.git")
local model = require("rc.plugins.git.model")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")

local M = {}

local trunk_refs = {
  ["origin/main"] = true,
  ["origin/master"] = true,
}

local trunk_ref_priority = {
  "origin/main",
  "origin/master",
}

local function is_trunk(item)
  if not item then
    return false
  end

  if item.primary_ref and trunk_refs[item.primary_ref] then
    return true
  end

  for _, alias in ipairs(item.aliases or {}) do
    if trunk_refs[alias] then
      return true
    end
  end

  return false
end

local function trunk_ref_token(item)
  if not item then
    return nil
  end

  for _, ref in ipairs(trunk_ref_priority) do
    if item.primary_ref == ref then
      return ref
    end
    for _, alias in ipairs(item.aliases or {}) do
      if alias == ref then
        return ref
      end
    end
  end

  return nil
end

local function ensure_highlights()
  vim.api.nvim_set_hl(0, "TelescopeDiffRefHash", { link = "Number" })
  vim.api.nvim_set_hl(0, "TelescopeDiffRefBranch", { link = "String" })
  vim.api.nvim_set_hl(0, "TelescopeDiffRefRemote", { link = "Type" })
  vim.api.nvim_set_hl(0, "TelescopeDiffRefTag", { link = "Constant" })
  vim.api.nvim_set_hl(0, "TelescopeDiffRefRef", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "TelescopeDiffRefMeta", { link = "Comment" })
  vim.api.nvim_set_hl(0, "TelescopeDiffRefTrunkLine", { bold = true })
  vim.api.nvim_set_hl(0, "TelescopeDiffRefTrunkRef", { fg = "#e9b143", bold = true })
end

local function ref_highlight(ref_type)
  if ref_type == "local_branch" then
    return "TelescopeDiffRefBranch"
  end
  if ref_type == "remote_branch" then
    return "TelescopeDiffRefRemote"
  end
  if ref_type == "tag" then
    return "TelescopeDiffRefTag"
  end
  return "TelescopeDiffRefRef"
end

local function alias_text(item)
  local aliases = {}
  for _, alias in ipairs(item.aliases or {}) do
    if alias ~= item.primary_ref then
      table.insert(aliases, alias)
    end
  end
  if #aliases == 0 then
    return ""
  end
  return " (" .. table.concat(aliases, ", ") .. ")"
end

local function truncate_text(text, max_width)
  text = text or ""
  if max_width <= 0 then
    return ""
  end
  if vim.fn.strdisplaywidth(text) <= max_width then
    return text
  end
  if max_width <= 3 then
    return string.rep(".", max_width)
  end

  local target = max_width - 3
  local out = ""
  local len = #text
  local idx = 1
  while idx <= len do
    local next_char = text:sub(idx, idx)
    local candidate = out .. next_char
    if vim.fn.strdisplaywidth(candidate) > target then
      break
    end
    out = candidate
    idx = idx + 1
  end
  return out .. "..."
end

local function pad_right(text, width)
  text = text or ""
  local w = vim.fn.strdisplaywidth(text)
  if w >= width then
    return text
  end
  return text .. string.rep(" ", width - w)
end

local function pad_left(text, width)
  text = text or ""
  local w = vim.fn.strdisplaywidth(text)
  if w >= width then
    return text
  end
  return string.rep(" ", width - w) .. text
end

local function markers_text(item)
  local markers = {}
  if item.source == "clipboard" then
    table.insert(markers, "CLIP")
  end
  if item.is_stack then
    table.insert(markers, "STACK")
  end
  return table.concat(markers, " ")
end

local function age_date_text(item)
  local parts = {}
  if item.age and item.age ~= "" then
    table.insert(parts, item.age)
  end
  if item.date and item.date ~= "" then
    table.insert(parts, item.date)
  end
  return table.concat(parts, " ")
end

local function age_text(item)
  if item.age and item.age ~= "" then
    return item.age
  end
  return ""
end

local function window_width()
  local ok, width = pcall(vim.api.nvim_win_get_width, 0)
  if ok and width and width > 0 then
    return width
  end
  return vim.o.columns
end

local function column_widths(total_width)
  local hash_w = 8
  local sep_w = 3
  local ref_min_w = 24
  local rel_w = math.max(10, math.floor(total_width * 0.16))
  local time_w_with_date = 26
  local time_w_age_only = 14

  local function compute(time_w)
    local ref_w = total_width - hash_w - rel_w - time_w - sep_w
    local rel_adjusted = rel_w
    if ref_w < ref_min_w then
      local need = ref_min_w - ref_w
      rel_adjusted = math.max(6, rel_adjusted - need)
      ref_w = total_width - hash_w - rel_adjusted - time_w - sep_w
    end
    return ref_w, rel_adjusted
  end

  local show_abs_date = true
  local time_w = time_w_with_date
  local ref_w, rel_adjusted = compute(time_w)

  if ref_w < ref_min_w then
    show_abs_date = false
    time_w = time_w_age_only
    ref_w, rel_adjusted = compute(time_w)
  end

  if ref_w < 16 then
    ref_w = 16
    rel_adjusted = math.max(4, total_width - hash_w - ref_w - time_w - sep_w)
  end

  return hash_w, ref_w, rel_adjusted, time_w, show_abs_date
end

local function clear_modified(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  vim.bo[bufnr].modified = false
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].buflisted = false
end

local function stable_substring_sorter()
  return sorters.Sorter:new({
    scoring_function = function(_, prompt, line, entry)
      local idx = (entry and entry.sort_index) or 999999
      if not prompt or prompt == "" then
        return idx
      end

      local prompt_l = prompt:lower()
      local line_l = (line or ""):lower()
      if line_l:find(prompt_l, 1, true) then
        return idx
      end

      return -1
    end,
    highlighter = function()
      return {}
    end,
  })
end

local function show_preview_text(bufnr, lines)
  vim.bo[bufnr].filetype = "git"
  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.bo[bufnr].modified = false
  vim.bo[bufnr].modifiable = false
end

local function commit_show_previewer()
  return previewers.new_buffer_previewer({
    title = "git show",
    define_preview = function(self, entry)
      local item = entry.value
      if not item or not item.ref then
        show_preview_text(self.state.bufnr, {
          "manual input",
          "",
          "Type any branch, tag, or commit hash and press <CR>.",
        })
        return
      end

      local target = item.sha or item.ref
      local header_lines = vim.fn.systemlist({
        "git",
        "--no-pager",
        "show",
        "--color=never",
        "--no-patch",
        "--date=default",
        "--format=commit %H%d%nAuthor: %an <%ae>%nDate:   %ad%n%n    %s",
        target,
      })

      if vim.v.shell_error ~= 0 then
        local error_lines = {
          "Failed to preview commit:",
          "",
          table.concat({ "git", "--no-pager", "show", target }, " "),
          "",
        }
        vim.list_extend(error_lines, header_lines)
        show_preview_text(self.state.bufnr, error_lines)
        return
      end

      local file_lines = vim.fn.systemlist({
        "git",
        "--no-pager",
        "show",
        "--color=never",
        "--pretty=format:",
        "--name-only",
        target,
      })

      if vim.v.shell_error ~= 0 then
        local error_lines = {
          "Failed to preview file list:",
          "",
          table.concat({ "git", "--no-pager", "show", "--name-only", target }, " "),
          "",
        }
        vim.list_extend(error_lines, file_lines)
        show_preview_text(self.state.bufnr, error_lines)
        return
      end

      local lines = vim.deepcopy(header_lines)
      table.insert(lines, "")
      table.insert(lines, "Files:")
      local file_count = 0
      for _, file in ipairs(file_lines) do
        if file ~= "" then
          table.insert(lines, "  " .. file)
          file_count = file_count + 1
        end
      end
      if file_count == 0 then
        table.insert(lines, "  (no files)")
      end

      show_preview_text(self.state.bufnr, lines)
    end,
  })
end

local function make_diff_ref_picker(options, callback)
  ensure_highlights()

  local telescope_entries = {}
  for _, item in ipairs(options) do
    local ref = item.primary_ref or item.ref or item.label
    local display_sha = (item.short_sha or (item.sha and item.sha:sub(1, 7)) or "manual")
    local trunk_token = trunk_ref_token(item)
    local sort_index = #telescope_entries + 1

    table.insert(telescope_entries, {
      value = item,
      sort_index = sort_index,
      ordinal = table.concat({
        display_sha,
        ref,
        table.concat(item.aliases or {}, " "),
        markers_text(item),
        age_date_text(item),
        item.date or "",
        item.age or "",
      }, " "),
      display = function()
        local total_width = math.max(40, window_width() - 2)
        local hash_w, ref_w, rel_w, time_w, show_abs_date = column_widths(total_width)
        local displayer = entry_display.create({
          separator = " ",
          items = {
            { width = hash_w },
            { width = ref_w },
            { width = rel_w },
            { width = time_w, right_justify = true },
          },
        })

        if not item.ref then
          return displayer({
            { pad_right("manual", hash_w), "TelescopePromptPrefix" },
            { pad_right("manual input...", ref_w), "TelescopeDiffRefMeta" },
            { pad_right("branch/tag/SHA", rel_w), "TelescopeDiffRefMeta" },
            { pad_left("", time_w), "TelescopeDiffRefMeta" },
          })
        end

        local ref_text = ref .. alias_text(item)
        if trunk_token and not ref_text:find(trunk_token, 1, true) then
          ref_text = trunk_token .. " | " .. ref_text
        end

        local hash_col = pad_right(truncate_text(display_sha, hash_w), hash_w)
        local ref_col = pad_right(truncate_text(ref_text, ref_w), ref_w)
        local rel_col = pad_right(truncate_text(markers_text(item), rel_w), rel_w)
        local time_text = show_abs_date and age_date_text(item) or age_text(item)
        local date_col = pad_left(truncate_text(time_text, time_w), time_w)

        if is_trunk(item) then
          local trunk_ref_col_hl = "TelescopeDiffRefTrunkLine"
          if trunk_token and ref_col:find(trunk_token, 1, true) then
            trunk_ref_col_hl = "TelescopeDiffRefTrunkRef"
          end
          return displayer({
            { hash_col, "TelescopeDiffRefTrunkLine" },
            { ref_col, trunk_ref_col_hl },
            { rel_col, "TelescopeDiffRefTrunkLine" },
            { date_col, "TelescopeDiffRefTrunkLine" },
          })
        end

        return displayer({
          { hash_col, "TelescopeDiffRefHash" },
          { ref_col, ref_highlight(item.primary_type) },
          { rel_col, "TelescopeDiffRefMeta" },
          { date_col, "TelescopeDiffRefMeta" },
        })
      end,
    })
  end

  pickers
    .new({}, {
      prompt_title = "Diff base ref",
      results_title = "Recent refs",
      layout_strategy = "vertical",
      layout_config = {
        width = 0.97,
        height = 0.95,
        prompt_position = "top",
        preview_height = 0.45,
        mirror = true,
      },
      finder = finders.new_table({
        results = telescope_entries,
        entry_maker = function(entry)
          return entry
        end,
      }),
      sorter = stable_substring_sorter(),
      previewer = commit_show_previewer(),
      attach_mappings = function(prompt_bufnr, map)
        clear_modified(prompt_bufnr)
        vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
          buffer = prompt_bufnr,
          callback = function()
            clear_modified(prompt_bufnr)
          end,
        })

        local close_prompt = function()
          clear_modified(prompt_bufnr)
          actions.close(prompt_bufnr)
        end

        map("i", "<Esc>", close_prompt)
        map("i", "<C-c>", close_prompt)
        map("n", "q", close_prompt)
        map("n", "<Esc>", close_prompt)

        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          clear_modified(prompt_bufnr)
          actions.close(prompt_bufnr)

          if not entry or not entry.value then
            return
          end

          local choice = entry.value
          if choice.ref then
            callback(model.resolve_choice_ref(choice, git.resolve_commit_sha))
            return
          end

          vim.ui.input({ prompt = "Commit or ref: " }, function(input)
            if not input or input == "" then
              return
            end
            callback(input)
          end)
        end)
        return true
      end,
    })
    :find()
end

function M.select_diff_ref(callback)
  local stack_refs = git.stack_candidates()
  local recent_refs = git.all_recent_refs()
  local registers = { vim.fn.getreg("+"), vim.fn.getreg("*"), vim.fn.getreg('"') }
  local clipboard_ref = clipboard.find_valid_ref(registers, git.resolve_commit_sha, { min_hex_len = 5 })
  local grouped = model.group_recent_refs(recent_refs, stack_refs)
  local options = model.build_options(grouped, clipboard_ref)

  table.insert(options, {
    ref = nil,
    label = "manual input... (branch/tag/SHA)",
  })

  make_diff_ref_picker(options, callback)
end

return M
