return {
  {
    "Afourcat/treesitter-terraform-doc.nvim",
    lazy = true,
    ft = "terraform",
    config = function()
      require("treesitter-terraform-doc").setup({
        command_name = "OpenTerraformDocumentationAtCursor",
      })
    end,
  },
}
