local nvim_lsp = require('lspconfig')
local buf_map = require('vimrc.config.mapping').buf_map
local log = require("vimrc.log")

local on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    local ok, navic = pcall(require, "nvim-navic")
    if ok then
      navic.attach(client, bufnr)
    end
  end


  -- TODO is lsp_status still good?
  -- lsp_status.on_attach(client, bufnr)
  local function buf_set_keymap(mode, lhs, rhs, desc)
    buf_map(bufnr, mode, lhs, rhs, { desc = desc })
  end



  buf_set_keymap({ "n" }, "K", vim.lsp.buf.hover, "show hover documentation")

  buf_set_keymap({ "n" }, "gd", vim.lsp.buf.definition, "go to definition")
  buf_set_keymap({ "n" }, "gt", vim.lsp.buf.type_definition, "go to type definition")
  buf_set_keymap({ "n" }, "gi", vim.lsp.buf.implementation, "go to implementation")
  buf_set_keymap({ "n" }, "gr", vim.lsp.buf.references, "go to references")


  buf_set_keymap({ "n" }, "<F2>", vim.lsp.buf.rename, "rename at point")
  buf_set_keymap({ "n", "i" }, "<M-.>", vim.lsp.buf.code_action, "run LSP code actions")

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
