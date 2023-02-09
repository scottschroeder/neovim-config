local log = require("vimrc.log")
local has_luasnip, ls = pcall(require, "luasnip")
if not has_luasnip then
  log.warn("luasnip not installed")
  return
end


local types = require("luasnip.util.types")
local map = require("vimrc.config.mapping").map

local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
-- local events = require("luasnip.util.events")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

map({ "i", "s" }, "<M-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end,
  { desc = "expand/jump snippet" }
)

map({ "i", "s" }, "<M-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { desc = "luasnip jump(-1)" }
)

map({ "i" }, "<M-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { desc = "luasnip change choice" })

ls.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  -- enable_autosnippets = true,
})

-- Returns a snippet_node wrapped around an insert_node whose initial
-- text value is set to the current date in the desired format.
local date_input = function(_, _, fmt_str)
  fmt_str = fmt_str or "%Y-%m-%d"
  return sn(nil, i(1, os.date(fmt_str)))
end

ls.cleanup()

require "string"

local get_last_dot = function(name)
  local split_at = 1
  for idx = 1, #name do
    if "." == name:sub(idx, idx) then
      split_at = idx + 1
    end
  end
  return name:sub(split_at, #name)
end
local make_module_var = function(name)
  name = get_last_dot(name)
  name = string.gsub(name, "-", "_")
  return name
end

local map_node = function(index, map_f)
  return f(function(arg)
    return { map_f(arg[1][1]) }
  end, { index })
end

ls.add_snippets("all", {
  s("curtime", f(function()
    return os.date "%D - %H:%M"
  end)),
})



ls.add_snippets("lua", {
  s("req", fmt("local {} = require('{}')", { map_node(1, make_module_var), i(1) })),
})


ls.add_snippets("rust", {
  s("tfn", {
    t({ "#[test]", "fn " }),
    i(1, "test_thing"),
    t({ "() {", "\t" }),
    i(0),
    t({ "", "}" }),
  }),
  s(
    "tmod",
    fmt(
      [[
        #[cfg(test)]
        mod test {{
        {}

          {}
        }}
      ]],
      {
        c(1, { t "    use super::*;", t "" }),
        i(0),
      }
    )
  ),
  s(
    "pd",
    fmt([[println!("{}: {{:?}}", {});]], { rep(1), i(1) })
  ),
})
