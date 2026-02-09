return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "leoluz/nvim-dap-go",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
    "williamboman/mason.nvim",
  },
  config = function()
    local dap = require("dap")
    local ui = require("dapui")

    local map = require("rc.utils.map").map
    local map_prefix = require("rc.utils.map").prefix
    map_prefix("<leader>D", "[D]ebug", { icon = "" })
    map_prefix("<leader>DB", "[D]ebug [B]reakpoints", { icon = "" })

    -- TODO
    -- Ideally this would be some telescope selector with memory
    -- I could also make this a `.dapconfigs` directory per-project
    local get_custom_arg = function()
      return {
        "foo",
        "bar",
        "baz",
      }
    end
    local get_custom_env = function()
      return {
        TEST_ENV_VAR = "evalue",
      }
    end

    ui.setup()
    require("nvim-dap-virtual-text").setup({})

    local custom_debug = {
      type = "go",
      name = "Debug (My Args)",
      request = "launch",
      program = "${file}",
      args = get_custom_arg,
      env = get_custom_env,
    }

    local attach_headless = {
      type = "delveone",
      name = "Attach Remote ONE",
      mode = "remote",
      request = "attach",
    }

    dap.adapters.delveone = {
      type = "server",
      host = "127.0.0.1",
      port = "39231",
    }

    require("dap-go").setup()

    table.insert(dap.configurations.go, custom_debug)
    table.insert(dap.configurations.go, attach_headless)

    map("n", "<leader>Db", function()
      dap.toggle_breakpoint()
    end, { desc = "Toggle [b]reakpoint" })
    map("n", "<leader>DBl", function()
      dap.list_breakpoints()
      require("quickfix").open_quickfix()
    end, { desc = "[B]reakpoint [l]ist in quickfix" })
    map("n", "<leader>DBc", function()
      dap.clear_breakpoints()
    end, { desc = "[B]reakpoint [c]lear list" })

    map("n", "<leader>Dc", function()
      dap.run_to_cursor()
    end, { desc = "Run to [c]ursor" })

    map("n", "<F5>", function()
      dap.continue()
    end, { desc = "DAP Continue" })
    map("n", "<F6>", function()
      dap.step_over()
    end, { desc = "DAP Step Over" })
    map("n", "<F7>", function()
      dap.step_into()
    end, { desc = "DAP Step Into" })
    map("n", "<F8>", function()
      dap.step_out()
    end, { desc = "DAP Step Out" })

    map("n", "<leader>Dq", function()
      dap.disconnect()
    end, { desc = "DAP Quit" })

    -- F9 Quit

    map("n", "<leader>Du", function()
      ui.toggle()
    end, { desc = "DAP [u]i" })

    -- Something language agnostic, or only set these bindings up per-lang
    map("n", "<leader>Dt", function()
      require("dap-go").debug_test()
    end, { desc = "DAP [t]est" })

    -- Eval var under cursor
    map("n", "<leader>D?", function()
      ui.eval(nil, { enter = true })
    end, { desc = "Inspect variable under cursor" })

    map("n", "<leader>Dw", function()
      ui.elements.watches.add(nil)
    end, { desc = "watch variable" })

    dap.listeners.before.attach.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      ui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      ui.close()
    end
  end,
}
