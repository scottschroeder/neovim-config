local scopes = { o = vim.o, b = vim.bo, w = vim.wo } -- luacheck: ignore 241

local function table_to_vim_string(value)
  local values = ""
  for k, v in pairs(value) do
    if k == 1 then
      values = values .. v
    else
      values = values .. "," .. v
    end
  end
  return values
end

local function opt(scope, key, value)
  if type(value) == "table" then
    value = table_to_vim_string(value)
  end

  scopes[scope][key] = value
  if scope ~= "o" then
    scopes["o"][key] = value
  end
end

return {
  opt = opt,
}
