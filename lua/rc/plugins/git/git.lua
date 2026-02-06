local model = require("rc.plugins.git.model")

local M = {}

local function git_lines(args)
  local cmd = vim.list_extend({ "git" }, args)
  local lines = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    return {}
  end
  return lines
end

local function dedupe(items)
  local seen = {}
  local out = {}
  for _, item in ipairs(items) do
    if item ~= "" and not seen[item] then
      seen[item] = true
      table.insert(out, item)
    end
  end
  return out
end

function M.resolve_commit_sha(ref)
  local sha = git_lines({
    "rev-parse",
    "--verify",
    "--quiet",
    "--end-of-options",
    ref .. "^{commit}",
  })[1]
  if not sha or sha == "" then
    return nil
  end
  return sha
end

function M.branch_name()
  local branch = git_lines({ "rev-parse", "--abbrev-ref", "HEAD" })[1]
  if not branch or branch == "" then
    return nil
  end
  return branch
end

function M.stack_candidates()
  local current = M.branch_name()
  local refs = git_lines({
    "for-each-ref",
    "--merged",
    "HEAD",
    "--sort=-committerdate",
    "--format=%(refname:short)",
    "refs/heads",
    "refs/remotes",
  })

  local blocked = {
    ["HEAD"] = true,
    ["origin/HEAD"] = true,
    ["main"] = true,
    ["master"] = true,
    ["origin/main"] = true,
    ["origin/master"] = true,
  }
  if current then
    blocked[current] = true
  end

  local out = {}
  for _, ref in ipairs(refs) do
    if not blocked[ref] then
      table.insert(out, ref)
    end
  end
  return dedupe(out)
end

function M.all_recent_refs()
  local lines = git_lines({
    "for-each-ref",
    "--sort=-creatordate",
    "--format=%(refname)\t%(objectname)\t%(*objectname)\t%(creatordate:short)\t%(creatordate:relative)",
    "refs/heads",
    "refs/remotes",
    "refs/tags",
  })

  local out = {}
  for _, line in ipairs(lines) do
    local parsed = model.parse_recent_ref_line(line)
    if parsed then
      table.insert(out, parsed)
    end
  end

  return out
end

return M
