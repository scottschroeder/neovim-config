local log = require("vimrc.log")

local ok, copilot = require("vimrc.utils").safe_reloader("copilot")
if not ok then
  return {
    setup = function()
      log.warn("copilot is not installed")
    end
  }
end

local copilot_rules = function(filepath, filename, filetype)
  local ft = {
    yaml = true,
    markdown = true,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ledger = false,
    telescopeprompt = false,
  }

  local ft_include = ft[filetype]
  if ft_include == nil then
    -- Default Value
    ft_include = true
  end


  if not ft_include then
    return false
  end

  -- disable for .env files
  if string.match(filename, '^%.env.*') then
    return false
  end

  -- disable for .pem files
  if string.match(filename, '%.pem') then
    return false
  end

  -- disable for .aws files
  if string.match(filepath, '%.aws/') then
    return false
  end

  -- we have no reason not to run copilot
  return true
end

local is_copilot_enabled = function()
  local filepath = vim.api.nvim_buf_get_name(0)
  local filename = vim.fs.basename(filepath)
  local filetype = string.lower(vim.api.nvim_buf_get_option(0, 'filetype'))

  local enabled = copilot_rules(filepath, filename, filetype)

  log.warn("copilot enabled=", enabled, "ft=", filetype, "path:", filename, filepath)
  return enabled
end


local setup = function()
  copilot.setup({
    panel = {
      enabled = false,
      auto_refresh = true,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-CR>"
      },
      layout = {
        position = "bottom", -- | top | left | right
        ratio = 0.4
      },
    },
    suggestion = {
      enabled = false,
      auto_trigger = false,
      debounce = 75,
      keymap = {
        accept = "<M-l>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      -- yaml = true,
      -- markdown = true,
      -- help = false,
      -- gitcommit = false,
      -- gitrebase = false,
      -- hgcommit = false,
      -- svn = false,
      -- cvs = false,
      -- ledger = false,
      -- sh = function()
      --   if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
      --     -- disable for .env files
      --     return false
      --   end
      --   return true
      -- end,
      ["*"] = is_copilot_enabled,
    },
    copilot_node_command = 'node', -- Node.js version must be > 18.x
    server_opts_overrides = {},
  })
end


return {
  setup = setup
}
