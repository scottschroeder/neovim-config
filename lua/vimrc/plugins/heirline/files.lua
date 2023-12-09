local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local palette = require("vimrc.config.palette")
local colors = palette.colors.simple

-- TODO can we dynamically determine if we are in the winline?
local filename_max_width = 0.9 -- 0.25

-- TODO highlight in another color for the filename (or the last dir for init.* or mod.rs)

local M = {}

M.FileType = {
  init = function(self)
    self.filetype = string.lower(vim.bo.filetype)
  end,
  provider = function(self)
    return "[" .. self.filetype .. "]"
  end,
  hl = { fg = utils.get_highlight("Type").fg, bold = true },
}

local FileNameBlock = {
  -- let's first set up some attributes needed by this component and it's children
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}
-- We can now define some children separately and add them later

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end
}

local FileName = {
  provider = function(self)
    -- first, trim the pattern relative to the current directory. For other
    -- options, see :h filename-modifers
    local filename = vim.fn.fnamemodify(self.filename, ":.")
    if filename == "" then return "[No Name]" end
    -- now, if the filename would occupy more than 1/4th of the available
    -- space, we trim the file path to its initials
    -- See Flexible Components section below for dynamic truncation
    if not conditions.width_percent_below(#filename, filename_max_width) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
  hl = { fg = utils.get_highlight("Directory").fg },
}

local FileFlags = {
  {
    provider = function() if vim.bo.modified then return "[+]" end end,
    hl = function() return { fg = colors.green } end

  }, {
    provider = function() if (not vim.bo.modifiable) or vim.bo.readonly then return "" end end,
    hl = function() return { fg = colors.orange } end
  }
}

-- Now, let's say that we want the filename color to change if the buffer is
-- modified. Of course, we could do that directly using the FileName.hl field,
-- but we'll see how easy it is to alter existing components using a "modifier"
-- component

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = colors.cyan, bold = true, force = true }
    end
  end,
}

-- let's add the children to our FileNameBlock component
M.FileNameBlock = utils.insert(FileNameBlock,
  FileIcon,
  utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
  unpack(FileFlags), -- A small optimisation, since their parent does nothing
  { provider = '%<' }-- this means that the statusline is cut here when there's not enough space
)


M.FileSize = {
  provider = function()
    -- stackoverflow, compute human readable file size
    local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
    fsize = (fsize < 0 and 0) or fsize
    if fsize <= 0 then
      return "0" .. suffix[1]
    end
    local i = math.floor((math.log(fsize) / math.log(1024)))
    return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i])
  end
}

M.FileLastModified = {
  -- did you know? Vim is full of functions!
  provider = function()
    local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
    return (ftime > 0) and os.date("%c", ftime)
  end
}

M.Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = "%7(%l/%3L%):%2c %P",
}

M.ScrollBar = {
  static = {
    sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
    -- Another variant, because the more choice the better.
    -- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,
  hl = function() return { fg = colors.blue, bg = palette.ui().bright_bg } end,
}

return M
