local model = require("rc.plugins.git.model")

describe("git model classify_ref", function()
  it("classifies local branch refs", function()
    local t, ref = model.classify_ref("refs/heads/feature/test")
    assert.equals("local_branch", t)
    assert.equals("feature/test", ref)
  end)

  it("classifies remote branch refs", function()
    local t, ref = model.classify_ref("refs/remotes/origin/main")
    assert.equals("remote_branch", t)
    assert.equals("origin/main", ref)
  end)

  it("classifies tag refs", function()
    local t, ref = model.classify_ref("refs/tags/v1.2.3")
    assert.equals("tag", t)
    assert.equals("v1.2.3", ref)
  end)
end)

describe("git model parse_recent_ref_line", function()
  it("uses peeled sha for annotated tags", function()
    local parsed = model.parse_recent_ref_line(
      "refs/tags/v1.0.0\tdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef\tabcdef0123456789abcdef0123456789abcdef01\t2026-02-01\t2 days ago"
    )
    assert.equals("v1.0.0", parsed.ref)
    assert.equals("abcdef0123456789abcdef0123456789abcdef01", parsed.sha)
    assert.equals("abcdef0", parsed.short_sha)
    assert.equals("tag", parsed.ref_type)
  end)

  it("filters remote HEAD refs", function()
    local parsed = model.parse_recent_ref_line("refs/remotes/origin/HEAD\tabc\t\t2026-02-01\t2 days ago")
    assert.is_nil(parsed)
  end)

  it("does not filter local refs ending in /HEAD", function()
    local parsed = model.parse_recent_ref_line(
      "refs/heads/feature/HEAD\tabcdef0123456789abcdef0123456789abcdef01\t\t2026-02-01\t2 days ago"
    )
    assert.is_not_nil(parsed)
    assert.equals("feature/HEAD", parsed.ref)
    assert.equals("local_branch", parsed.ref_type)
  end)
end)

describe("git model group and options", function()
  it("prefers local branch over remote and tag for same sha", function()
    local recent = {
      {
        ref = "origin/feature",
        sha = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        short_sha = "aaaaaaa",
        date = "2026-02-01",
        age = "1 day ago",
        ref_type = "remote_branch",
      },
      {
        ref = "v1.0.0",
        sha = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        short_sha = "aaaaaaa",
        date = "2026-02-01",
        age = "1 day ago",
        ref_type = "tag",
      },
      {
        ref = "feature",
        sha = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        short_sha = "aaaaaaa",
        date = "2026-02-01",
        age = "1 day ago",
        ref_type = "local_branch",
      },
    }

    local grouped = model.group_recent_refs(recent, { "origin/feature" })
    assert.equals(1, #grouped)
    assert.equals("feature", grouped[1].primary_ref)
    assert.is_true(grouped[1].is_stack)
  end)

  it("keeps options with colliding short shas", function()
    local grouped = {
      {
        sha = "abcdef0123456789abcdef0123456789abcdef01",
        short_sha = "abcdef0",
        primary_ref = "feature-a",
        primary_type = "local_branch",
        aliases = { "feature-a" },
        date = "2026-02-01",
        age = "1 day ago",
      },
      {
        sha = "abcdef0fffffffffffffffffffffffffffffffff0",
        short_sha = "abcdef0",
        primary_ref = "feature-b",
        primary_type = "local_branch",
        aliases = { "feature-b" },
        date = "2026-01-30",
        age = "3 days ago",
      },
    }

    local options = model.build_options(grouped, nil)
    assert.equals(2, #options)
    assert.equals("feature-a", options[1].ref)
    assert.equals("feature-b", options[2].ref)
  end)
end)

describe("git model resolve_choice_ref", function()
  it("returns nil for nil choice", function()
    local picked = model.resolve_choice_ref(nil, function()
      return nil
    end)
    assert.is_nil(picked)
  end)

  it("returns matching alias when preferred ref points elsewhere", function()
    local choice = {
      ref = "feature",
      primary_ref = "feature",
      aliases = { "feature", "origin/feature" },
      sha = "1111111111111111111111111111111111111111",
    }

    local resolve = function(candidate)
      if candidate == "feature" then
        return "2222222222222222222222222222222222222222"
      end
      if candidate == "origin/feature" then
        return "1111111111111111111111111111111111111111"
      end
      return nil
    end

    local picked = model.resolve_choice_ref(choice, resolve)
    assert.equals("origin/feature", picked)
  end)
end)
