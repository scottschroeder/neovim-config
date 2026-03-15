local conditions = require("heirline.conditions")
local palette = require("rc.settings.color.palette")

local colors = palette.colors.simple
local M = {}

local worktree_cache = {
  cwd = nil,
  name = nil,
}

local detect_worktree_name = function()
  local cwd = vim.fn.getcwd()
  if worktree_cache.cwd == cwd then
    return worktree_cache.name
  end

  local name = nil
  local dot_git_file = vim.fn.findfile(".git", cwd .. ";")
  if dot_git_file ~= "" then
    local first_line = vim.fn.readfile(dot_git_file, "", 1)[1]
    local gitdir = first_line and first_line:match("^gitdir:%s*(.+)%s*$")
    if gitdir ~= nil then
      name = gitdir:match("/%.git/worktrees/([^/]+)/?$")
    end
  end

  worktree_cache.cwd = cwd
  worktree_cache.name = name
  return name
end

M.GitBranch = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
  end,

  hl = { fg = colors.orange },

  { -- git branch name
    provider = function(self)
      return " " .. self.status_dict.head
    end,
    hl = { bold = true },
  },
}

M.GitWorktree = {
  condition = function(self)
    if not conditions.is_git_repo() then
      return false
    end

    self.worktree_name = detect_worktree_name()
    return self.worktree_name ~= nil
  end,

  hl = { fg = colors.yellow },

  provider = function(self)
    return string.format("(wt %s) ", self.worktree_name)
  end,
}

M.GitChanges = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  hl = { fg = colors.orange },
  { -- git branch name
    condition = function(self)
      return self.has_changes
    end,
    provider = function()
      return "("
    end,
    hl = { bold = true },
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ("+" .. count)
    end,
    hl = { fg = palette.git().add },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ("-" .. count)
    end,
    hl = { fg = palette.git().del },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ("~" .. count)
    end,
    hl = { fg = palette.git().change },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ")",
    hl = { bold = true },
  },
}

M.Git = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  hl = { fg = colors.orange },

  { -- git branch name
    provider = function(self)
      return " " .. self.status_dict.head
    end,
    hl = { bold = true },
  },
  -- You could handle delimiters, icons and counts similar to Diagnostics
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = "(",
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ("+" .. count)
    end,
    hl = { fg = palette.git().add },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ("-" .. count)
    end,
    hl = { fg = palette.git().del },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ("~" .. count)
    end,
    hl = { fg = palette.git().change },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ")",
  },
}

return M
