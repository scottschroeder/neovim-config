local util = require("vimrc.plugins.luasnip.go_util")
local ls = require("luasnip")
local types = require("luasnip.util.types")
local map = require("vimrc.config.mapping").map
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
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local line_begin = require("luasnip.extras.expand_conditions").line_begin

local function not_in_function()
  return not util.is_in_function()
end

local in_test_func = {
    show_condition = util.is_in_test_function,
    condition = util.is_in_test_function,
}

local in_test_file = {
    show_condition = util.is_in_test_file,
    condition = util.is_in_test_file,
}

local in_func = {
    show_condition = util.is_in_function,
    condition = util.is_in_function,
}

local not_in_func = {
    show_condition = not_in_function,
    condition = not_in_function,
}


ls.add_snippets("go", {
    snippet(
        { trig = "ife", name = "If error", dscr = "If error, return wrapped" },
        fmt("if {} != nil {{\n\treturn {}\n}}\n{}", {
            ls.i(1, "err"),
            ls.d(2, util.make_return_nodes, { 1 }),
            ls.i(0),
        }),
        in_func
    ),

    snippet(
        { trig = "main", name = "Main", dscr = "Create a main function" },
        fmta([[
          package main

          func main() {
            <>
          }
          ]], ls.i(0)),
        not_in_func
    ),

    snippet(
        { trig = "make", name = "Make", dscr = "Allocate map or slice" },
        fmt("{} {} make({})\n{}", {
            ls.i(1, "name"),
            ls.c(2, {t(":="), t("=")}),
            ls.c(3, {
                fmt("[]{}, {}", { ls.i(1, "type"), ls.i(2, "len") }),
                fmt("[]{}, 0, {}", { ls.i(1, "type"), ls.i(2, "len") }),
                fmt("map[{}]{}, {}", { ls.i(1, "keys"), ls.i(2, "values"), ls.i(3, "len") }),
            }),
            ls.i(0),
        }),
        in_func
    ),
})
