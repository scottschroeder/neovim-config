return {
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    priority = 100,
    dependencies = {
      -- "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lua",
      "L3MON4D3/LuaSnip",
      { "petertriho/cmp-git", dependencies = "nvim-lua/plenary.nvim" },
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      -- menuone: popup even when there's only one match
      -- noselect: Do not select, force user to select one from the menu
      vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect", "preview" }

      local cmp = require("cmp")

      cmp.setup({
        preselect = cmp.PreselectMode.None,
        sources = cmp.config.sources(
          {
            -- { name = 'git' },     -- github
            { name = 'nvim_lsp' },
            { name = 'nvim_lsp_signature_help' },

            { name = 'path' },
            { name = 'luasnip' }, -- For luasnip users.
            { name = 'copilot' },
            -- { name = 'nvim_lua' },
          },
          {
            { name = 'copilot' },
            { name = 'buffer' },
          }
        ),

        mapping = cmp.mapping.preset.insert({
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),

          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Take the first selection if one is not set.

          ["<tab>"] = cmp.config.disable,
        }),

        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sorting = {
          comparators = require("rc.plugins.cmp.comparators").comparators,
        },

        completion = {
          completeopt = table.concat(vim.opt.completeopt, ","),
          -- keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
          -- keyword_length = 1,
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = require("rc.plugins.cmp.formatting").formatting,
      })


      cmp.setup.filetype('markdown', {
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'luasnip' },
          { name = 'copilot' },
          { name = 'buffer' },
        })
      })
    end
  },
}
