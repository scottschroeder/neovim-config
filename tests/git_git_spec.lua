local git = require("rc.plugins.git.git")

describe("git smart_pr_base_ref", function()
  local original_stack_candidates
  local original_resolve_commit_sha
  local original_is_ancestor

  before_each(function()
    original_stack_candidates = git.stack_candidates
    original_resolve_commit_sha = git.resolve_commit_sha
    original_is_ancestor = git.is_ancestor
  end)

  after_each(function()
    git.stack_candidates = original_stack_candidates
    git.resolve_commit_sha = original_resolve_commit_sha
    git.is_ancestor = original_is_ancestor
  end)

  it("uses first stack ref when it is not merged into trunk", function()
    git.stack_candidates = function()
      return { "stack/one" }
    end
    git.resolve_commit_sha = function(ref)
      if ref == "origin/main" then
        return "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      end
      return nil
    end
    git.is_ancestor = function()
      return false
    end

    assert.equals("stack/one", git.smart_pr_base_ref())
  end)

  it("falls back to origin/main when first stack ref is stale", function()
    git.stack_candidates = function()
      return { "stack/old", "stack/newer" }
    end
    git.resolve_commit_sha = function(ref)
      if ref == "origin/main" then
        return "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      end
      return nil
    end
    git.is_ancestor = function(ancestor, descendant)
      return ancestor == "stack/old" and descendant == "origin/main"
    end

    assert.equals("origin/main", git.smart_pr_base_ref())
  end)

  it("uses origin/master when origin/main is missing", function()
    git.stack_candidates = function()
      return {}
    end
    git.resolve_commit_sha = function(ref)
      if ref == "origin/master" then
        return "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
      end
      return nil
    end

    assert.equals("origin/master", git.smart_pr_base_ref())
  end)

  it("returns stack ref when trunk refs do not exist", function()
    git.stack_candidates = function()
      return { "stack/only" }
    end
    git.resolve_commit_sha = function()
      return nil
    end

    assert.equals("stack/only", git.smart_pr_base_ref())
  end)

  it("returns nil when no stack or trunk ref exists", function()
    git.stack_candidates = function()
      return {}
    end
    git.resolve_commit_sha = function()
      return nil
    end

    assert.is_nil(git.smart_pr_base_ref())
  end)
end)
