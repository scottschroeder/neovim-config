return {
  "b3nj5m1n/kommentary",
  config = function()
    local map = require("rc.utils.map").map

    local config = require("kommentary.config")

    config.configure_language("default", {
      prefer_single_line_comments = true,
    })

    require("kommentary")
    vim.g.kommentary_create_default_mappings = false

    map("n", "<M-/>", "<Plug>kommentary_line_default", { desc = "Comment Toggle" })
    map("v", "<M-/>", "<Plug>kommentary_visual_default", { desc = "Comment Toggle" })
  end,
}
