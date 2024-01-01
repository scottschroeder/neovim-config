return
{
  "sainnhe/gruvbox-material",
  config = function()
    local palette = require("rc.settings.color.palette")

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

    palette.set_colorscheme("gruvbox-material")
  end
}
