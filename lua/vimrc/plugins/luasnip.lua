local log = require("vimrc.log")
local has_luasnip, ls = pcall(require, "luasnip")
if not has_luasnip then
  log.warn("luasnip not installed")
  return
end

local map = require("vimrc.config.mapping").map

map("i", "<M-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end)

local s = ls.snippet
local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

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

ls.snippets = {
  all = {
    s("novel", {
      t("It was a dark and stormy night on "),
      d(1, date_input, {}, "%A, %B %d of %Y"),
      t(" and the clocks were striking thirteen."),
    }),
  },
  lua = {
    s("req", fmt("local {} = require('{}')", {i(1), rep(1)})),
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
