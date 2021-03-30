local lsp_status = require('lsp-status')
local is_buf_blacklisted = require('vimrc.dev.lsp.utils').is_buf_blacklisted

lsp_status.config({
  kind_labels = vim.g.completion_customize_lsp_label
})

-- Register the progress handler
lsp_status.register_progress()

local messages = require('lsp-status/messaging').messages

local spinner_frames = {"⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷"}
local indicator_ok = ""
local indicator_question = ""
local indicator_crash = ""


local makeln = function(bufnr)
  bufnr = bufnr or 0
  if #vim.lsp.buf_get_clients(bufnr) == 0 then 
    if is_buf_blacklisted(bufnr) then
      return indicator_crash
    else
      return indicator_question
    end
  end
  local buf_messages = messages()

  local msgs = {}
  for _, msg in ipairs(buf_messages) do
    local contents
    if msg.progress then
      contents = msg.title
      if msg.message then contents = contents .. ' ' .. msg.message end

      if msg.percentage then contents = contents .. ' (' .. msg.percentage .. ')' end

      if msg.spinner then
        contents = spinner_frames[(msg.spinner % #spinner_frames) + 1] .. ' ' ..
                     contents
      end
    elseif msg.status then
      contents = msg.content
      if msg.uri then
        local filename = vim.uri_to_fname(msg.uri)
        filename = vim.fn.fnamemodify(filename, ':~:.')
        local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
        if #filename > space then filename = vim.fn.pathshorten(filename) end

        contents = '(' .. filename .. ') ' .. contents
      end
    else
      contents = msg.content
    end

    table.insert(msgs, contents)
  end

  local base_status = table.concat(msgs, ' ')
  local symbol = ""

  local current_function = vim.b.lsp_current_function
  if current_function and current_function ~= '' then
    symbol = symbol .. '(' .. current_function .. ') '
  end

  if base_status ~= '' then return symbol .. base_status end
  return indicator_ok
end

local statusline = function()
    return "[" .. makeln() .. "]"
end



return {
  statusline = statusline
}
