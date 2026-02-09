return {
  {
    "nvim-pack/nvim-spectre",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("spectre").setup({
        mapping = {
          ['tab'] = {
            map = '<Tab>',
            cmd = "<cmd>lua require('spectre').tab()<cr>",
            desc = 'next query'
          },
          ['shift-tab'] = {
            map = '<S-Tab>',
            cmd = "<cmd>lua require('spectre').tab_shift()<cr>",
            desc = 'previous query'
          },
          ['toggle_line'] = {
            map = "dd",
            cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
            desc = "toggle item"
          },
          ['enter_file'] = {
            map = "<cr>",
            cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
            desc = "open file"
          },
          ['send_to_qf'] = {
            map = "<M-q>",
            cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
            desc = "send all items to quickfix"
          },
          ['replace_cmd'] = {
            map = "<leader>lSc",
            cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
            desc = "input replace command"
          },
          ['show_option_menu'] = {
            map = "<leader>lSo",
            cmd = "<cmd>lua require('spectre').show_options()<CR>",
            desc = "show options"
          },
          ['run_current_replace'] = {
            map = "<leader>lSR",
            cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
            desc = "replace current line"
          },
          ['run_replace'] = {
            map = "<leader>lSr",
            cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
            desc = "replace all"
          },
          ['change_view_mode'] = {
            map = "<leader>lSv",
            cmd = "<cmd>lua require('spectre').change_view()<CR>",
            desc = "change result view mode"
          },
          ['change_replace_sed'] = {
            map = "trs",
            cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
            desc = "use sed to replace"
          },
          ['change_replace_oxi'] = {
            map = "tro",
            cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
            desc = "use oxi to replace"
          },
          ['toggle_live_update'] = {
            map = "tu",
            cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
            desc = "update when vim writes to file"
          },
          ['toggle_ignore_case'] = {
            map = "ti",
            cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
            desc = "toggle ignore case"
          },
          ['toggle_ignore_hidden'] = {
            map = "th",
            cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
            desc = "toggle search hidden"
          },
          ['resume_last_search'] = {
            map = "<leader>lSl",
            cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
            desc = "repeat last search"
          },
          ['select_template'] = {
            map = '<leader>lSt',
            cmd = "<cmd>lua require('spectre.actions').select_template()<CR>",
            desc = 'pick template',
          },
          ['delete_line'] = {
            map = '<leader>lSd',
            cmd = "<cmd>lua require('spectre.actions').run_delete_line()<CR>",
            desc = 'delete line',
          }
        },
        replace_engine = {
          ["sed"] = {
            cmd = "sed",
            args = nil,
          },
        },
      })

      local map = require("rc.utils.map").map


      map("n", "<leader>lS", require("spectre").toggle, { desc = "Spectre" })
      -- For some reason this requires using the command string
      map("v", "<leader>lS", ":lua require('spectre').open_visual()<CR>", { desc = "Spectre Visual" })
    end

  }
}
