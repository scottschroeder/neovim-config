local core = require("rc.plugins.telescope.multigrep_core")

local function fake_regex(match_fn)
  return {
    match_str = function(_, value)
      if match_fn(value) then
        return 0
      end
      return nil
    end,
  }
end

describe("telescope multigrep core parse_prompt", function()
  it("parses search text and no filters", function()
    local parsed = core.parse_prompt("needle")
    assert.equals("needle", parsed.pattern)
    assert.same({}, parsed.file_filters)
  end)

  it("uses two spaces as a delimiter", function()
    local parsed = core.parse_prompt("needle one  lua")
    assert.equals("needle one", parsed.pattern)
    assert.same({ { pattern = "lua", exclude = false } }, parsed.file_filters)
  end)

  it("parses include and exclude filters", function()
    local parsed = core.parse_prompt("needle  lua  !vendor")
    assert.equals("needle", parsed.pattern)
    assert.same({
      { pattern = "lua", exclude = false },
      { pattern = "vendor", exclude = true },
    }, parsed.file_filters)
  end)

  it("ignores empty and lone bang filter segments", function()
    local parsed = core.parse_prompt("needle  !  ")
    assert.equals("needle", parsed.pattern)
    assert.same({}, parsed.file_filters)
  end)
end)

describe("telescope multigrep core compile_file_filters", function()
  it("compiles include and exclude filters", function()
    local compiled = core.compile_file_filters({
      { pattern = "lua", exclude = false },
      { pattern = "vendor", exclude = true },
    }, function(pattern)
      return fake_regex(function(value)
        return value:find(pattern, 1, true) ~= nil
      end)
    end)

    assert.is_true(compiled.is_valid)
    assert.equals(1, #compiled.include_regexes)
    assert.equals(1, #compiled.exclude_regexes)
  end)

  it("marks filter state invalid when compile fails", function()
    local compiled = core.compile_file_filters({
      { pattern = "ok", exclude = false },
      { pattern = "bad", exclude = true },
    }, function(pattern)
      if pattern == "bad" then
        error("bad pattern")
      end
      return fake_regex(function(value)
        return value:find(pattern, 1, true) ~= nil
      end)
    end)

    assert.is_false(compiled.is_valid)
    assert.equals(1, #compiled.include_regexes)
    assert.equals(0, #compiled.exclude_regexes)
  end)
end)

describe("telescope multigrep core filter_entry", function()
  it("returns entry with empty filter state", function()
    local entry = { filename = "lua/thing.lua" }
    assert.same(entry, core.filter_entry(entry, core.empty_filter_state()))
  end)

  it("requires include match", function()
    local state = {
      include_regexes = { fake_regex(function(v)
        return v:find("%.lua$") ~= nil
      end) },
      exclude_regexes = {},
      is_valid = true,
    }

    assert.is_not_nil(core.filter_entry({ filename = "x.lua" }, state))
    assert.is_nil(core.filter_entry({ filename = "x.txt" }, state))
  end)

  it("applies exclude after include", function()
    local state = {
      include_regexes = { fake_regex(function(v)
        return v:find("src/") ~= nil
      end) },
      exclude_regexes = { fake_regex(function(v)
        return v:find("vendor/") ~= nil
      end) },
      is_valid = true,
    }

    assert.is_nil(core.filter_entry({ filename = "src/vendor/a.lua" }, state))
    assert.is_not_nil(core.filter_entry({ filename = "src/app/a.lua" }, state))
  end)

  it("drops all entries for invalid state", function()
    local state = {
      include_regexes = {},
      exclude_regexes = {},
      is_valid = false,
    }
    assert.is_nil(core.filter_entry({ filename = "anything" }, state))
  end)
end)

describe("telescope multigrep core history", function()
  it("ignores empty prompt entries", function()
    local history = {}
    local added = core.push_history(history, "", "/tmp", 10)
    assert.is_false(added)
    assert.equals(0, #history)
  end)

  it("dedupes only consecutive identical prompt and cwd", function()
    local history = {}
    assert.is_true(core.push_history(history, "needle", "/a", 10))
    assert.is_false(core.push_history(history, "needle", "/a", 10))
    assert.is_true(core.push_history(history, "needle", "/b", 10))
    assert.equals(2, #history)
  end)

  it("enforces max history size", function()
    local history = {}
    core.push_history(history, "one", "/a", 2)
    core.push_history(history, "two", "/a", 2)
    core.push_history(history, "three", "/a", 2)
    assert.equals(2, #history)
    assert.equals("two", history[1].prompt)
    assert.equals("three", history[2].prompt)
  end)

  it("builds unique history list newest first", function()
    local history = {}
    core.push_history(history, "one", "/a", 10)
    core.push_history(history, "two", "/a", 10)
    core.push_history(history, "one", "/a", 10)
    core.push_history(history, "one", "/b", 10)

    local items = core.build_history_items(history, "/a")
    assert.equals(3, #items)
    assert.equals("one", items[1].prompt)
    assert.equals("/b", items[1].cwd)
    assert.equals("one", items[2].prompt)
    assert.equals("/a", items[2].cwd)
    assert.equals("two", items[3].prompt)
  end)
end)

describe("telescope multigrep core format_history_item", function()
  it("renders filter tokens and cwd leaf", function()
    local rendered = core.format_history_item({
      prompt = "needle  lua  !vendor",
      file_filters = {
        { pattern = "lua", exclude = false },
        { pattern = "vendor", exclude = true },
      },
      cwd = "/tmp/project",
    })

    assert.equals("needle  lua  !vendor [/lua/ !/vendor/] {project}", rendered)
  end)
end)
