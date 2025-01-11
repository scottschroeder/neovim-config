local map_prefix = require("rc.utils.map").prefix
local map = require("rc.utils.map").map
local methods = vim.lsp.protocol.Methods
local log = require("rc.log")


-- Generic LSP commands
map_prefix("<leader>l", "LSP", { icon = "λ" })
map("n", "<leader>ls", ":LspInfo<CR>", { desc = "Info" })
map("n", "<leader>ll", ":LspLog<CR>", { desc = "Show Logs" })
map("n", "<leader>lL", function()
  local levels = {}
  local int_levels = {}

  -- TRACE 0
  -- DEBUG 1
  -- INFO 2
  -- WARN 3
  -- ERROR 4
  -- OFF 5
  for name, level in pairs(vim.log.levels) do
    levels[level] = name
    table.insert(int_levels, level)
  end
  table.sort(int_levels)
  local choices = {}
  for _, level in ipairs(int_levels) do
    table.insert(choices, levels[level])
  end

  vim.ui.select(
    choices, { prompt = "Choose an option:" }, function(choice)
      vim.lsp.set_log_level(choice)
    end
  )
end, { desc = "Change LSP Log Level" })


-- severity_sort means that errors are reported before warnings and hints
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    severity_sort = true,
  }
)

local rewrite_gopls_inlay_hint = function(value)
  local text = value.label[1].value
  if text:find("^%[github%.com.*%.%.%.$") ~= nil then
    value.label[1].value = "[...]"
  end
end

local inlay_hint_handler = vim.lsp.handlers[methods.textDocument_inlayHint]
vim.lsp.handlers[methods.textDocument_inlayHint] = function(err, result, ctx, config)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if client and client.name == 'gopls' then
    if result ~= nil then
      for _, v in pairs(result) do
        rewrite_gopls_inlay_hint(v)
      end
    end
  end

  inlay_hint_handler(err, result, ctx, config)
end

local additional_servers = { "bashls", "dockerls", "dotls", "graphql", "jsonls", "pyright" }

for _, server_name in ipairs(additional_servers) do
  require('lspconfig')[server_name].setup {
    on_attach = require("lsp.attach").on_attach,
    capabilities = require("lsp.capabilities").capabilities,
  }
end

require("lsp.lang.golang")
require("lsp.lang.lua")
require("lsp.lang.terraform")
