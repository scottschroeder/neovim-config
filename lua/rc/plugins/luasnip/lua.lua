require("luasnip.session.snippet_collection").clear_snippets("lua")
local ls = require("luasnip")
local types = require("luasnip.util.types")
local snippet = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local extract_import = function(full_import_name)
  local parts = vim.split(full_import_name, ".", true)
  local final_part = parts[#parts] or ""
  return final_part:gsub("-", "_")
end

local snippet_req = snippet(
  "req",
  fmt([[local {} = require('{}')]], {
    f(function(import_name)
      return extract_import(import_name[1][1])
    end, { 1 }),
    i(1, "default"),
  })
)

ls.add_snippets("lua", {
  ls.parser.parse_snippet("lf", "local $1 = function($2)\n  $0\nend"),
  snippet_req,
})
