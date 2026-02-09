local clipboard = require("rc.plugins.git.clipboard")

describe("git clipboard parser", function()
  it("extracts branch and sha candidates from line", function()
    local out = clipboard.parse_candidates("master 936376c1c8e13ef6658f", { min_hex_len = 5 })
    assert.equals("master 936376c1c8e13ef6658f", out[1])
    assert.equals("master", out[2])
    assert.equals("936376c1c8e13ef6658f", out[3])
  end)

  it("ignores tiny hex fragments", function()
    local out = clipboard.parse_candidates("abc1 1234 deadbeef", { min_hex_len = 5 })
    assert.is_true(vim.tbl_contains(out, "deadbeef"))
    assert.is_false(vim.tbl_contains(out, "1234"))
  end)
end)

describe("git clipboard find_valid_ref", function()
  it("accepts branch, tag, full and short shas", function()
    local mapping = {
      ["master"] = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      ["0.3.4"] = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
      ["936376c1c8e13ef6658ff4b71372c7431beb28a6"] = "936376c1c8e13ef6658ff4b71372c7431beb28a6",
      ["936376c1c8e13ef6658f"] = "936376c1c8e13ef6658ff4b71372c7431beb28a6",
      ["93637"] = "936376c1c8e13ef6658ff4b71372c7431beb28a6",
    }

    local resolve = function(candidate)
      return mapping[candidate]
    end

    assert.equals("master", clipboard.find_valid_ref({ "master" }, resolve, { min_hex_len = 5 }).ref)
    assert.equals("0.3.4", clipboard.find_valid_ref({ "0.3.4" }, resolve, { min_hex_len = 5 }).ref)
    assert.equals(
      "936376c1c8e13ef6658ff4b71372c7431beb28a6",
      clipboard.find_valid_ref({ "936376c1c8e13ef6658ff4b71372c7431beb28a6" }, resolve, { min_hex_len = 5 }).ref
    )
    assert.equals(
      "936376c1c8e13ef6658f",
      clipboard.find_valid_ref({ "936376c1c8e13ef6658f" }, resolve, { min_hex_len = 5 }).ref
    )
    assert.equals("93637", clipboard.find_valid_ref({ "93637" }, resolve, { min_hex_len = 5 }).ref)
  end)

  it("uses first line and skips unresolved values", function()
    local resolve = function(candidate)
      if candidate == "origin/master" then
        return "cccccccccccccccccccccccccccccccccccccccc"
      end
      return nil
    end

    local out = clipboard.find_valid_ref({ "not-a-ref\norigin/master" }, resolve, { min_hex_len = 5 })
    assert.is_nil(out)

    out = clipboard.find_valid_ref({ "origin/master" }, resolve, { min_hex_len = 5 })
    assert.equals("origin/master", out.ref)
  end)
end)
