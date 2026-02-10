local log = require("rc.log")

local M = {}
M.set_colorscheme = function(name)
  local cmd = "colorscheme " .. name
  return pcall(vim.api.nvim_command, cmd)
end

M.colors = {}
M.colors.simple = {}

local simple_color_names = {
  "aqua",
  "blue",
  "green",
  "grey0",
  "grey1",
  "grey2",
  "orange",
  "purple",
  "red",
  "yellow",
}

local dark_backgrounds = {
  "#282828",
  "#32302f",
  "#32302f",
  "#45403d",
  "#45403d",
  "#5a524c",
}

local alacritty_colors = {
  fg = "#D8DEE9",
  bg = "#1d2021",
  line_bg = "#282828",
  lightbg = "#3C4048",
  red = "#f2594b",
  orange = "#f28534",
  yellow = "#e9b143",
  green = "#b0b846",
  aqua = "#8bba7f",
  blue = "#80aa9e",
  purple = "#d3869b",
  dark_red = "#af2528",
  dark_orange = "#b94c07",
  dark_yellow = "#b4730e",
  dark_green = "#72761e",
  dark_aqua = "#477a5b",
  dark_blue = "#266b79",
  dark_purple = "#924f79",
}

local _gm_light_tmp = { -- luacheck: ignore 211
  aqua = { "#477a5b", "165" },
  bg0 = { "#fbf1c7", "229" },
  bg1 = { "#f4e8be", "228" },
  bg2 = { "#f2e5bc", "228" },
  bg3 = { "#eee0b7", "223" },
  bg4 = { "#e5d5ad", "223" },
  bg5 = { "#ddccab", "250" },
  bg_current_word = { "#f2e5bc", "228" },
  bg_diff_blue = { "#e2e6c7", "117" },
  bg_diff_green = { "#e6eabc", "194" },
  bg_diff_red = { "#f9e0bb", "217" },
  bg_dim = { "#f2e5bc", "228" },
  bg_green = { "#6f8352", "100" },
  bg_red = { "#ae5858", "88" },
  bg_statusline1 = { "#f2e5bc", "223" },
  bg_statusline2 = { "#f2e5bc", "223" },
  bg_statusline3 = { "#e5d5ad", "250" },
  bg_visual_blue = { "#dadec0", "117" },
  bg_visual_green = { "#dee2b6", "194" },
  bg_visual_red = { "#f1d9b5", "217" },
  bg_visual_yellow = { "#fae7b3", "226" },
  bg_yellow = { "#a96b2c", "130" },
  blue = { "#266b79", "24" },
  fg0 = { "#514036", "237" },
  fg1 = { "#514036", "237" },
  green = { "#72761e", "100" },
  grey0 = { "#a89984", "246" },
  grey1 = { "#928374", "245" },
  grey2 = { "#7c6f64", "243" },
  none = { "NONE", "NONE" },
  orange = { "#b94c07", "130" },
  purple = { "#924f79", "96" },
  red = { "#af2528", "88" },
  yellow = { "#b4730e", "136" },
}

local _gm_dark_tmp = { -- luacheck: ignore 211
  aqua = { "#8bba7f", "108" },
  bg0 = { "#282828", "235" },
  bg1 = { "#32302f", "236" },
  bg2 = { "#32302f", "236" },
  bg3 = { "#45403d", "237" },
  bg4 = { "#45403d", "237" },
  bg5 = { "#5a524c", "239" },
  bg_current_word = { "#3c3836", "237" },
  bg_diff_blue = { "#0e363e", "17" },
  bg_diff_green = { "#34381b", "22" },
  bg_diff_red = { "#402120", "52" },
  bg_dim = { "#1b1b1b", "233" },
  bg_green = { "#b0b846", "142" },
  bg_red = { "#db4740", "167" },
  bg_statusline1 = { "#32302f", "236" },
  bg_statusline2 = { "#3a3735", "236" },
  bg_statusline3 = { "#504945", "240" },
  bg_visual_blue = { "#374141", "17" },
  bg_visual_green = { "#3b4439", "22" },
  bg_visual_red = { "#4c3432", "52" },
  bg_visual_yellow = { "#4f422e", "94" },
  bg_yellow = { "#e9b143", "214" },
  blue = { "#80aa9e", "109" },
  fg0 = { "#e2cca9", "223" },
  fg1 = { "#e2cca9", "223" },
  green = { "#b0b846", "142" },
  grey0 = { "#7c6f64", "243" },
  grey1 = { "#928374", "245" },
  grey2 = { "#a89984", "246" },
  none = { "NONE", "NONE" },
  orange = { "#f28534", "208" },
  purple = { "#d3869b", "175" },
  red = { "#f2594b", "167" },
  yellow = { "#e9b143", "214" },
}

