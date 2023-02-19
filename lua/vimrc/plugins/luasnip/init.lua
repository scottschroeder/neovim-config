local log = require("vimrc.log")
local has_luasnip, ls = pcall(require, "luasnip")
if not has_luasnip then
  log.warn("luasnip not installed")
  return
end

local map = require("vimrc.config.mapping").map


map({ "i", "s" }, "<C-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end,
    { desc = "expand/jump snippet" }
)

map({ "i", "s" }, "<C-j>", function()
  if ls.jumpable( -1) then
    ls.jump( -1)
  end
end, { desc = "luasnip jump(-1)" }
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
ls.config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI",
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

ls.cleanup()

require("vimrc.plugins.luasnip.all")
require("vimrc.plugins.luasnip.lua")
require("vimrc.plugins.luasnip.rust")
require("vimrc.plugins.luasnip.go")
