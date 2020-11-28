-- init.lua

local util = require("util")
local plug = require("plug")


local function core_options()
	local options = {
		hidden = true, -- Hides buffers instead of closing them
		nobackup = true,
		noswapfile = true,

		-- Visual Elements
		cmdheight = 1,
		updatetime = 300,
		signcolumn = "yes",
		number = true, -- Show line numbers
		cursorline = true, -- cursor line is highlighted
		background = "dark", -- assume dark background
		termguicolors = true, -- Full GUI colors
		list = true, -- print non-printing chars
		listchars = {'tab:▸░', 'trail:·', 'extends:»', 'precedes:«', 'nbsp:⣿'};
		scrolloff = 3,
		lazyredraw = true,

		-- Search & Complete
		ignorecase = true,
		smartcase = true,
		wildignorecase = true,
		wildmode = {"list:longest", "full"},
		wildignore = {"*.swp","*.bak","*.pyc","*.class"}, -- ignore these filetypes in completion

		-- Text
		nowrap = true,
		tabstop = 4,
		softtabstop = 4,
		shiftwidth = 4,
		shiftround = true,
		smarttab = true,
		pastetoggle = "<F2>",

		-- Spell
		spelllang = "en_us",

	}
	util.setOptions(options)
end

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

local function gen_plugins()
	local p = {}
	p['junegunn/fzf'] = "{ 'do': './install --bin' }"
	p['junegunn/fzf.vim'] = ""
	p['morhetz/gruvbox'] = ""
	p['xolox/vim-misc'] = ""
	p['xolox/vim-lua-ftplugin'] = ""
	p['itchyny/lightline.vim'] = ""
	p['scrooloose/nerdtree'] = ""
	p['neomake/neomake'] = ""
	p['bronson/vim-trailing-whitespace'] = ""
	p['tpope/vim-commentary'] = ""
	p['tpope/vim-surround'] = ""
	p['airblade/vim-rooter'] = ""

	-- Coc
	p['neoclide/coc.nvim'] = "{'branch': 'release'}"
	-- p['neoclide/coc-json'] = ""
	-- p['neoclide/coc-yaml'] = ""
	-- p['fannheyward/coc-rust-analyzer'] = ""
	-- p['iamcco/coc-vimlsp'] = ""


	-- Custom
	p['~/src/github.com/scottschroeder/neovim-config/projection'] = ""
	return p
end

-- Not actually called, just example
local function dummyproxy()
	util.set_proxy({
		HTTP_PROXY = "localhost:8080",
		HTTPS_PROXY = "localhost:8081",
	})
end

function NavigationFloatingWin()
  -- get the editor's max width and height
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  -- create a new, scratch buffer, for fzf
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')

  -- if the editor is big enough
  if (width > 150 or height > 35) then
    -- fzf's window height is 3/4 of the max height, but not more than 30
    local win_height = math.min(math.ceil(height * 3 / 4), 30)
    local win_width

    -- if the width is small
    if (width < 150) then
      -- just subtract 8 from the editor's width
      win_width = math.ceil(width - 8)
    else
      -- use 90% of the editor's width
      win_width = math.ceil(width * 0.9)
    end

    -- settings for the fzf window
    local opts = {
      relative = "editor",
      width = win_width,
      height = win_height,
      row = math.ceil((height - win_height) / 2),
      col = math.ceil((width - win_width) / 2),
      style = 'minimal'
    }

    -- create a new floating window, centered in the editor
    local win = vim.api.nvim_open_win(buf, true, opts)
  end
end


core_options()
plug.configure_plugins(gen_plugins())
try_colorschemes({"gruvbox", "desert"})


vim.g.fzf_layout = { window = 'lua NavigationFloatingWin()'}
