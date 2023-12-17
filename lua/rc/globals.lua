local log = require("rc.log")

local function expand_to_lines(str)
  local result = {}
  for line in str:gmatch '[^\n]+' do
    table.insert(result, line)
  end
  return result
end

local function scratch(text)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, expand_to_lines(text))
  vim.api.nvim_set_current_buf(buf)
end

function _G.LOG(...)
  log.info(...)
end

function _G.INSPECT(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  scratch(unpack(objects))
end

