return {
  {
    "ThePrimeagen/99",
    lazy = true,
    keys = "<leader>9",
    config = function()
      local map = require("rc.utils.map").map
      local map_prefix = require("rc.utils.map").prefix
      local usercmd = require("rc.utils.map").cmd
      local _99 = require("99")

      local function current_model()
        return _99.__get_state().model
      end

      local function set_model(model)
        local trimmed = vim.trim(model or "")
        if trimmed == "" then
          vim.notify("Model cannot be empty", vim.log.levels.WARN)
          return
        end
        _99.set_model(trimmed)
        vim.notify("99 model set to: " .. trimmed, vim.log.levels.INFO)
      end

      local function list_opencode_models(cb)
        vim.system({ "opencode", "models" }, { text = true }, function(obj)
          vim.schedule(function()
            if obj.code ~= 0 then
              local stderr = vim.trim(obj.stderr or "")
              local reason = stderr ~= "" and (": " .. stderr) or ""
              vim.notify("Unable to list opencode models" .. reason, vim.log.levels.ERROR)
              cb({})
              return
            end

            local models = {}
            for line in (obj.stdout or ""):gmatch("[^\r\n]+") do
              local model = vim.trim(line)
              if model ~= "" then
                table.insert(models, model)
              end
            end

            table.sort(models)
            cb(models)
          end)
        end)
      end

      local function pick_model()
        list_opencode_models(function(models)
          if #models == 0 then
            return
          end

          local active = current_model()
          vim.ui.select(models, {
            prompt = "Select 99 model",
            format_item = function(item)
              if item == active then
                return item .. " (current)"
              end
              return item
            end,
          }, function(choice)
            if not choice then
              return
            end
            set_model(choice)
          end)
        end)
      end

      _99.setup({
        model = "openai/gpt-5.3-codex",
        completion = {
          source = nil,
          custom_rules = {},
        },
      })

      map_prefix("<leader>9", "99")
      usercmd("NinetyNineModel", function(opts)
        set_model(opts.args)
      end, { nargs = 1, desc = "Set 99 model" })
      usercmd("NinetyNineModelSelect", function()
        pick_model()
      end, { desc = "Select 99 model" })

      map("v", "<leader>9v", function()
        _99.visual()
      end, { desc = "Visual Prompt" })
      map({ "n", "v" }, "<leader>9s", function()
        _99.stop_all_requests()
      end, { desc = "Stop Requests" })
      map("n", "<leader>9q", function()
        _99.previous_requests_to_qfix()
      end, { desc = "Requests to Quickfix" })
      map("n", "<leader>9c", function()
        _99.clear_previous_requests()
      end, { desc = "Clear Previous Requests" })
      map("n", "<leader>9i", function()
        _99.info()
      end, { desc = "Show 99 Info" })
      map("n", "<leader>9l", function()
        _99.view_logs()
      end, { desc = "View Request Logs" })
      map("n", "<leader>9m", function()
        pick_model()
      end, { desc = "Select Model" })
    end,
  },
}
