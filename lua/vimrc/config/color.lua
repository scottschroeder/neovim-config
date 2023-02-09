local log = require("vimrc.log")
local opt = require("vimrc.config.option").opt
local palette = require("vimrc.config.palette")

local function try_colorschemes(colors)
  for _, c in pairs(colors) do
    if palette.set_colorscheme(c) then
      return
    end
  end
end

local in_tmux = function()
  return os.getenv("TMUX") ~= nil
end

vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_background = "medium"
vim.g.gruvbox_material_foreground = "mix"
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_cursor = "auto" -- only works with gui
vim.g.gruvbox_material_transparent_background = 0
vim.g.gruvbox_material_dim_inactive_windows = 1
vim.g.gruvbox_material_visual = "green background"
vim.g.gruvbox_material_menu_selection_background = "purple"
vim.g.gruvbox_material_ui_contrast = "high"
vim.g.gruvbox_material_diagnostic_text_highlight = 1
vim.g.gruvbox_material_diagnostic_line_highlight = 0
vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
vim.g.gruvbox_material_statusline_style = "mix"
-- vim.g.gruvbox_material_colors_override = {
-- bg0 = {"#1d2021", "234"},
-- bg2 = {"#282828", "235"},
-- }

opt("o", "termguicolors", true) -- full GUI colors

if in_tmux() then
  opt("o", "background", "dark")
else
  opt("o", "background", "light")
end

try_colorschemes({ "gruvbox-material", "one", "PaperColor", "desert" })
-- vim.highlight.create("CursorLine", {ctermbg=0, guibg="lightgrey"}, false)
--
-- local function detail_colorscheme_gruvbox_material_light()
--   if vim.o.background == "dark" then
--     log.debug("background is dark")
--     return
--   end
--   if vim.g.colors_name ~= "gruvbox-material" then
--     log.debug("colorscheme is not gruvbox-material")
--     return
--   end
--   log.warn("updating color details")
--   vim.api.nvim_set_hl(0, "CursorLine", { bg = 100, blend = 0 })

-- end

-- detail_colorscheme_gruvbox_material_light()
palette.register_autogroup()
palette.refresh_palette()
