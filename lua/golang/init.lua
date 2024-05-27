local M = {}

M.get_package_name = function(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, "go")
  local tree = parser:parse()[1]
  local root = tree:root()

  vim.treesitter.query.set(
    "go",
    "PackageNameExtract",
    [[ (package_clause
    (package_identifier) @packagename
    )]]
  )

  local query = vim.treesitter.query.get("go", "PackageNameExtract")
  if query == nil then
    return nil
  end

  for _, node in query:iter_captures(root, 0) do
    local txt = vim.treesitter.get_node_text(node, 0)
    return txt
  end

  return nil
end

local function get_file_name(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or 0
  local current_file = vim.api.nvim_buf_get_name(bufnr)

  local test_match = string.match(current_file, "_test.go$")
  local is_test_file = test_match == "_test.go"

  local implementation_file
  local test_file
  if is_test_file then
    implementation_file = string.gsub(current_file, "_test.go$", ".go")
    test_file = current_file
  else
    test_file = string.gsub(current_file, ".go$", "_test.go")
    implementation_file = current_file
  end

  return {
    is_test_file = is_test_file,
    implementation_file = implementation_file,
    test_file = test_file,
  }
end

local new_test_file = function(packagename)
  return {
    "package " .. packagename,
    "",
    "import (",
    "\t\"testing\"",
    "",
    "\t\"github.com/stretchr/testify/assert\"",
    ")",
    "",
    "",
  }
end

M.switch_implementation_and_test = function()
  local file_details = get_file_name()
  local pkgname = M.get_package_name(0)
  if file_details.is_test_file then
    vim.cmd.edit(file_details.implementation_file)
  else
    vim.cmd.edit(file_details.test_file)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    if pkgname ~= nil and #lines == 1 and lines[1] == "" then
      vim.api.nvim_buf_set_lines(0, 0, -1, false, new_test_file(pkgname))
    end
  end
end

return M
