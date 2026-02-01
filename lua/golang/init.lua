local M = {}

M.get_package_name = function(bufnr)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "go")
  if not ok or not parser then
    return nil
  end

  local tree = parser:parse()[1]
  local root = tree:root()

  local query = vim.treesitter.query.get("go", "package-name")
  if not query then
    return nil
  end

  for _, node in query:iter_captures(root, 0) do
    return vim.treesitter.get_node_text(node, 0)
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

local function toggle_first_char_case(str)
  if str == "" then return str end
  local first = str:sub(1, 1)
  local toggled
  if first:match("%l") then     -- if lowercase
    toggled = first:upper()
  elseif first:match("%u") then -- if uppercase
    toggled = first:lower()
  else
    toggled = first -- non-alphabetical characters remain unchanged
  end
  return toggled .. str:sub(2)
end

local get_identifier = function()
  local node = vim.treesitter.get_node()
  if not node then return end
  local ident = vim.treesitter.get_node_text(node, 0)
  local is_ident = vim.tbl_contains({
      "package_identifier",
      "field_identifier",
      "type_identifier",
      "identifier",
    },
    node:type())
  if is_ident then
    return ident
  end
  return nil
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


local public_private_swap = function()
  local buf_clients = vim.lsp.get_clients({
    bufnr = 0
  })

  local ident = get_identifier()
  if ident == nil then
    return
  end

  local flipped = toggle_first_char_case(ident)

  vim.lsp.buf.rename(flipped)
end

M.get_identifier = get_identifier
M.public_private_swap = public_private_swap

-- Exported for testing
M.toggle_first_char_case = toggle_first_char_case
M.new_test_file = new_test_file
M.get_file_name = get_file_name

return M
