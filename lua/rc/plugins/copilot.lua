return {
  {
    "zbirenbaum/copilot.lua",
    config = function()
      local log = require("rc.log")

      local copilot = require("copilot")

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

        local ft_include = ft[filetype] or true
        if not ft_include then
          return false
        end

        -- Search the entire filepath and ignore any of the following
        local matches = {
          '%.env',
          '%.pem',
          '%.key',
          '%.p12',
          '%.jks',
          '%.sqlite',
          '%.db',
          '%.json',
          '%.csv',
          '%.bak',
          '%.old',
          '%.git%-credentials',
          'credentials%.json',
          '%.log',
          '%.tfplan',
          '%.tfstate',
          '%.azure/',
          '%.aws/',
          '%.gcp/',
          '%.kube/',
          '%.ssh/',
          'secret',

        }

        for _, match in ipairs(matches) do
          if string.match(filepath, match) then
            return false
          end
        end

        -- we have no reason not to run copilot
        return true
      end

      local is_copilot_enabled = function()
        local filepath = vim.api.nvim_buf_get_name(0)
        local filename = vim.fs.basename(filepath)
        local filetype = string.lower(vim.api.nvim_buf_get_option(0, 'filetype'))

        local enabled = copilot_rules(filepath, filename, filetype)

        -- log.warn("copilot enabled=", enabled, "ft=", filetype, "path:", filename, filepath)
        return enabled
      end

      copilot.setup({
        panel = { enabled = false, },
        suggestion = { enabled = false, },
        filetypes = {
          ["*"] = is_copilot_enabled,
        },
        copilot_node_command = 'node', -- Node.js version must be > 18.x
        server_opts_overrides = {
          settings = {
            advanced = {
              indentationMode = {
                python = true,
                go = true,
                ["*"] = true,
              },
            },
          }
        },
      })
    end
  },
}
