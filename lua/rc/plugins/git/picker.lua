local clipboard = require("rc.plugins.git.clipboard")
local git = require("rc.plugins.git.git")
local model = require("rc.plugins.git.model")

local M = {}

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

  vim.ui.select(options, {
    prompt = "Diff base ref",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end

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
end

return M
