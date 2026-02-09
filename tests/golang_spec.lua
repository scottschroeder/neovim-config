local golang = require("golang")

describe("toggle_first_char_case", function()
  it("converts lowercase first char to uppercase", function()
    assert.equals("Hello", golang.toggle_first_char_case("hello"))
  end)

  it("converts uppercase first char to lowercase", function()
    assert.equals("hello", golang.toggle_first_char_case("Hello"))
  end)

  it("handles single character strings", function()
    assert.equals("A", golang.toggle_first_char_case("a"))
    assert.equals("z", golang.toggle_first_char_case("Z"))
  end)

  it("leaves non-alphabetic first char unchanged", function()
    assert.equals("123abc", golang.toggle_first_char_case("123abc"))
    assert.equals("_private", golang.toggle_first_char_case("_private"))
  end)

  it("handles empty string", function()
    assert.equals("", golang.toggle_first_char_case(""))
  end)
end)

describe("new_test_file", function()
  it("generates test file content with package name", function()
    local result = golang.new_test_file("mypackage")
    assert.equals("package mypackage", result[1])
    assert.equals("", result[2])
    assert.equals("import (", result[3])
    assert.equals('\t"testing"', result[4])
    assert.equals("", result[5])
    assert.equals('\t"github.com/stretchr/testify/assert"', result[6])
    assert.equals(")", result[7])
  end)

  it("returns correct number of lines", function()
    local result = golang.new_test_file("pkg")
    assert.equals(9, #result)
  end)
end)

describe("get_file_name", function()
  local original_buf_get_name

  before_each(function()
    original_buf_get_name = vim.api.nvim_buf_get_name
  end)

  after_each(function()
    vim.api.nvim_buf_get_name = original_buf_get_name
  end)

  it("returns test file path for implementation file", function()
    vim.api.nvim_buf_get_name = function()
      return "/path/to/foo.go"
    end
    local result = golang.get_file_name()
    assert.equals("/path/to/foo_test.go", result.test_file)
    assert.equals("/path/to/foo.go", result.implementation_file)
    assert.is_false(result.is_test_file)
  end)

  it("returns implementation file path for test file", function()
    vim.api.nvim_buf_get_name = function()
      return "/path/to/foo_test.go"
    end
    local result = golang.get_file_name()
    assert.equals("/path/to/foo_test.go", result.test_file)
    assert.equals("/path/to/foo.go", result.implementation_file)
    assert.is_true(result.is_test_file)
  end)

  it("handles nested directory paths", function()
    vim.api.nvim_buf_get_name = function()
      return "/deeply/nested/path/to/bar.go"
    end
    local result = golang.get_file_name()
    assert.equals("/deeply/nested/path/to/bar_test.go", result.test_file)
    assert.equals("/deeply/nested/path/to/bar.go", result.implementation_file)
    assert.is_false(result.is_test_file)
  end)

  it("handles nested directory paths for test files", function()
    vim.api.nvim_buf_get_name = function()
      return "/deeply/nested/path/to/bar_test.go"
    end
    local result = golang.get_file_name()
    assert.equals("/deeply/nested/path/to/bar_test.go", result.test_file)
    assert.equals("/deeply/nested/path/to/bar.go", result.implementation_file)
    assert.is_true(result.is_test_file)
  end)
end)
