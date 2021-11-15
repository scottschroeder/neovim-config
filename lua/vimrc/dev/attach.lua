local nvim_lsp = require('lspconfig')
local lsp_status = require('lsp-status')
local buf_map = require('vimrc.config.mapping').buf_map

local on_attach = function(client, bufnr)
  lsp_status.on_attach(client, bufnr)

  local function buf_set_keymap(...) buf_map(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gd',    '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'L', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)

  buf_set_keymap('n', '<M-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_set_keymap('n', '<Leader>.', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<M-.>', vim.lsp.buf.code_action, opts)
  buf_set_keymap('n', '<M-.>', vim.lsp.buf.code_action, opts)
  buf_set_keymap("n", "<M-.>", require("vimrc.plugins.telescope").lsp_actions_preview)
  -- buf_set_keymap('i', '<M-.>', vim.lsp.buf.code_action, opts)
  -- buf_set_keymap('i', '<M-CR>', vim.lsp.buf.code_action, {noremap=true})
  -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<M-Q>', '<cmd>lua vim.lsp.diagnostic.set_qflist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<Leader>=", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<Leader>=", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end
-- vim.cmd [[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({focusable = false})]]
vim.cmd([[autocmd CursorHold,CursorHoldI,BufEnter,BufWinEnter,TabEnter,BufWritePost,BufRead *.rs :lua require'lsp_extensions'.inlay_hints{ enabled = { "ChainingHint", "TypeHint", "ParameterHint" } }]])
  -- Set autocommands conditional on server_capabilities
  -- if client.resolved_capabilities.document_highlight then
    -- vim.api.nvim_exec([[
      -- hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      -- hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      -- hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      -- augroup lsp_document_highlight
        -- autocmd! * <buffer>
        -- autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        -- autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      -- augroup END
    -- ]], false)
  -- end
end

return {
  on_attach = on_attach,
}
