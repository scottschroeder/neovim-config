return {
  { 'nvim-telescope/telescope-ui-select.nvim' }, -- vim.ui.select will default everything to telescope
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'quickfix', 'nvim-telescope/telescope-fzf-native.nvim' },
    config = function()
      local map = require("rc.utils.map").map
      local actions = require("telescope.actions")
      local qf = require("quickfix")

      local open_smart_in_quickfix = function(...)
        actions.smart_send_to_qflist(...)
        qf.open_quickfix()
      end

      require("telescope").setup({
        defaults = {
          -- sorting_strategy = "ascending", -- https://github.com/nvim-telescope/telescope.nvim/issues/2667
          mappings = {
            i = {
              ["<M-q>"] = open_smart_in_quickfix,
            },
            n = {
              ["<M-q>"] = open_smart_in_quickfix,
            },
          }
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
              wrap_results = true,
            }
          }
        }
      })


      require("telescope").load_extension("ui-select")
      require('telescope').load_extension('fzf')


      if vim.fn.executable('rg') == 1 then
        -- If you are having trouble with this mapping in docker, see "detachKeys"
        map("n", "<C-p>",
          function()
            require('telescope.builtin').find_files({ find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } })
          end,
          { desc = "Telescope Find Files" }
        )
        map("n", "<C-g>", function()
          local opts = require("telescope.themes").get_ivy()
          require("rc.plugins.telescope.multigrep").live_multigrep(opts)
          -- require('telescope.builtin').live_grep(opts)
        end, { desc = "Live Grep" })
      else
        require("rc.log").warn("ripgrep not found, not setting some telescope bindings")
      end

      map("n", "<leader>lt", require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = "Search Symbols" })
      map("n", "<leader>sP", function()
        require('telescope.builtin').find_files({
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        })
      end, { desc = "Find Neovim Plugin Files" })
      -- -- TODO why didn't the cmd function work?
      -- vim.api.nvim_create_user_command("Files",
      --   function()
      --     require('telescope.builtin').find_files({
      --       hidden = true,
      --       no_ignore = true,
      --     })
      --   end, {})
      -- cmd("Files", function() require('telescope.builtin').find_files({}) end)
      -- map("n", "<leader>b", require('telescope.builtin').buffers)
      -- map("n", "<C-s>", require('telescope.builtin').spell_suggest)
      -- map("n", "<C-h>", require('telescope.builtin').help_tags) -- C-h is used to move left :|
      -- map("n", "<C-f>", require('telescope.builtin').builtin, { desc = "Telescope Anything" })
      -- map("n", "<Leader>m", ":Marks<CR>")
      map("n", "<Leader><Space>", require('telescope.builtin').commands, { desc = "Telescope Commands" })
    end
  },
}
