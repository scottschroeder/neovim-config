# neovim-config

## TODO
- Spell Checking
- neomake?
- autofmt
- Projectile
  - `use {"907th/vim-auto-save"}`
  - `autocmd BufLeave,TabLeave,FocusLost * silent! wall`
- Focus Lost to Normal Mode
  - `au FocusLost * call feedkeys("\<C-\>\<C-n>")`
- mark gutter
- remove gutter from tree
- Plugins to checkout
  - todo https://www.reddit.com/r/neovim/comments/nbh8ik/todo_comments_highlight_list_and_search_todo/
  - lsp pretty diagnostics https://www.reddit.com/r/neovim/comments/mw5a6z/lsp_trouble_a_pretty_diagnostics_list_to_help/
  - telescope vs fzf? https://github.com/nvim-telescope/telescope.nvim
  - show diffs https://www.reddit.com/r/neovim/comments/n2vww8/diffviewnvim_cycle_through_diffs_for_all_modified/
  - luasnip https://github.com/L3MON4D3/LuaSnip

### Utils / Fuzzy Matching
- https://github.com/RishabhRD/nvim-lsputils
- https://github.com/ojroques/nvim-lspfuzzy

## Org
- neorg https://github.com/nvim-neorg/neorg
- orgmode https://github.com/kristijanhusak/orgmode.nvim

## LSP
- more reliable restart command
- show diagnostics in list?
- show diagnostics from all files in workspace?

## Git
- fugitive/magit/?

## Mac
- meta key seems to not be working

## Projectile
- async background
- multiple instances all writing
- cwd management
- de-dup sources (or at least omit recent)
- source names
- all git repos

## Quickfix
- <M-q> doesnt work if in a vertical split (and the wrong window)

## Filetypes
### Lua
- format
### Markdown
- tables
### Rust
- auto suggest/import relevant types
### Go
- lsp gopls
```
GO111MODULE=on go get golang.org/x/tools/gopls@latest
```
### Python
### Bash
```
npm i -g bash-language-server
```
### C++
### Docker
### Dot
```
npm i -g dot-language-server
```
### Haskel
### JSON
```
npm install -g vscode-json-languageserver
```
### Terraform
### Yaml
```
npm install -g yaml-language-server
```
