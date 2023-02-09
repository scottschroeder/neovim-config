-- Plugin Configs
require("vimrc.plugins.nvim-tree")
-- require("vimrc.plugins.nvim-bufferline")
-- require("vimrc.plugins.tabby")
require("vimrc.plugins.nvim-cmp")
require("vimrc.plugins.gitlinker")
require("vimrc.plugins.luasnip")
require("vimrc.plugins.which-key")
require("vimrc.plugins.treesitter")
-- require("vimrc.plugins.vim-auto-save")
require("vimrc.plugins.auto-save")
require("vimrc.plugins.telescope")
require("vimrc.plugins.mason")
require("vimrc.plugins.fidget")
require("vimrc.plugins.gps")
require("vimrc.plugins.devicons")
require("vimrc.plugins.heirline")
-- require("vimrc.plugins.galaxyline")
-- require("vimrc.plugins.windline")
require("vimrc.plugins.colorizer")
require("vimrc.plugins.nvim-lsputils")
require("vimrc.plugins.nvim-lightbulb")
require("vimrc.plugins.lsp_extensions")
require("vimrc.plugins.kommentary")
require('lspkind').init({})
require('gitsigns').setup{
  keymaps = {}
}
require('vimrc.plugins.project')
require('vimrc.plugins.inlay_hints')
require('vimrc.plugins.autoclose')
