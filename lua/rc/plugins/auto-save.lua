return {
  {
    "Pocco81/auto-save.nvim",
    config = function()
      local is_autosave = function(buf)
        local utils = require("auto-save.utils.data")
        local okbuf, filepath = pcall(vim.api.nvim_buf_get_name, buf)
        if not okbuf then
          return false
        end
        local filename = vim.fs.basename(filepath)
        if filename == "Cargo.toml" then
          return false
        end

        if
          vim.fn.getbufvar(buf, "&modifiable") == 1
          and utils.not_in(vim.fn.getbufvar(buf, "&filetype"), { "oil", "octo", "harpoon" })
        then
          return true -- met condition(s), can save
        end
        return false -- can't save
      end

      require("auto-save").setup({
        write_all_buffers = true,
        condition = is_autosave,
      })
    end,
  },
}
