local log = require("rc.log")
return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  config = function()
    local ls = require("luasnip")
    local map = require("rc.utils.map").map


    -- Overruled by blink.cmp
    map({ "i", "s" }, "<C-k>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end,
      { desc = "expand/jump snippet" }
    )

    -- Overruled by blink.cmp
    map({ "i", "s" }, "<C-j>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { desc = "luasnip jump(-1)" }
    )

    map({ "i", "s" }, "<C-y>", function()
      while ls.jumpable(1) do
        ls.jump(1)
      end
    end, { desc = "accept snippet as-is" }
    )

    map({ "i", "s" }, "<C-l>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { desc = "luasnip change choice" })

    map({ "i", "s" }, "<C-u>", function()
      require("luasnip.extras.select_choice")()
    end, { desc = "luasnip change choice" })

    local types = require("luasnip.util.types")

    ls.setup({
      update_events = { "TextChanged", "TextChangedI" },
      enable_autosnippets = true,
      ext_opts = {
        [types.choiceNode] = {
          active = {
            virt_text = { { "<- Choice Node", "orange" } },
          },
        },
        [types.snippet] = {
          active = {
            virt_text = { { "{Snippet}", "blue" } },
          },
        }
      }
    })

    -- ls.config.set_config({
    --   -- region_check_events = "InsertEnter,CursorMoved",
    --   -- updateevents = "TextChanged,TextChangedI",
    --   -- enable_autosnippets = true,
    --   ext_opts = {
    --     [types.choiceNode] = {
    --       active = {
    --         virt_text = { { "<- Choice Node", "orange" } },
    --       },
    --     },
    --     [types.snippet] = {
    --       active = {
    --         virt_text = { { "{Snippet}", "blue" } },
    --       },
    --     }

    --   }
    -- })

    ls.cleanup()

    require("rc.plugins.luasnip.all")
    require("rc.plugins.luasnip.lua")
    require("rc.plugins.luasnip.rust")
    require("rc.plugins.luasnip.go")
    -- This was an artifact of not having TSUpdate automatically happen
    -- local has_go, luasnip_go = pcall(require, "rc.plugins.luasnip.go")
    -- if not has_go then
    --   log.warn("luasnip could not load golang snippets")
    -- end
  end
}
