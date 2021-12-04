local log = require("vimrc.log")
local has_luasnip, ls = pcall(require, "luasnip")
if not has_luasnip then
  log.warn("luasnip not installed")
  return
end

local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")

-- Returns a snippet_node wrapped around an insert_node whose initial
-- text value is set to the current date in the desired format.
local date_input = function(args, state, fmt)
  local fmt = fmt or "%Y-%m-%d"
  return sn(nil, i(1, os.date(fmt)))
end

ls.snippets = {
  all = {
    s("novel", {
      t("It was a dark and stormy night on "),
      d(1, date_input, {}, "%A, %B %d of %Y"),
      t(" and the clocks were striking thirteen."),
    }),
  },
  rust = {
    s("tfn", {
      t({"#[test]", "fn "}),
      i(1, "test_thing"),
      t({ "() {", "\t"}),
      i(0),
      t({ "", "}" }),
    }),
    s("tmod", {
      t({"#[cfg(test)]", "mod tests {", "\tuse super::*;", "", "\t"}),
      i(0),
      t({ "", "}" }),
    }),
  }
}

log.trace(ls.snippets)
