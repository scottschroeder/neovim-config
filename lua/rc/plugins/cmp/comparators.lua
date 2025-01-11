local cmp = require("cmp")
local types = require('cmp.types')

local M = {}
-- MY CUSTOM cmp.config.compare.kind
local compare_kind_with_priority = function(priority_list)
  local index = {}
  for k, v in pairs(priority_list) do
    index[v] = k
  end

  return function(entry1, entry2)
    local kind1 = entry1:get_kind()
    local kind2 = entry2:get_kind()
    if kind1 ~= kind2 then
      local p1 = index[kind1] or (kind1 + 1000)
      local p2 = index[kind2] or (kind2 + 1000)
      local diff = p1 - p2
      if diff < 0 then
        return true
      elseif diff > 0 then
        return false
      end
    end
  end
end

local cmp_underscore = function(entry1, entry2)
  local _, entry1_under = entry1.completion_item.label:find "^_+"
  local _, entry2_under = entry2.completion_item.label:find "^_+"
  entry1_under = entry1_under or 0
  entry2_under = entry2_under or 0
  if entry1_under > entry2_under then
    return false
  elseif entry1_under < entry2_under then
    return true
  end
end

local copilot_buffer_last = function(entry1, entry2)
  local s1 = entry1.source.name
  local s2 = entry2.source.name
  if not (s1 == "copilot" or s2 == "copilot" or s1 == "buffer" or s2 == "buffer") then
    return nil
  elseif s1 == s2 then
    return nil
  end

  if s1 == "copilot" and s2 == "buffer" then
    return true
  elseif s1 == "buffer" and s2 == "copilot" then
    return false
  end
  return s2 == "buffer" or s2 == "copilot"
end


M.comparators = {
  copilot_buffer_last,
  cmp.config.compare.offset,
  cmp.config.compare.exact,
  cmp.config.compare.score,
  -- cmp.config.compare.recently_used,
  -- cmp.config.compare.locality,

  -- copied from cmp-under, but I don't think I need the plugin for this.
  -- I might add some more of my own.
  -- Move entries that start with `_` to the end
  cmp_underscore,

  compare_kind_with_priority({
    -- Free Objects
    types.lsp.CompletionItemKind.Variable,
    types.lsp.CompletionItemKind.Function,

    -- Direct Children
    types.lsp.CompletionItemKind.EnumMember,
    types.lsp.CompletionItemKind.Field,
    types.lsp.CompletionItemKind.Method,
    types.lsp.CompletionItemKind.Property,

    -- Types
    types.lsp.CompletionItemKind.Struct,
    types.lsp.CompletionItemKind.Enum,

    -- Nearby-ish things?
    types.lsp.CompletionItemKind.Interface,
    types.lsp.CompletionItemKind.Class,
    types.lsp.CompletionItemKind.Module,

    -- Other
    types.lsp.CompletionItemKind.Constructor,
    types.lsp.CompletionItemKind.Constant,
    types.lsp.CompletionItemKind.Unit,
    types.lsp.CompletionItemKind.Value,
    types.lsp.CompletionItemKind.Keyword,
    types.lsp.CompletionItemKind.Snippet,
    types.lsp.CompletionItemKind.Color,
    types.lsp.CompletionItemKind.File,
    types.lsp.CompletionItemKind.Reference,
    types.lsp.CompletionItemKind.Folder,
    types.lsp.CompletionItemKind.Event,
    types.lsp.CompletionItemKind.Operator,
    types.lsp.CompletionItemKind.TypeParameter,
    types.lsp.CompletionItemKind.Text,
  }),

  -- cmp.config.compare.sort_text,
  cmp.config.compare.length,
  cmp.config.compare.order,
}

return M
