local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local ts_utils = require("nvim-treesitter.ts_utils")
local ts_locals = require("nvim-treesitter.locals")
local rep = require("luasnip.extras").rep
local ai = require("luasnip.nodes.absolute_indexer")
local log = require("rc.log")

---@class InfoData
---@field index integer
---@field err_name string

---@class SnippetNode

---Transform makes a node from the given text.
---@param text string the return type
---@param info InfoData
---@return SnippetNode
local function transform(text, info)
  ---@param template string
  ---@param default string
  ---@return SnippetNode
  local string_sn = function(template, default)
    info.index = info.index + 1
    return ls.sn(info.index, fmt(template, ls.i(1, default)))
  end
  ---@param default string
  ---@return SnippetNode
  local new_sn = function(default)
    return string_sn("{}", default)
  end

  -- cutting the name if exists.
  if text:find([[^[^\[]*string$]]) then
    text = "string"
  elseif text:find("^[^%[]*map%[[^%]]+") then
    text = "map"
  elseif text:find("%[%]") then
    text = "slice"
  elseif text:find([[ ?chan +[%a%d]+]]) then
    return ls.t("nil")
  end

  -- separating the type from the name if exists.
  local type = text:match([[^[%a%d]+ ([%a%d]+)$]])
  if type then
    text = type
  end

  if text == "int" or text == "int64" or text == "int32" then
    return new_sn("0")
  elseif text == "float32" or text == "float64" then
    return new_sn("0")
  elseif text == "error" then
    if not info then
      return ls.t("err")
    end

    info.index = info.index + 1
    return ls.c(info.index, {
      ls.t(info.err_name),
      ls.sn(nil, fmt('fmt.Errorf("{}: %w", {})', { ls.i(1), ls.t(info.err_name), })),
      ls.sn(nil, fmt('errors.Wrap({}, "{}")', { ls.t(info.err_name), ls.i(1) })),
    })
  elseif text == "bool" then
    info.index = info.index + 1
    return ls.c(info.index, { ls.i(1, "false"), ls.i(2, "true") })
  elseif text == "string" then
    return string_sn('"{}"', "")
  elseif text == "map" or text == "slice" then
    return ls.t("nil")
  elseif string.find(text, "*", 1, true) then
    return new_sn("nil")
  end

  text = text:match("[^ ]+$")
  if text == "context.Context" then
    text = "context.Background()"
  else
    -- when the type is concrete
    text = text .. "{}"
  end

  return ls.t(text)
end

---@param info InfoData
---@return SnippetNode[]
local make_panic_snippets = function(info)
  return {
    ls.t("panic(" .. info.err_name .. ")"),
    ls.sn(nil, fmt('panic(fmt.Sprintf("{}: %s", {}))', { ls.i(1), ls.t(info.err_name), })),
  }
end

local get_node_text = vim.treesitter.get_node_text
local handlers = {
  ---@param node TSNode
  ---@param info InfoData
  ---@return SnippetNode[]
  parameter_list = function(node, info)
    local result = {}

    local count = node:named_child_count()
    for idx = 0, count - 1 do
      local child = node:named_child(idx)
      if child == nil then
        break
      end
      table.insert(result, transform(get_node_text(child, 0), info))
      if idx ~= count - 1 then
        table.insert(result, ls.t({ ", " }))
      end
    end

    return result
  end,
  ---@param node TSNode
  ---@param info InfoData
  ---@return SnippetNode[]
  type_identifier = function(node, info)
    local text = get_node_text(node, 0)
    return { transform(text, info) }
  end,
}

--- @return TSNode|nil
local get_current_function_node = function()
  local cursor_node = vim.treesitter.get_node()
  -- local cursor_node = ts_utils.get_node_at_cursor()
  if cursor_node == nil then
    return nil
  end
  local scope_tree = ts_locals.get_scope_tree(cursor_node, 0)
  for _, scope in ipairs(scope_tree) do
    if
        scope:type() == "function_declaration"
        or scope:type() == "method_declaration"
        or scope:type() == "func_literal"
    then
      return scope
    end
  end
  return nil
end

--- @return TSNode|nil
local get_function_return_node = function()
  local current_function = get_current_function_node()
  if current_function == nil then
    log.error("not in a function")
    return nil
  end

  for node, s in current_function:iter_children() do
    if s == "result" then
      return node
    end
  end
  return nil
end

---@param info InfoData
---@return SnippetNode[]|nil
local snippets_for_return_values = function(info)
  local node = get_function_return_node()
  if node == nil then
    return nil
  end

  if handlers[node:type()] then
    return handlers[node:type()](node, info)
  end
  return nil
end

---@param info InfoData
---@return SnippetNode
local return_value_nodes = function(info)
  local handle_choices = {}

  local return_statement = { ls.i(1, "return ") }
  info.index = 1
  local return_values = snippets_for_return_values(info)
  if return_values ~= nil then
    for _, item in ipairs(return_values) do
      table.insert(return_statement, item)
    end
    table.insert(handle_choices, ls.sn(1, return_statement)
    )
  end

  local panic_choices = make_panic_snippets(info)
  for _, item in ipairs(panic_choices) do
    table.insert(handle_choices, item)
  end

  return ls.sn(1, { ls.c(1, handle_choices) })
end

local M = {}

M.make_return_nodes = function(args)
  local info = { index = 0, err_name = args[1][1] }
  return ls.sn(nil, { return_value_nodes(info) })
end

---Runs the command in shell.
-- @param command string
-- @return table
M.shell = function(command) --{{{
  local file = io.popen(command, "r")
  local res = {}
  for line in file:lines() do
    table.insert(res, line)
  end
  return res
end --}}}


---Returns true if the cursor in a function body.
---@return boolean
function M.is_in_function()
  return get_current_function_node() ~= nil
end

---Returns true if the cursor in a test file.
-- @return boolean
function M.is_in_test_file() --{{{
  local filename = vim.fn.expand("%:p")
  return vim.endswith(filename, "_test.go")
end --}}}

---Returns true if the cursor in a function body in a test file.
-- @return boolean
function M.is_in_test_function() --{{{
  return M.is_in_test_file() and M.is_in_function()
end                              --}}}

local charset = {}               -- Random String {{{
for i = 48, 57 do
  table.insert(charset, string.char(i))
end
for i = 65, 90 do
  table.insert(charset, string.char(i))
end
for i = 97, 122 do
  table.insert(charset, string.char(i))
end
M.random_string = function(length)
  if length == 0 then
    return ""
  end
  return M.random_string(length - 1) .. charset[math.random(1, #charset)]
end                                --}}}

M.snake_case = function(titlecase) --{{{
  -- lowercase the first letter otherwise it causes the result to start with an
  -- underscore.
  titlecase = string.lower(string.sub(titlecase, 1, 1)) .. string.sub(titlecase, 2)
  return titlecase:gsub("%u", function(c)
    return "_" .. c:lower()
  end)
end                             --}}}

M.create_t_run = function(args) --{{{
  return ls.c(1, {
    ls.t({ "" }),
    ls.sn(
      nil,
      fmt('\tt.Run("{}", {}{})\n{}', {
        ls.i(1, "Case"),
        ls.t(args[1]),
        rep(1),
        ls.d(2, M.create_t_run, ai[1]),
      })
    ),
  })
end                                   --}}}

M.mirror_t_run_funcs = function(args) --{{{
  local strs = {}
  for _, v in ipairs(args[1]) do
    local name = v:match('^%s*t%.Run%s*%(%s*".*", (.*)%)')
    if name then
      local node = string.format("func %s(t *testing.T) {{\n\tt.Parallel()\n}}\n\n", name)
      table.insert(strs, node)
    end
  end
  local str = table.concat(strs, "")
  if #str == 0 then
    return ls.t("")
  end
  return ls.sn(nil, fmt(str, {}))
end --}}}

return M
