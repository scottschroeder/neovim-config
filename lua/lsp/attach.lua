local nvim_lsp = require('lspconfig')
local buf_map = require('rc.utils.map').buf_map
local map_prefix = require('rc.utils.map').prefix
local log = require("rc.log")

local code_action = function()
  local ok, actions_preview = pcall(require, "actions-preview")
  if ok then
    actions_preview.code_actions()
  else
    vim.lsp.buf.code_action()
  end
end

local on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    local ok, navic = pcall(require, "nvim-navic")
    if ok then
      navic.attach(client, bufnr)
    end
  end

  local buf_set_keymap = function(mode, lhs, rhs, desc)
    buf_map(bufnr, mode, lhs, rhs, { desc = desc })
  end

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) -- Set the default as true
    buf_set_keymap({ "n" }, "<leader>lh", function()
      local current_setting = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      vim.lsp.inlay_hint.enable(not current_setting, { bufnr = bufnr })
    end, "toggle inlay hints")
  end


  map_prefix("g", "GOTO", { buffer = bufnr })
  buf_set_keymap({ "n" }, "K", vim.lsp.buf.hover, "show hover documentation")
  buf_set_keymap({ "n" }, "gd", vim.lsp.buf.definition, "go to definition")
  buf_set_keymap({ "n" }, "gt", vim.lsp.buf.type_definition, "go to type definition")
  buf_set_keymap({ "n" }, "gi", vim.lsp.buf.implementation, "go to implementation")
  buf_set_keymap({ "n" }, "gr", vim.lsp.buf.references, "go to references")
  buf_set_keymap({ "n" }, "<leader>lr", ":LspRestart<CR>", "Restart")
  buf_set_keymap({ "n" }, "<leader>lR", function()
    require("rc.settings.functions").reload_all()
    vim.cmd("LspRestart")
  end, "Reload all buffers & Restart LSP")


  buf_set_keymap({ "n" }, "<F2>", vim.lsp.buf.rename, "rename at point")

  buf_set_keymap({ "n", "i", "v" }, "<M-.>", code_action, "run LSP code actions")

  if client.server_capabilities.documentFormattingProvider then
    buf_set_keymap({ "n" }, "<Leader>=", vim.lsp.buf.format, "format file")
  end
  if client.server_capabilities.documentRangeFormattingProvider then
    buf_set_keymap({ "v" }, "<Leader>=", vim.lsp.buf.range_formatting, "format highlighted range")
  end
end

return {
  on_attach = on_attach,
}
