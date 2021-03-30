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

### Utils / Fuzzy Matching
- https://github.com/RishabhRD/nvim-lsputils
- https://github.com/ojroques/nvim-lspfuzzy

## LSP
- more reliable restart command
- show diagnostics in list?
- show diagnostics from all files in workspace?

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
