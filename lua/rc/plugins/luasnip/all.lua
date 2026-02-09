require("luasnip.session.snippet_collection").clear_snippets("all")
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

local util = require("rc.plugins.luasnip.util")

ls.add_snippets("all", {
  snippet(
    { trig = "curtime", dscr = "insert the current date/time" },
    f(function()
      return os.date("%D - %H:%M")
    end)
  ),
  snippet(
    { trig = "time", dscr = "current time" },
    f(function()
      return os.date("%H:%M:%S")
    end)
  ),
  snippet(
    { trig = "date", dscr = "current date" },
    f(function()
      return os.date("%Y-%m-%d")
    end)
  ),
  snippet(
    { trig = "uuid", wordTrig = true, dscr = "insert UUID" },
    f(function()
      return util.uuid()
    end)
  ),

  snippet({
    trig = "wombat-autosnippet",
    dscr = "explode the wombat",
    snippetType = "autosnippet",
  }, t("hat wobble")),
  ls.parser.parse_snippet("expand", "-- this is what was expanded!"),
})
