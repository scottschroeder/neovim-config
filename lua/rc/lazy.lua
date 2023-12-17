local log = require("rc.log")

local lazypath = string.format('%s/lazy/lazy.nvim', vim.fn.stdpath('data'))

local download_lazy = function()
  log.info("downloading lazy")
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end

local has_lazy = function()
  return vim.loop.fs_stat(lazypath)
end


local setup_lazy = function()
  if not has_lazy() then
    download_lazy()
    if not has_lazy() then
      log.error("could not download lazy")
      return
    end
  end

  vim.opt.runtimepath:prepend(lazypath)

  require("lazy").setup("rc.plugins", {
    -- ui = {
    --   icons = {
    --     cmd = "⌘",
    --     config = "🛠",
    --     event = "📅",
    --     ft = "📂",
    --     init = "⚙",
    --     keys = "🗝",
    --     plugin = "🔌",
    --     runtime = "💻",
    --     source = "📄",
    --     start = "🚀",
    --     task = "📌",
    --   },
    -- },
  })
end

setup_lazy()
