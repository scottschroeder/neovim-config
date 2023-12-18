return {

  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-nvim-lua" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lsp-document-symbol" },
  { "petertriho/cmp-git",                  dependencies = "nvim-lua/plenary.nvim" },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      -- menuone: popup even when there's only one match
      -- noselect: Do not select, force user to select one from the menu
      vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect", "preview" }


      local cmp = require("cmp")
      local types = require('cmp.types')


      local icons = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "⌘",
        Field = "ﰠ",
        Variable = "",
        Class = "ﴯ",
        Interface = "",
        Module = "",
        Property = "ﰠ",
        Unit = "塞",
        Value = "",
        Enum = "",
        Keyword = "廓",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "פּ",
        Event = "",
        Operator = "",
        TypeParameter = "",
      }


      -- MY CUSTOM cmp.config.compare.kind
      local compare_kind_with_priority = function(priority_list)
        local index = {}
        for k, v in pairs(priority_list) do
          index[v] = k
        end

        return function(entry1, entry2)
          local kind1 = entry1:get_kind()
          local kind2 = entry2:get_kind()
          if kind1 ~= kind2 then
            local p1 = index[kind1] or (kind1 + 1000)
            local p2 = index[kind2] or (kind2 + 1000)
            local diff = p1 - p2
            if diff < 0 then
              return true
            elseif diff > 0 then
              return false
            end
          end
        end
      end


      cmp.setup({
        preselect = cmp.PreselectMode.None,
        experimental = {
          native_menu = false,
          ghost_text = false,
        },
        confirmation = {
          get_commit_characters = function()
            return {}
          end,
        },
        completion = {
          completeopt = "menu,menuone,noinsert,noselect,preview",
          keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
          keyword_length = 1,
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(_, vim_item)
            vim_item.menu = vim_item.kind
            vim_item.kind = icons[vim_item.kind]

            return vim_item
          end,
        },
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Do not make a selection.
          ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Take the first selection if one is not set.
          -- ['TAB'] = cmp.mapping.
        }),
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            -- cmp.config.compare.recently_used,
            -- cmp.config.compare.locality,

            -- copied from cmp-under, but I don't think I need the plugin for this.
            -- I might add some more of my own.
            -- Move entries that start with `_` to the end
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find "^_+"
              local _, entry2_under = entry2.completion_item.label:find "^_+"
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,

            compare_kind_with_priority({
              -- Direct Children
              types.lsp.CompletionItemKind.EnumMember,
              types.lsp.CompletionItemKind.Field,
              types.lsp.CompletionItemKind.Method,
              types.lsp.CompletionItemKind.Property,

              -- Free Objects
              types.lsp.CompletionItemKind.Variable,
              types.lsp.CompletionItemKind.Function,

              -- Types
              types.lsp.CompletionItemKind.Struct,
              types.lsp.CompletionItemKind.Enum,

              -- Nearby-ish things?
              types.lsp.CompletionItemKind.Interface,
              types.lsp.CompletionItemKind.Class,
              types.lsp.CompletionItemKind.Module,

              -- Other
              types.lsp.CompletionItemKind.Constructor,
              types.lsp.CompletionItemKind.Constant,
              types.lsp.CompletionItemKind.Unit,
              types.lsp.CompletionItemKind.Value,
              types.lsp.CompletionItemKind.Keyword,
              types.lsp.CompletionItemKind.Snippet,
              types.lsp.CompletionItemKind.Color,
              types.lsp.CompletionItemKind.File,
              types.lsp.CompletionItemKind.Reference,
              types.lsp.CompletionItemKind.Folder,
              types.lsp.CompletionItemKind.Event,
              types.lsp.CompletionItemKind.Operator,
              types.lsp.CompletionItemKind.TypeParameter,
              types.lsp.CompletionItemKind.Text,
            }),

            -- cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        sources = cmp.config.sources(
          {
            { name = 'git' },     -- github
            { name = 'nvim_lsp' },
            { name = 'luasnip' }, -- For luasnip users.
          },
          {
            { name = 'copilot' },
          },
          {
            { name = 'nvim_lua' },
          },
          {
            { name = 'path' },
            { name = 'buffer' },
          })
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
          { name = 'buffer' },
        })
      })
    end
  },
}
