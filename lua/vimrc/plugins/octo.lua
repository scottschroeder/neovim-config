local log = require("vimrc.log")
local ok, octo = pcall(require, "octo")
if not ok then
  log.warn("octo not installed")
  return
end


-- git rid of message that its going to take a while to load
  -- https://github.com/pwntester/octo.nvim/blob/1ce62d9a29b5eca2c63fb955359f5212e4d1bc7b/lua/octo/pickers/telescope/provider.lua#L138
-- keymap doesn't reflect keys bound for octo://


octo.setup({
  use_local_fs = false,                    -- use local files on right side of reviews
  enable_builtin = false,                  -- shows a list of builtin actions when no action is provided
  default_remote = {"upstream", "origin"}; -- order to try remotes
  ssh_aliases = {},                        -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
  picker_config = {
    mappings = {
      open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
      copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
      checkout_pr = { lhs = "<C-o>", desc = "checkout pull request" },
      merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
    },
  },
  reaction_viewer_hint_icon = "";         -- marker for user reactions
  user_icon = " ";                        -- user icon
  timeline_marker = "";                   -- timeline marker
  timeline_indent = "2";                   -- timeline indentation
  right_bubble_delimiter = "";            -- bubble delimiter
  left_bubble_delimiter = "";             -- bubble delimiter
  github_hostname = "";                    -- GitHub Enterprise host
  snippet_context_lines = 4;               -- number or lines around commented lines
  gh_env = {},                             -- extra environment variables to pass on to GitHub CLI, can be a table or function returning a table
  timeout = 5000,                          -- timeout for requests between the remote server
  ui = {
    use_signcolumn = true,                 -- show "modified" marks on the sign column
  },
  issues = {
    order_by = {                           -- criteria to sort results of `Octo issue list`
      field = "CREATED_AT",                -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
      direction = "DESC"                   -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
    }
  },
  pull_requests = {
    order_by = {                           -- criteria to sort the results of `Octo pr list`
      field = "CREATED_AT",                -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
      direction = "DESC"                   -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
    },
    always_select_remote_on_create = "false" -- always give prompt to select base remote repo when creating PRs
  },
  file_panel = {
    size = 10,                             -- changed files panel rows
    use_icons = true                       -- use web-devicons in file panel (if false, nvim-web-devicons does not need to be installed)
  },
  mappings = {
    issue = {
      close_issue = { lhs = "<leader>Oic", desc = "close issue" },
      reopen_issue = { lhs = "<leader>Oio", desc = "reopen issue" },
      list_issues = { lhs = "<leader>Oil", desc = "list open issues on same repo" },
      reload = { lhs = "<C-r>", desc = "reload issue" },
      open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
      copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
      add_assignee = { lhs = "<leader>Oaa", desc = "add assignee" },
      remove_assignee = { lhs = "<leader>Oad", desc = "remove assignee" },
      create_label = { lhs = "<leader>Olc", desc = "create label" },
      add_label = { lhs = "<leader>Ola", desc = "add label" },
      remove_label = { lhs = "<leader>Old", desc = "remove label" },
      goto_issue = { lhs = "<leader>Ogi", desc = "navigate to a local repo issue" },
      add_comment = { lhs = "<leader>Oca", desc = "add comment" },
      delete_comment = { lhs = "<leader>Ocd", desc = "delete comment" },
      next_comment = { lhs = "]c", desc = "go to next comment" },
      prev_comment = { lhs = "[c", desc = "go to previous comment" },
      react_hooray = { lhs = "<leader>Orp", desc = "add/remove 🎉 reaction" },
      react_heart = { lhs = "<leader>Orh", desc = "add/remove ❤️ reaction" },
      react_eyes = { lhs = "<leader>Ore", desc = "add/remove 👀 reaction" },
      react_thumbs_up = { lhs = "<leader>Or+", desc = "add/remove 👍 reaction" },
      react_thumbs_down = { lhs = "<leader>Or-", desc = "add/remove 👎 reaction" },
      react_rocket = { lhs = "<leader>Orr", desc = "add/remove 🚀 reaction" },
      react_laugh = { lhs = "<leader>Orl", desc = "add/remove 😄 reaction" },
      react_confused = { lhs = "<leader>Orc", desc = "add/remove 😕 reaction" },
    },
    pull_request = {
      checkout_pr = { lhs = "<leader>Opo", desc = "checkout PR" },
      merge_pr = { lhs = "<leader>Opm", desc = "merge commit PR" },
      squash_and_merge_pr = { lhs = "<leader>Opsm", desc = "squash and merge PR" },
      list_commits = { lhs = "<leader>Opc", desc = "list PR commits" },
      list_changed_files = { lhs = "<leader>Opf", desc = "list PR changed files" },
      show_pr_diff = { lhs = "<leader>Opd", desc = "show PR diff" },
      add_reviewer = { lhs = "<leader>Ova", desc = "add reviewer" },
      remove_reviewer = { lhs = "<leader>Ovd", desc = "remove reviewer request" },
      close_issue = { lhs = "<leader>Oic", desc = "close PR" },
      reopen_issue = { lhs = "<leader>Oio", desc = "reopen PR" },
      list_issues = { lhs = "<leader>Oil", desc = "list open issues on same repo" },
      reload = { lhs = "<C-r>", desc = "reload PR" },
      open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
      copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
      goto_file = { lhs = "gf", desc = "go to file" },
      add_assignee = { lhs = "<leader>Oaa", desc = "add assignee" },
      remove_assignee = { lhs = "<leader>Oad", desc = "remove assignee" },
      create_label = { lhs = "<leader>Olc", desc = "create label" },
      add_label = { lhs = "<leader>Ola", desc = "add label" },
      remove_label = { lhs = "<leader>Old", desc = "remove label" },
      goto_issue = { lhs = "<leader>Ogi", desc = "navigate to a local repo issue" },
      add_comment = { lhs = "<leader>Oca", desc = "add comment" },
      delete_comment = { lhs = "<leader>Ocd", desc = "delete comment" },
      next_comment = { lhs = "]c", desc = "go to next comment" },
      prev_comment = { lhs = "[c", desc = "go to previous comment" },
      react_hooray = { lhs = "<leader>Orp", desc = "add/remove 🎉 reaction" },
      react_heart = { lhs = "<leader>Orh", desc = "add/remove ❤️ reaction" },
      react_eyes = { lhs = "<leader>Ore", desc = "add/remove 👀 reaction" },
      react_thumbs_up = { lhs = "<leader>Or+", desc = "add/remove 👍 reaction" },
      react_thumbs_down = { lhs = "<leader>Or-", desc = "add/remove 👎 reaction" },
      react_rocket = { lhs = "<leader>Orr", desc = "add/remove 🚀 reaction" },
      react_laugh = { lhs = "<leader>Orl", desc = "add/remove 😄 reaction" },
      react_confused = { lhs = "<leader>Orc", desc = "add/remove 😕 reaction" },
    },
    review_thread = {
      goto_issue = { lhs = "<leader>Ogi", desc = "navigate to a local repo issue" },
      add_comment = { lhs = "<leader>Oca", desc = "add comment" },
      add_suggestion = { lhs = "<leader>Osa", desc = "add suggestion" },
      delete_comment = { lhs = "<leader>Ocd", desc = "delete comment" },
      next_comment = { lhs = "]c", desc = "go to next comment" },
      prev_comment = { lhs = "[c", desc = "go to previous comment" },
      select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
      select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
      close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
      react_hooray = { lhs = "<leader>Orp", desc = "add/remove 🎉 reaction" },
      react_heart = { lhs = "<leader>Orh", desc = "add/remove ❤️ reaction" },
      react_eyes = { lhs = "<leader>Ore", desc = "add/remove 👀 reaction" },
      react_thumbs_up = { lhs = "<leader>Or+", desc = "add/remove 👍 reaction" },
      react_thumbs_down = { lhs = "<leader>Or-", desc = "add/remove 👎 reaction" },
      react_rocket = { lhs = "<leader>Orr", desc = "add/remove 🚀 reaction" },
      react_laugh = { lhs = "<leader>Orl", desc = "add/remove 😄 reaction" },
      react_confused = { lhs = "<leader>Orc", desc = "add/remove 😕 reaction" },
    },
    submit_win = {
      approve_review = { lhs = "<C-a>", desc = "approve review" },
      comment_review = { lhs = "<C-m>", desc = "comment review" },
      request_changes = { lhs = "<C-r>", desc = "request changes review" },
      close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
    },
    review_diff = {
      add_review_comment = { lhs = "<leader>Oca", desc = "add a new review comment" },
      add_review_suggestion = { lhs = "<leader>Osa", desc = "add a new review suggestion" },
      focus_files = { lhs = "<leader>Oe", desc = "move focus to changed file panel" },
      toggle_files = { lhs = "<leader>Ob", desc = "hide/show changed files panel" },
      next_thread = { lhs = "]t", desc = "move to next thread" },
      prev_thread = { lhs = "[t", desc = "move to previous thread" },
      select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
      select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
      close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
      toggle_viewed = { lhs = "<leader>Oxx", desc = "toggle viewer viewed state" },
      goto_file = { lhs = "gf", desc = "go to file" },
    },
    file_panel = {
      next_entry = { lhs = "j", desc = "move to next changed file" },
      prev_entry = { lhs = "k", desc = "move to previous changed file" },
      select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
      refresh_files = { lhs = "R", desc = "refresh changed files panel" },
      focus_files = { lhs = "<leader>Oe", desc = "move focus to changed file panel" },
      toggle_files = { lhs = "<leader>Ob", desc = "hide/show changed files panel" },
      select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
      select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
      close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
      toggle_viewed = { lhs = "<leader>Oxx", desc = "toggle viewer viewed state" },
    }
  }
})
