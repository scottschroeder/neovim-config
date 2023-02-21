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
local rep = require("luasnip.extras").rep


local snippet_tmod = snippet("tmod",
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
  ))

local get_traits = function(position)
  return d(
    position,
    function()
      -- TODO LSP get traits?
      return sn(nil, c(1, {
        t("std::fmt::Debug"),
        t("std::fmt::Display"),
      }))
    end,
    {}
  )
end
local snippet_impl_trait = snippet("impltrait",
  fmt(
    [[
            impl{} {} for {}{} {{
              {}
            }}
            ]],
    {
      rep(3),
      get_traits(1),
      -- TODO treesitter get types in scope?
      i(2, "MyType"),
      c(3, { t(""), sn(1, { t("<"), i(1, "T"), t(">") }) }),
      i(0),
    }
  ))

local get_test_result = function(position)
  return d(
    position,
    function()
      local nodes = {}
      table.insert(nodes, t(" "))
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      for _, line in ipairs(lines) do
        if line:match("anyhow::Result") then
          table.insert(nodes, t(" -> Result<()> "))
          break
        end
      end

      if #nodes == 1 then
        return sn(nil, nodes[1])
      else
        return sn(nil, c(1, nodes))
      end
    end,
    {}
  )
end

local get_async = function(pos)
  return f(
    function(test_node)
      local node_text = test_node[1][1]
      if node_text == "tokio::test" then
        return "async "
      else
        return ""
      end
    end, { pos }
  )
end

local snippet_tfn = snippet("tfn",
  fmt(
    [[
              #[{}]
              {}fn {}(){}{{
                {}
              }}
            ]],
    {
      c(1, { t("test"), t("tokio::test") }),
      get_async(1),
      i(2, "testname"),
      get_test_result(3),
      i(0),
    }
  ))


ls.add_snippets("rust", {
  snippet_tmod,
  snippet_tfn,
  snippet_impl_trait,
})
