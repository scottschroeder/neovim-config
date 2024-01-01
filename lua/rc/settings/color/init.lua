local opt = require("rc.utils.option").opt
local palette = require("rc.settings.color.palette")

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


-- if in_tmux() then
--   opt("o", "background", "dark")
-- else
--   opt("o", "background", "light")
-- end

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

local cmd = require("rc.utils.map").cmd
cmd("BackgroundToggle", function()
  if vim.o.background == "dark" then
    opt("o", "background", "light")
  else
    opt("o", "background", "dark")
  end
  palette.refresh_palette()
end)
