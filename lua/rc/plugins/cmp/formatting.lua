local M = {}
local icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "⌘",
  Field = "ﰠ",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "塞",
  Value = "",
  Enum = "",
  Keyword = "廓",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "פּ",
  Event = "",
  Operator = "",
  TypeParameter = "",
  Copilot = "",
}

local source_renames = {
  copilot = "GPT",
  nvim_lsp = "LSP",
}


M.formatting = {
  fields = { "kind", "abbr", "menu" },
  format = function(entry, vim_item)
    local kind = vim_item.kind
    local icon = icons[kind] or ""
    local source = entry.source.name
    local display_source = source_renames[source] or source

    -- if entry.source.name == "copilot" then
    --   vim_item.kind_hl_group = "CmpItemKindCopilot"
    -- end

    vim_item.kind = icon .. " [" .. display_source .. "]"
    vim_item.menu = kind

    return vim_item
  end,
}

return M
