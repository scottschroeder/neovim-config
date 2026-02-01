return {
  {
    "tpope/vim-fugitive",
    lazy = true,
    keys = "<leader>g",
    config = function()
      local map = require("rc.utils.map").map
      map("n", "<Leader>gs", ":Git<CR>", { desc = "Fugitive" })
    end
  },
  -- {
  --   "sindrets/diffview.nvim",
  --   dependencies = "nvim-lua/plenary.nvim",
  --   lazy = false,
  --   keys = "<leader>g",
  --   config = function()
  --     local map = require("rc.utils.map").map
  --     local map_prefix = require("rc.utils.map").prefix

  --     local actions = require("diffview.actions")

  --     local diffleader_prefix = "<leader>d"
  --     map_prefix(diffleader_prefix, "Diff", { icon = "" })
  --     local diffleader = function(lhs)
  --       return diffleader_prefix .. lhs
  --     end
  --     map_prefix(diffleader("c"), "Conflict")


  --     require("diffview").setup({

  --       keymaps = {
  --         disable_defaults = true, -- Disable the default keymaps
  --         view = {
  --           -- The `view` bindings are active in the diff buffers, only when the current
  --           -- tabpage is a Diffview.
  --           { "n", "<tab>",          actions.select_next_entry,             { desc = "Open the diff for the next file" } },
  --           { "n", "<s-tab>",        actions.select_prev_entry,             { desc = "Open the diff for the previous file" } },
  --           -- { "n", "[F",             actions.select_first_entry,            { desc = "Open the diff for the first file" } },
  --           -- { "n", "]F",             actions.select_last_entry,             { desc = "Open the diff for the last file" } },
  --           { "n", "gf",             actions.goto_file_edit,                { desc = "Open the file in the previous tabpage" } },
  --           -- { "n", "<C-w><C-f>",     actions.goto_file_split,               { desc = "Open the file in a new split" } },
  --           -- { "n", "<C-w>gf",        actions.goto_file_tab,                 { desc = "Open the file in a new tabpage" } },
  --           { "n", diffleader("e"),  actions.focus_files,                   { desc = "Bring focus to the file panel" } },
  --           { "n", diffleader("k"),  actions.toggle_files,                  { desc = "Toggle the file panel." } },
  --           -- { "n", "g<C-x>",         actions.cycle_layout,                  { desc = "Cycle through available layouts." } },
  --           { "n", "[x",             actions.prev_conflict,                 { desc = "In the merge-tool: jump to the previous conflict" } },
  --           { "n", "]x",             actions.next_conflict,                 { desc = "In the merge-tool: jump to the next conflict" } },
  --           { "n", diffleader("co"), actions.conflict_choose("ours"),       { desc = "Choose the OURS version of a conflict" } },
  --           { "n", diffleader("ch"), actions.conflict_choose("ours"),       { desc = "LEFT" } },
  --           { "n", diffleader("cl"), actions.conflict_choose("theirs"),     { desc = "RIGHT" } },
  --           { "n", diffleader("ct"), actions.conflict_choose("theirs"),     { desc = "Choose the THEIRS version of a conflict" } },
  --           { "n", diffleader("cb"), actions.conflict_choose("base"),       { desc = "Choose the BASE version of a conflict" } },
  --           { "n", diffleader("ca"), actions.conflict_choose("all"),        { desc = "Choose all the versions of a conflict" } },
  --           { "n", diffleader("cx"), actions.conflict_choose("none"),       { desc = "Delete the conflict region" } },
  --           { "n", diffleader("cO"), actions.conflict_choose_all("ours"),   { desc = "Choose the OURS version of a conflict for the whole file" } },
  --           { "n", diffleader("cT"), actions.conflict_choose_all("theirs"), { desc = "Choose the THEIRS version of a conflict for the whole file" } },
  --           { "n", diffleader("cB"), actions.conflict_choose_all("base"),   { desc = "Choose the BASE version of a conflict for the whole file" } },
  --           { "n", diffleader("cA"), actions.conflict_choose_all("all"),    { desc = "Choose all the versions of a conflict for the whole file" } },
  --           { "n", diffleader("cX"), actions.conflict_choose_all("none"),   { desc = "Delete the conflict region for the whole file" } },
  --         },
  --         diff1 = {
  --           -- Mappings in single window diff layouts
  --           { "n", "g?", actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
  --         },
  --         diff2 = {
  --           -- Mappings in 2-way diff layouts
  --           { "n", "g?", actions.help({ "view", "diff2" }), { desc = "Open the help panel" } },
  --         },
  --         diff3 = {
  --           -- Mappings in 3-way diff layouts
  --           -- { { "n", "x" }, "2do", actions.diffget("ours"),           { desc = "Obtain the diff hunk from the OURS version of the file" } },
  --           -- { { "n", "x" }, "3do", actions.diffget("theirs"),         { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
  --           { "n", "g?", actions.help({ "view", "diff3" }), { desc = "Open the help panel" } },
  --         },
  --         diff4 = {
  --           -- Mappings in 4-way diff layouts
  --           -- { { "n", "x" }, "1do", actions.diffget("base"),           { desc = "Obtain the diff hunk from the BASE version of the file" } },
  --           -- { { "n", "x" }, "2do", actions.diffget("ours"),           { desc = "Obtain the diff hunk from the OURS version of the file" } },
  --           -- { { "n", "x" }, "3do", actions.diffget("theirs"),         { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
  --           { "n", "g?", actions.help({ "view", "diff4" }), { desc = "Open the help panel" } },
  --         },
  --         file_panel = {
  --           { "n", "j",              actions.next_entry,                    { desc = "Bring the cursor to the next file entry" } },
  --           { "n", "<down>",         actions.next_entry,                    { desc = "Bring the cursor to the next file entry" } },
  --           { "n", "k",              actions.prev_entry,                    { desc = "Bring the cursor to the previous file entry" } },
  --           { "n", "<up>",           actions.prev_entry,                    { desc = "Bring the cursor to the previous file entry" } },
  --           { "n", "<cr>",           actions.select_entry,                  { desc = "Open the diff for the selected entry" } },
  --           -- { "n", "o",              actions.select_entry,                  { desc = "Open the diff for the selected entry" } },
  --           -- { "n", "l",              actions.select_entry,                  { desc = "Open the diff for the selected entry" } },
  --           { "n", "<2-LeftMouse>",  actions.select_entry,                  { desc = "Open the diff for the selected entry" } },
  --           { "n", "-",              actions.toggle_stage_entry,            { desc = "Stage / unstage the selected entry" } },
  --           { "n", "s",              actions.toggle_stage_entry,            { desc = "Stage / unstage the selected entry" } },
  --           { "n", "S",              actions.stage_all,                     { desc = "Stage all entries" } },
  --           { "n", "U",              actions.unstage_all,                   { desc = "Unstage all entries" } },
  --           { "n", "X",              actions.restore_entry,                 { desc = "Restore entry to the state on the left side" } },
  --           { "n", "L",              actions.open_commit_log,               { desc = "Open the commit log panel" } },
  --           { "n", "zo",             actions.open_fold,                     { desc = "Expand fold" } },
  --           -- { "n", "h",              actions.close_fold,                    { desc = "Collapse fold" } },
  --           { "n", "zc",             actions.close_fold,                    { desc = "Collapse fold" } },
  --           { "n", "za",             actions.toggle_fold,                   { desc = "Toggle fold" } },
  --           { "n", "zR",             actions.open_all_folds,                { desc = "Expand all folds" } },
  --           { "n", "zM",             actions.close_all_folds,               { desc = "Collapse all folds" } },
  --           { "n", "<C-u>",          actions.scroll_view(-0.25),            { desc = "Scroll the view up" } },
  --           { "n", "<C-d>",          actions.scroll_view(0.25),             { desc = "Scroll the view down" } },
  --           { "n", "<tab>",          actions.select_next_entry,             { desc = "Open the diff for the next file" } },
  --           { "n", "<s-tab>",        actions.select_prev_entry,             { desc = "Open the diff for the previous file" } },
  --           -- { "n", "[F",             actions.select_first_entry,            { desc = "Open the diff for the first file" } },
  --           -- { "n", "]F",             actions.select_last_entry,             { desc = "Open the diff for the last file" } },
  --           { "n", "gf",             actions.goto_file_edit,                { desc = "Open the file in the previous tabpage" } },
  --           -- { "n", "<C-w><C-f>",     actions.goto_file_split,               { desc = "Open the file in a new split" } },
  --           -- { "n", "<C-w>gf",        actions.goto_file_tab,                 { desc = "Open the file in a new tabpage" } },
  --           { "n", "i",              actions.listing_style,                 { desc = "Toggle between 'list' and 'tree' views" } },
  --           { "n", "f",              actions.toggle_flatten_dirs,           { desc = "Flatten empty subdirectories in tree listing style" } },
  --           { "n", "R",              actions.refresh_files,                 { desc = "Update stats and entries in the file list" } },
  --           { "n", diffleader("e"),  actions.focus_files,                   { desc = "Bring focus to the file panel" } },
  --           { "n", diffleader("k"),  actions.toggle_files,                  { desc = "Toggle the file panel" } },
  --           { "n", "g<C-x>",         actions.cycle_layout,                  { desc = "Cycle available layouts" } },
  --           { "n", "[x",             actions.prev_conflict,                 { desc = "Go to the previous conflict" } },
  --           { "n", "]x",             actions.next_conflict,                 { desc = "Go to the next conflict" } },
  --           { "n", "g?",             actions.help("file_panel"),            { desc = "Open the help panel" } },
  --           { "n", diffleader("cO"), actions.conflict_choose_all("ours"),   { desc = "Choose the OURS version of a conflict for the whole file" } },
  --           { "n", diffleader("cT"), actions.conflict_choose_all("theirs"), { desc = "Choose the THEIRS version of a conflict for the whole file" } },
  --           { "n", diffleader("cB"), actions.conflict_choose_all("base"),   { desc = "Choose the BASE version of a conflict for the whole file" } },
  --           { "n", diffleader("cA"), actions.conflict_choose_all("all"),    { desc = "Choose all the versions of a conflict for the whole file" } },
  --           { "n", diffleader("cX"), actions.conflict_choose_all("none"),   { desc = "Delete the conflict region for the whole file" } },
  --         },
  --         file_history_panel = {
  --           { "n", "g!",            actions.options,                    { desc = "Open the option panel" } },
  --           { "n", "<C-A-d>",       actions.open_in_diffview,           { desc = "Open the entry under the cursor in a diffview" } },
  --           { "n", "y",             actions.copy_hash,                  { desc = "Copy the commit hash of the entry under the cursor" } },
  --           { "n", "L",             actions.open_commit_log,            { desc = "Show commit details" } },
  --           { "n", "X",             actions.restore_entry,              { desc = "Restore file to the state from the selected entry" } },
  --           { "n", "zo",            actions.open_fold,                  { desc = "Expand fold" } },
  --           { "n", "zc",            actions.close_fold,                 { desc = "Collapse fold" } },
  --           { "n", "h",             actions.close_fold,                 { desc = "Collapse fold" } },
  --           { "n", "za",            actions.toggle_fold,                { desc = "Toggle fold" } },
  --           { "n", "zR",            actions.open_all_folds,             { desc = "Expand all folds" } },
  --           { "n", "zM",            actions.close_all_folds,            { desc = "Collapse all folds" } },
  --           { "n", "j",             actions.next_entry,                 { desc = "Bring the cursor to the next file entry" } },
  --           { "n", "<down>",        actions.next_entry,                 { desc = "Bring the cursor to the next file entry" } },
  --           { "n", "k",             actions.prev_entry,                 { desc = "Bring the cursor to the previous file entry" } },
  --           { "n", "<up>",          actions.prev_entry,                 { desc = "Bring the cursor to the previous file entry" } },
  --           { "n", "<cr>",          actions.select_entry,               { desc = "Open the diff for the selected entry" } },
  --           -- { "n", "o",             actions.select_entry,               { desc = "Open the diff for the selected entry" } },
  --           -- { "n", "l",             actions.select_entry,               { desc = "Open the diff for the selected entry" } },
  --           { "n", "<2-LeftMouse>", actions.select_entry,               { desc = "Open the diff for the selected entry" } },
  --           { "n", "<C-u>",         actions.scroll_view(-0.25),         { desc = "Scroll the view up" } },
  --           { "n", "<C-d>",         actions.scroll_view(0.25),          { desc = "Scroll the view down" } },
  --           { "n", "<tab>",         actions.select_next_entry,          { desc = "Open the diff for the next file" } },
  --           { "n", "<s-tab>",       actions.select_prev_entry,          { desc = "Open the diff for the previous file" } },
  --           -- { "n", "[F",            actions.select_first_entry,         { desc = "Open the diff for the first file" } },
  --           -- { "n", "]F",            actions.select_last_entry,          { desc = "Open the diff for the last file" } },
  --           { "n", "gf",            actions.goto_file_edit,             { desc = "Open the file in the previous tabpage" } },
  --           -- { "n", "<C-w><C-f>",    actions.goto_file_split,            { desc = "Open the file in a new split" } },
  --           -- { "n", "<C-w>gf",       actions.goto_file_tab,              { desc = "Open the file in a new tabpage" } },
  --           { "n", diffleader("e"), actions.focus_files,                { desc = "Bring focus to the file panel" } },
  --           { "n", diffleader("k"), actions.toggle_files,               { desc = "Toggle the file panel" } },
  --           { "n", "g<C-x>",        actions.cycle_layout,               { desc = "Cycle available layouts" } },
  --           { "n", "g?",            actions.help("file_history_panel"), { desc = "Open the help panel" } },
  --         },
  --         option_panel = {
  --           { "n", "<tab>", actions.select_entry,         { desc = "Change the current option" } },
  --           { "n", "q",     actions.close,                { desc = "Close the panel" } },
  --           { "n", "g?",    actions.help("option_panel"), { desc = "Open the help panel" } },
  --         },
  --         help_panel = {
  --           { "n", "q",     actions.close, { desc = "Close help menu" } },
  --           { "n", "<esc>", actions.close, { desc = "Close help menu" } },
  --         },
  --       },

  --     })


  --     map("n", "<Leader>dd", ":DiffviewOpen<CR>", { desc = "Diff" })
  --     map("n", "<Leader>dO", ":DiffviewOpen origin/HEAD<CR>", { desc = "Diff Origin" })

  --     map_prefix(diffleader("h"), "History", { icon = "󰜘" })
  --     map("n", "<Leader>dhr", ":DiffviewFileHistory<CR>", { desc = "Repo" })
  --     map("n", "<Leader>dhf", ":DiffviewFileHistory --follow %<CR>", { desc = "File" })
  --     map("v", "<Leader>dhf", ":'<,'>DiffviewFileHistory --follow<CR>", { desc = "Selection" })
  --   end
  -- },
  {
    'ruifm/gitlinker.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    lazy = false,
    -- keys = "<leader>g",
    config = function()
      local gitlinker = require("gitlinker")
      gitlinker.setup({
        mappings = nil,
        opts = {
          add_current_line_on_normal_mode = false,
        },
      })

      local map = require("rc.utils.map").map
      map("n", "<leader>gy", function() gitlinker.get_buf_range_url("n", {}) end, { desc = "Link to GitHub" })
      map("v", "<leader>gy", function() gitlinker.get_buf_range_url("v", {}) end, { desc = "Link to GitHub" })
      map('n', '<leader>gG',
        function()
          gitlinker.get_repo_url({ action_callback = require "gitlinker.actions".open_in_browser })
        end
        , { desc = "Open in GitHub", icon = "" }
      )
    end

  },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require("gitsigns").setup({})
    end

  }
}
