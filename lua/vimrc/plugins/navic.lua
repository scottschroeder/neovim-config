local log = require("vimrc.log")

local ok, navic = pcall(require, "nvim-navic")
if not ok then
  log.warn("could not load module:", "nvim-navic")
  return
end



navic.setup {
    icons = {
        File          = " ",
        Module        = " ",
        Namespace     = " ",
        Package       = " ",
        Class         = " ",
        Method        = " ",
        Property      = " ",
        Field         = " ",
        Constructor   = " ",
        Enum          = "﬘",
        Interface     = "",
        Function      = " ",
        Variable      = "v ",
        Constant      = "c ",
        String        = " ",
        Number        = "1 ",
        Boolean       = "◩ ",
        Array         = " ",
        Object        = " ",
        Key           = " ",
        Null          = " ",
        EnumMember    = "炙",
        Struct        = " ",
        Event         = " ",
        Operator      = "* ",
        TypeParameter = "<T> ",
    },
    lsp = {
        auto_attach = false,
        preference = nil,
    },
    highlight = false,
    separator = " > ",
}
