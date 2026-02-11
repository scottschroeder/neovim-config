return {
  { "nvim-telescope/telescope-ui-select.nvim" }, -- vim.ui.select will default everything to telescope
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "quickfix", "nvim-telescope/telescope-fzf-native.nvim" },
    config = function()
      local map = require("rc.utils.map").map
      local map_prefix = require("rc.utils.map").prefix
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local qf = require("quickfix")

      map_prefix("<leader>F", "Find")

      local open_smart_in_quickfix = function(...)
        actions.smart_send_to_qflist(...)
        qf.open_quickfix()
      end

      local show_ignored = false

      local find_files_command = function()
        local command = { "rg", "--files", "--hidden", "-g", "!.git" }
        if show_ignored then
          table.insert(command, "--no-ignore")
          table.insert(command, "--no-ignore-parent")
        end
        return command
      end

      local function open_find_files(opts)
        opts = opts or {}
        require("telescope.builtin").find_files(vim.tbl_extend("force", {
          find_command = find_files_command(),
          attach_mappings = function(prompt_bufnr, map_telescope)
            local toggle_ignored = function()
              local picker = action_state.get_current_picker(prompt_bufnr)
              local prompt = action_state.get_current_line()
              local cwd = picker and picker.cwd or nil

              show_ignored = not show_ignored
              actions.close(prompt_bufnr)
              open_find_files({ cwd = cwd, default_text = prompt })
            end

            map_telescope("i", "<M-i>", toggle_ignored)
            map_telescope("n", "<M-i>", toggle_ignored)
            return true
          end,
        }, opts))
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
          },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              wrap_results = true,
            }),
          },
        },
      })

      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("fzf")

      if vim.fn.executable("rg") == 1 then
        -- If you are having trouble with this mapping in docker, see "detachKeys"
        map("n", "<C-p>", function()
          open_find_files()
        end, { desc = "Telescope Find Files (Alt-i toggles ignored)" })
        map("n", "<C-g>", function()
          local opts = require("telescope.themes").get_ivy()
          require("rc.plugins.telescope.multigrep").live_multigrep(opts)
          -- require('telescope.builtin').live_grep(opts)
        end, { desc = "Live Grep" })
      else
        require("rc.log").warn("ripgrep not found, not setting some telescope bindings")
      end

      map("n", "<leader>lt", require("telescope.builtin").lsp_dynamic_workspace_symbols, { desc = "Search Symbols" })
      map("n", "<leader>sP", function()
        require("telescope.builtin").find_files({
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
        })
      end, { desc = "Find Neovim Plugin Files" })

      map("n", "<leader>Fh", require("telescope.builtin").help_tags, { desc = "Neovim Help" })
      map("n", "<leader>Fr", require("telescope.builtin").resume, { desc = "Resume last picker" })
      map("n", "<leader>Fb", require("telescope.builtin").buffers, { desc = "Buffers" })

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
      map("n", "<Leader><Space>", require("telescope.builtin").commands, { desc = "Telescope Commands" })
    end,
  },
}
