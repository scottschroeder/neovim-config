return {
  {
    "ThePrimeagen/harpoon",
    -- branch = "harpoon2",
    commit = 'e76cb03',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        }
      })

      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers").new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        }):find()
      end

      local map = require("rc.utils.map").map
      -- local map_prefix = require("rc.utils.map").prefix
      -- map_prefix("<Leader>\\", "Harpoon", { icon = "" })

      -- map("n", "<Leader>\\a", function() harpoon:list():add() end, { desc = "Add" })
      map("n", "<Leader>\\", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Menu" })
      map("n", "<Leader>`", function()
        harpoon:list():add()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon Add" })
      map("n", "<Leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
      map("n", "<Leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
      map("n", "<Leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
      map("n", "<Leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })
      -- map("n", "<Leader>\\\\", function() toggle_telescope(harpoon:list()) end, { desc = "Menu" })
    end,
  }
}
