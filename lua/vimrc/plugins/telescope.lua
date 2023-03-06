local map = require("vimrc.config.mapping").map
local cmd = require("vimrc.config.mapping").map
local log = require("vimrc.log")
local actions = require "telescope.actions"
local qf = require("vimrc.config.quickfix")

local open_all_in_quickfix = function(...)
  actions.send_to_qflist(...)
  qf.open_quickfix()
end

local open_selected_in_quickfix = function(...)
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
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        wrap_results = true,
        -- even more opts
      }

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    }
  }
})


require("telescope").load_extension("ui-select")

map("n", "<C-p>", require('telescope.builtin').find_files, {desc = "Telescope Find Files"})
map("n", "<leader>lt", require('telescope.builtin').lsp_dynamic_workspace_symbols, {desc = "Search Symbols"})
-- TODO why didn't the cmd function work?
vim.api.nvim_create_user_command("Files",
  function()
    require('telescope.builtin').find_files({
      hidden = true,
      no_ignore = true,
    })
  end, {})
-- cmd("Files", function() require('telescope.builtin').find_files({}) end)
-- map("n", "<leader>b", require('telescope.builtin').buffers)
-- map("n", "<C-s>", require('telescope.builtin').spell_suggest)
-- map("n", "<C-h>", require('telescope.builtin').help_tags) -- C-h is used to move left :|
map("n", "<C-f>", require('telescope.builtin').builtin, {desc="Telescope Anything"})
map("n", "<C-g>", require('telescope.builtin').live_grep, {desc="Live Grep"})
-- map("n", "<Leader>m", ":Marks<CR>")
map("n", "<Leader><Space>", require('telescope.builtin').commands, {desc = "Telescope Commands"})
