require("vimrc.project").setup({
  git_roots = {"~/src", "~/dd"},
  extras = {
    {title="$HOME", path="~"},
    {title="shell", path="~/.shell"},
    {title="Org Mode", path="~/Dropbox/Documents/Org"},
    {title="New Org Mode", path="~/Dropbox/Documents/NewOrg"},
    {title="DD Hack", path="~/src/ddlocal/scottschroeder/ddhack"},
    -- {path="~"},
    -- {title="Neovim Config", path="~/src/github/scottschroeder/neovim-config"},
    -- {path="~/src/github/scottschroeder/neovim-config"},
  }
})
