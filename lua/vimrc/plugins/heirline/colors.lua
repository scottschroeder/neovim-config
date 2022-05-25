local get_highlight = require("heirline.utils").get_highlight

local M = {}


M.colors = {
  fg = "#D8DEE9",
  bg = "#1d2021",
  line_bg = "#282828",
  lightbg = "#3C4048",
  red = '#f2594b',
  orange = '#f28534',
  yellow = '#e9b143',
  green = '#b0b846',
  aqua = '#8bba7f',
  blue = '#80aa9e',
  purple = '#d3869b',
  dark_red = '#af2528',
  dark_orange = '#b94c07',
  dark_yellow = '#b4730e',
  dark_green = '#72761e',
  dark_aqua = '#477a5b',
  dark_blue = '#266b79',
  dark_purple = '#924f79',
}

M.colors.git = {
  del = M.colors.dark_red,
  add = M.colors.green,
  change = M.colors.dark_blue,
  -- del = get_highlight("diffDeleted").fg,
  -- add = get_highlight("diffAdded").fg,
  -- change = get_highlight("diffChanged").fg,
}

M.colors.diag = {
  warn = M.colors.yellow,
  error = M.colors.dark_red,
  hint = M.colors.blue,
  info = M.colors.green,
  healthy = M.colors.green,
  -- warn = get_highlight("DiagnosticWarn").fg,
  -- error = get_highlight("DiagnosticError").fg,
  -- hint = get_highlight("DiagnosticHint").fg,
  -- info = get_highlight("DiagnosticInfo").fg,
}

-- local colors = {
--   red = get_highlight("DiagnosticError").fg,
--   green = get_highlight("String").fg,
--   blue = get_highlight("Function").fg,
--   gray = get_highlight("NonText").fg,
--   orange = get_highlight("DiagnosticWarn").fg,
--   purple = get_highlight("Statement").fg,
--   cyan = get_highlight("Special").fg,
--   diag = {
--     warn = get_highlight("DiagnosticWarn").fg,
--     error = get_highlight("DiagnosticError").fg,
--     hint = get_highlight("DiagnosticHint").fg,
--     info = get_highlight("DiagnosticInfo").fg,
--   },
--   -- git = {
--   --   del = get_highlight("diffDeleted").fg,
--   --   add = get_highlight("diffAdded").fg,
--   --   change = get_highlight("diffChanged").fg,
--   -- },
-- }
--
return M
