return require("rc.utils.miniplugin").define_config("diagnostics", function()
  local d = require("diagnostics")
  d.setup()

  local map = require("rc.utils.map").map

  map("n", "<leader>ld", function()
    d.toggle_diagnostics()
  end, { desc = "toggle virtual line diagnostics" })
end)
