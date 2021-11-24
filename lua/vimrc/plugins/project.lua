require("vimrc.project").setup({
  git_roots = {"~/src"},
  extras = {
    {title="$HOME", path="~"},
    {title="shell", path="~/.shell"},
    {title="Org Mode", path="~/Dropbox/Documents/Org"},
    -- {path="~"},
    -- {title="Neovim Config", path="~/src/github/scottschroeder/neovim-config"},
    -- {path="~/src/github/scottschroeder/neovim-config"},
  }
})