local raw_palette = {}
local last_colorscheme = ""
local last_background = ""
local backgrounds = {}

M.refresh_palette = function()
  if vim.g.colorscheme == last_colorscheme and vim.o.background == last_background then
    return
  end
  log.trace("Refresh color palette", vim.g.colors_name, vim.o.background)

  last_colorscheme = vim.g.colorscheme
  last_background = vim.o.background
  if vim.g.colorscheme ~= nil then
    -- when the background changes, we need to re-apply the colorscheme
    M.set_colorscheme(vim.g.colorscheme)
  end

  if vim.g.colors_name == "gruvbox-material" then
    local gruvbox_config = vim.fn["gruvbox_material#get_configuration"]()
    -- log.debug("gruvbox config", gruvbox_config)
    local palette = vim.fn["gruvbox_material#get_palette"](
      gruvbox_config.background,
      gruvbox_config.foreground,
      gruvbox_config.colors_override
    )
    -- log.debug("palette", palette)
    for _, cname in ipairs(simple_color_names) do
      M.colors.simple[cname] = palette[cname][1]
    end

    for idx = 1, 5 do
      local zidx = idx - 1
      local bgname = "bg" .. zidx
      backgrounds[idx] = palette[bgname][1]
    end

    raw_palette = {}
    for cname, cvalue in ipairs(palette) do
      raw_palette[cname] = cvalue[1]
    end
    -- log.debug("colors", M.colors)
    return
  end
  for _, cname in ipairs(simple_color_names) do
    M.colors.simple[cname] = alacritty_colors[cname]
  end
  raw_palette = alacritty_colors
  backgrounds = dark_backgrounds
end

M.get_palette = function(cname)
  return raw_palette[cname]
end

--   aqua = { "#8bba7f", "108" },
--   blue = { "#80aa9e", "109" },
--   green = { "#b0b846", "142" },
--   grey0 = { "#7c6f64", "243" },
--   grey1 = { "#928374", "245" },
--   grey2 = { "#a89984", "246" },
--   orange = { "#f28534", "208" },
--   purple = { "#d3869b", "175" },
--   red = { "#f2594b", "167" },
--   yellow = { "#e9b143", "214" }
-- }

-- M.colors = {
--   aqua = '#8bba7f',
--   blue = '#80aa9e',
--   green = '#b0b846',
--   grey0 = { "#7c6f64", "243" },
--   grey1 = { "#928374", "245" },
--   grey2 = { "#a89984", "246" },
--   orange = '#f28534',
--   purple = '#d3869b',
--   red = '#f2594b',
--   yellow = '#e9b143',
-- }

-- M.colors = {
--   fg = "#D8DEE9",
--   bg = "#1d2021",
--   line_bg = "#282828",
--   lightbg = "#3C4048",
--   red = '#f2594b',
--   orange = '#f28534',
--   yellow = '#e9b143',
--   green = '#b0b846',
--   aqua = '#8bba7f',
--   blue = '#80aa9e',
--   purple = '#d3869b',
--   dark_red = '#af2528',
--   dark_orange = '#b94c07',
--   dark_yellow = '#b4730e',
--   dark_green = '#72761e',
--   dark_aqua = '#477a5b',
--   dark_blue = '#266b79',
--   dark_purple = '#924f79',
-- }

M.git = function()
  return {
    del = M.colors.simple.red,
    add = M.colors.simple.green,
    change = M.colors.simple.blue,
  }
end

M.diagnostic = function()
  return {
    warn = M.colors.simple.yellow,
    error = M.colors.simple.red,
    hint = M.colors.simple.blue,
    info = M.colors.simple.green,
    healthy = M.colors.simple.green,
  }
end

M.ui = function()
  return {
    bright_bg = M.colors.simple.grey0,
    line_bg = M.colors.simple.grey0,
    lightbg = M.colors.simple.grey0,
  }
end

M.backgrounds = function()
  return backgrounds
end

M.fetch_background = function(shade)
  return function()
    return backgrounds[shade]
  end
end

M.fetch_color = function(color)
  return function()
    return M.colors.simple[color]
  end
end

M.register_autogroup = function()
  local au_group = vim.api.nvim_create_augroup("my-palette-updater", { clear = true })
  vim.api.nvim_create_autocmd({ "WinEnter", "ColorScheme" }, {
    pattern = "*",
    callback = require("rc.settings.color.palette").refresh_palette,
    desc = "refresh palette colors in case colorscheme / bg changed",
    group = au_group,
  })
end

return M
