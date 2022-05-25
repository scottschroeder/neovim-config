local conditions = require("heirline.conditions")
local colors = require("vimrc.plugins.heirline.colors").colors

local M = {}

M.LSPActive = {
    condition = conditions.lsp_attached,

    -- You can keep it simple,
    -- provider = " [LSP]",

    -- Or complicate things a bit and get the servers names
    provider  = function()
        local names = {}
        for i, server in pairs(vim.lsp.buf_get_clients(0)) do
            table.insert(names, server.name)
        end
        return " [" .. table.concat(names, " ") .. "]"
    end,
    hl = { fg = colors.green, bold = true },
}



-- TODO is this broken because lsp-status is out-of-date?
-- M.LSPMessages = {
--     provider = require("lsp-status").status,
--     hl = { fg = colors.gray },
-- }
--
M.Gps = {
    condition = function ()
      local ok, gps = pcall(require, "nvim-gps")
      return ok and gps.is_available()
    end,
    provider = require("nvim-gps").get_location,
    hl = { fg = colors.gray },
}

return M
