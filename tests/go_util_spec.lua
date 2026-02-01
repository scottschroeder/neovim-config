-- Mock luasnip and its dependencies before loading go_util
package.loaded["luasnip"] = {}
package.loaded["luasnip.extras.fmt"] = { fmt = function() end }
package.loaded["luasnip.extras"] = { rep = function() end }
package.loaded["luasnip.nodes.absolute_indexer"] = {}
package.loaded["rc.log"] = { error = function() end }

local go_util = require("rc.plugins.luasnip.go_util")

describe("snake_case", function()
  it("converts basic TitleCase to snake_case", function()
    assert.equals("foo_bar", go_util.snake_case("FooBar"))
  end)

  it("converts single word", function()
    assert.equals("foo", go_util.snake_case("Foo"))
  end)

  it("handles already lowercase string", function()
    assert.equals("foo", go_util.snake_case("foo"))
  end)

  it("handles string with numbers", function()
    assert.equals("foo123_bar", go_util.snake_case("Foo123Bar"))
  end)

  it("handles all caps (current behavior)", function()
    assert.equals("f_o_o", go_util.snake_case("FOO"))
  end)

  it("handles empty string", function()
    assert.equals("", go_util.snake_case(""))
  end)
end)
