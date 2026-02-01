M = {}


M.reload_all = function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      local modifiable = vim.api.nvim_get_option_value("modifiable", {
        buf = buf,
      })

      if name ~= "" then
        if vim.fn.filereadable(name) == 0 then
          -- File doesn't exist: wipe the buffer
          vim.api.nvim_buf_delete(buf, { force = true })
        elseif modifiable then
          -- File exists: force reload
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("e!")
          end)
        end
      end
    end
  end
end

M.buffer_debug = function()
  local target_buf = vim.api.nvim_get_current_buf()
  local target_win = vim.api.nvim_get_current_win()
  local target_tab = vim.api.nvim_get_current_tabpage()

  local wins_before = vim.api.nvim_list_wins()
  vim.cmd("vsplit")
  local wins_after = vim.api.nvim_list_wins()

  local new_win = nil
  for _, win in ipairs(wins_after) do
    local found = false
    for _, old in ipairs(wins_before) do
      if win == old then
        found = true
        break
      end
    end
    if not found then
      new_win = win
      break
    end
  end

  if not new_win then
    new_win = vim.api.nvim_get_current_win()
  end

  vim.api.nvim_set_current_win(new_win)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
  vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
  vim.api.nvim_set_option_value("filetype", "bufferdebug", { buf = buf })

  local function split_lines(value)
    return vim.split(value, "\n", { plain = true })
  end

  local function inspect_lines(value)
    return split_lines(vim.inspect(value))
  end

  local function add_line(lines, text)
    for _, line in ipairs(split_lines(text)) do
      table.insert(lines, line)
    end
  end

  local function append_section(lines, title, value)
    table.insert(lines, "")
    add_line(lines, title)
    for _, line in ipairs(inspect_lines(value)) do
      table.insert(lines, line)
    end
  end

  local bufinfo = (vim.fn.getbufinfo(target_buf) or {})[1] or {}
  local wininfo = (vim.fn.getwininfo(target_win) or {})[1] or {}
  local buf_vars = vim.fn.getbufvar(target_buf, "")
  local win_vars = vim.fn.getwinvar(target_win, "")

  local all_opts = vim.api.nvim_get_all_options_info()
  local buf_opts = {}
  local win_opts = {}
  for name, info in pairs(all_opts) do
    if info.scope == "buf" then
      buf_opts[name] = vim.api.nvim_get_option_value(name, { buf = target_buf })
    elseif info.scope == "win" then
      win_opts[name] = vim.api.nvim_get_option_value(name, { win = target_win })
    end
  end

  local buf_name = vim.api.nvim_buf_get_name(target_buf)
  if buf_name == "" then
    buf_name = "(empty)"
  end

  local win_config = vim.api.nvim_win_get_config(target_win)
  local win_for_buf = vim.fn.win_findbuf(target_buf)

  local lines = {}
  add_line(lines, "Buffer Debug Summary (likely identifiers)")
  add_line(lines, "")
  add_line(lines, ("bufnr: %d"):format(target_buf))
  add_line(lines, ("name: %s"):format(buf_name))
  add_line(lines, ("filetype: %s"):format(vim.api.nvim_get_option_value("filetype", { buf = target_buf })))
  add_line(lines, ("buftype: %s"):format(vim.api.nvim_get_option_value("buftype", { buf = target_buf })))
  add_line(lines, ("bufhidden: %s"):format(vim.api.nvim_get_option_value("bufhidden", { buf = target_buf })))
  add_line(lines, ("swapfile: %s"):format(tostring(vim.api.nvim_get_option_value("swapfile", { buf = target_buf }))))
  add_line(lines, ("modifiable: %s"):format(tostring(vim.api.nvim_get_option_value("modifiable", { buf = target_buf }))))
  add_line(lines, ("readonly: %s"):format(tostring(vim.api.nvim_get_option_value("readonly", { buf = target_buf }))))
  add_line(lines, ("winid: %d"):format(target_win))
  add_line(lines, ("winnr: %s"):format(tostring(vim.fn.win_id2win(target_win))))
  add_line(lines, ("tabpage: %d"):format(target_tab))
  add_line(lines, ("win config: %s"):format(vim.inspect(win_config)))
  add_line(lines, ("win_findbuf: %s"):format(vim.inspect(win_for_buf)))
  add_line(lines, ("b: vars count: %d"):format(vim.tbl_count(buf_vars)))
  add_line(lines, ("w: vars count: %d"):format(vim.tbl_count(win_vars)))

  append_section(lines, "Full bufinfo", bufinfo)
  append_section(lines, "Full wininfo", wininfo)
  append_section(lines, "Buffer options", buf_opts)
  append_section(lines, "Window options", win_opts)
  append_section(lines, "Buffer variables (b:)", buf_vars)
  append_section(lines, "Window variables (w:)", win_vars)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
end




return M
