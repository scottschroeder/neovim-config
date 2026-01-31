local buf_map = require("rc.utils.map").buf_map
vim.lsp.config('terraformls', {
  on_attach = function(c, bufnr)
    require("lsp.attach").on_attach(c, bufnr)
    buf_map(bufnr, { "n", "v" }, "gD", function()
        vim.cmd("OpenTerraformDocumentationAtCursor")
      end,
      { desc = "Open Terraform Documentation" })
  end,
  capabilities = require("lsp.capabilities").capabilities,
})
vim.lsp.enable('terraformls')
