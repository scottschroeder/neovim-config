-- Safely load local overrides (gitignored)
local ok, local_config = pcall(require, "rc.plugins.speeddial_local")
if not ok then
  local_config = {}
end

-- Base sources (committed)
local base_sources = {
  {
    project = {
      title = "Neovim Config",
      vcs_root = "~/src/github/scottschroeder/neovim-config",
    },
  },
  {
    project = {
      title = "Hab Config",
      root = "~/src/github/scottschroeder/hab/configs",
      vcs_root = "~/src/github/scottschroeder/hab",
    },
  },
  {
    project = {
      title = "speeddial.nvim",
      vcs_root = "~/src/github/scottschroeder/speeddial.nvim",
    },
  },
  {
    git = {
      base = "~/src/github",
      depth = 2,
      source = "GitHub",
    },
  },
  {
    git = {
      base = "~/src/local",
      source = "local",
    },
  },
}

-- Merge local sources after base
local sources = vim.list_extend(vim.deepcopy(base_sources), local_config.sources or {})

return {
  {
    "scottschroeder/speeddial.nvim",
    dir = local_config.dir, -- nil if no local config (uses default from GitHub)
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      local map = require("rc.utils.map").map

      require("speeddial").setup({
        sources = sources,
      })

      map("n", "<leader>p", function()
        require("speeddial").select({
          after = function()
            local harpoon_ok, harpoon = pcall(require, "harpoon")
            if harpoon_ok then
              local hlist = harpoon:list()
              for i, item in ipairs(hlist.items or {}) do
                local path = item and item.value
                if path and vim.fn.filereadable(vim.fn.expand(path)) == 1 then
                  hlist:select(i)
                  return
                end
              end
            end

            require("telescope.builtin").find_files({ find_command = { "rg", "--files", "--hidden", "-g", "!.git" } })
          end,
        })
      end, {})
    end,
  },
}
