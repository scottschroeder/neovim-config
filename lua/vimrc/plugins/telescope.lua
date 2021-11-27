local map = require("vimrc.config.mapping").map
local log = require("vimrc.log")
local actions = require "telescope.actions"
local qf = require("vimrc.config.quickfix")

local function lsp_actions_preview()

  local reserved = 6
  local items = 10 -- TODO actually get the list
  require('telescope.builtin').lsp_code_actions({
    layout_strategy = "cursor",
    layout_config = {
      height=items + reserved,
    },
  })
end

local open_all_in_quickfix = function (...)
  actions.send_to_qflist(...)
  qf.open_quickfix()
end

local open_selected_in_quickfix = function (...)
  actions.send_selected_to_qflist(...)
  qf.open_quickfix()
end

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-q>"] = open_selected_in_quickfix,
        ["<M-q>"] = open_all_in_quickfix,
      },
      n = {
        ["<C-q>"] = open_selected_in_quickfix,
        ["<M-q>"] = open_all_in_quickfix,
      },
    }
  }
})



map("n", "<C-p>", require('telescope.builtin').find_files)
-- map("n", "<C-s>", require('telescope.builtin').spell_suggest)
-- map("n", "<C-h>", require('telescope.builtin').help_tags) -- C-h is used to move left :|
map("n", "<C-f>", require('telescope.builtin').builtin)
map("n", "<C-g>", require('telescope.builtin').live_grep)
-- map("n", "<M-.>", lsp_actions_preview)
-- map("n", "<Leader>m", ":Marks<CR>")
map("n", "<Leader><Space>", require('telescope.builtin').commands)

return {
  lsp_actions_preview = lsp_actions_preview,
}
