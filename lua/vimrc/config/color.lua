local function set_colorscheme(name)

	local cmd = "colorscheme " .. name
  return pcall(vim.api.nvim_command, cmd)
end


local function try_colorschemes(colors)
	for _, c in pairs(colors) do
		if set_colorscheme(c) then
			return
		end
	end
end


vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_ui_contrast = "low"
vim.g.gruvbox_material_diagnostic_text_highlight = 1
vim.g.gruvbox_material_diagnostic_line_highlight = 0
vim.g.gruvbox_material_diagnostic_virtual_text = "colored"

try_colorschemes({"gruvbox-material", "desert"})
