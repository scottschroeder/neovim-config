local autoload_lsp_servers = function()
  local ensure_installed = {
    -- "docker_compose_language_service",
    -- "dockerls",
    -- "jsonls",
    "lua_ls",
    -- "rust_analyzer",
  }

  if vim.fn.executable('go') == 1 then
    table.insert(ensure_installed, "gopls")
  end

  if vim.fn.executable('unzip') == 1 then
    table.insert(ensure_installed, "terraformls")
  end

  if vim.fn.executable('npm') == 1 then
    -- table.insert(ensure_installed, "")
  end

  return ensure_installed
end

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = autoload_lsp_servers()
      })
    end
  },
}
