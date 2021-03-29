require("plenary.reload").reload_module("galaxyline", true)
local gl = require("galaxyline")
gl.disable_galaxyline()

local gls = gl.section
gl.short_line_list = {" "}
local colors = {
    fg = "#D8DEE9",
            bg = "#282c34",
            line_bg = "#282c34",
            lightbg = "#3C4048",
            red =               '#f2594b',
            orange =            '#f28534',
            yellow =            '#e9b143',
            green =             '#b0b846',
            aqua =              '#8bba7f',
            blue =              '#80aa9e',
            purple =            '#d3869b',
            dark_red =               '#af2528',
            dark_orange =            '#b94c07',
            dark_yellow =            '#b4730e',
            dark_green =             '#72761e',
            dark_aqua =              '#477a5b',
            dark_blue =              '#266b79',
            dark_purple =            '#924f79',
}

local force_color = function(fg, bg)
  vim.api.nvim_command('hi GalaxyViMode guifg='..fg)
  vim.api.nvim_command('hi GalaxyViMode guibg='..bg)
end

local mode_color_map = {
  NORMAL = {colors.bg, colors.green},
  INSERT = {colors.bg, colors.orange},
  VISUAL = {colors.bg, colors.purple},
  CMDLNE = {colors.bg, colors.red},
}

local mode_color = function(mode_name)
  local mode_color = mode_color_map[mode_name]
  if mode_color == nil then
    mode_color = {colors.bg, colors.dark_red}
  end
  return mode_color
end

local mode_alias = function(key)
      local alias_map = {
          n = 'NORMAL',
          i = 'INSERT',
          c=  'CMDLNE',
          V=  'VISUAL',
          [''] = 'VISUAL',
          v ='VISUAL',
          ['r?'] = ':CONFIRM',
          rm = '--MORE',
          R  = 'REPLACE',
          Rv = 'VIRTUAL',
          s  = 'SELECT',
          S  = 'SELECT',
          ['r']  = 'HIT-ENTER',
          [''] = 'SELECT',
          t  = 'TERMINAL',
          ['!']  = 'SHELL',
      }
      alias = alias_map[key]
      if alias == nil then
        alias = "UNKNOWN"
      end
      return alias
end


local mode_settings = function() 
  local mode_name = mode_alias(vim.fn.mode())
  local mode_color = mode_color(mode_name)
  return {name=mode_name, fg=mode_color[1], bg=mode_color[2]}
end

gls.left = {}


gls.left[#gls.left+1] = {
  ViMode = {
    provider = function()
      mode_cfg = mode_settings()
      force_color(mode_cfg.fg, mode_cfg.bg)
      return "  " .. mode_cfg.name .. " "
    end,
    highlight = {colors.bg,colors.red,'bold'},
  },
}

gls.left[#gls.left+1] = {
    teech = {
        provider = function()
            return " "
            --return ""
        end,
        highlight = {colors.lightbg, colors.lightbg}
    }
}

gls.left[#gls.left+1] = {
    FileIcon = {
        provider = "FileIcon",
        condition = buffer_not_empty,
        highlight = {require("galaxyline.provider_fileinfo").get_file_icon_color, colors.lightbg}
    }
}

gls.left[#gls.left+1] = {
    FileName = {
        provider = {"FileName", "FileSize"},
        condition = buffer_not_empty,
        highlight = {colors.fg, colors.lightbg}
    }
}


local checkwidth = function()
    local squeeze_width = vim.fn.winwidth(0) / 2
    if squeeze_width > 40 then
        return true
    end
    return false
end


gls.left[#gls.left+1] = {
    LeftEnd = {
        provider = function()
            return " "
        end,
        separator = " ",
        separator_highlight = {colors.line_bg, colors.line_bg},
        highlight = {colors.line_bg, colors.line_bg}
    }
}

gls.left[#gls.left+1] = {
    DiagnosticError = {
        provider = "DiagnosticError",
        icon = "  ",
        highlight = {colors.red, colors.bg}
    }
}


gls.left[#gls.left+1] = {
    DiagnosticWarn = {
        provider = "DiagnosticWarn",
        icon = "  ",
        highlight = {colors.yellow, colors.bg}
    }
}

gls.left[#gls.left+1] = {
    DiagnosticInfo = {
        provider = "DiagnosticInfo",
        icon = "  ",
        highlight = {colors.aqua, colors.bg}
    }
  }

gls.left[#gls.left+1] = {
    DiagnosticHint = {
        provider = "DiagnosticHint",
        icon = "  ",
        highlight = {colors.blue, colors.bg}
    }
}

local is_lsp = function ()
  local tbl = {['dashboard'] = true,['']=true}
  if tbl[vim.bo.filetype] then
    return false
  end
  return true
end


-- gls.mid = {}
gls.left[#gls.left+1] = {
  ShowLspClient = {
    provider = 'GetLspClient',
    condition = is_lsp,
    icon = ' ',
    separator = " ",
    highlight = {colors.yellow,colors.bg,}
  }
}

gls.left[#gls.left+1] = {
  LspStatus = {
    provider = require("vimrc.plugins.lsp-status").statusline,
    condition = is_lsp,
    highlight = {colors.yellow,colors.bg,}
  }
}
-- require('lsp-status').status()

gls.right = {}
gls.right[#gls.right+1] = {
    GitIcon = {
        provider = function()
            return "   "
        end,
        condition = require("galaxyline.provider_vcs").check_git_workspace,
        highlight = {colors.green, colors.line_bg}
    }
}

gls.right[#gls.right+1] = {
    GitBranch = {
        provider = "GitBranch",
        condition = require("galaxyline.provider_vcs").check_git_workspace,
        highlight = {colors.green, colors.line_bg}
    }
}

gls.right[#gls.right+1] = {
    DiffAdd = {
        provider = "DiffAdd",
        condition = checkwidth,
        icon = "   ",
        highlight = {colors.green, colors.line_bg}
    }
}

gls.right[#gls.right+1] = {
    DiffModified = {
        provider = "DiffModified",
        condition = checkwidth,
        icon = " ",
        highlight = {colors.blue, colors.line_bg}
    }
}

gls.right[#gls.right+1] = {
    DiffRemove = {
        provider = "DiffRemove",
        condition = checkwidth,
        icon = " ",
        highlight = {colors.red, colors.line_bg}
    }
}


gls.right[#gls.right+1] = {
    PerCent = {
        provider = "LinePercent",
        separator = " ",
        separator_highlight = {colors.line_bg, colors.line_bg},
        highlight = {colors.fg, colors.bg}
    }
}


gl.load_galaxyline()
