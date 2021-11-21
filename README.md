# neovim-config

## TODO
- Spell Checking
- neomake?
- Focus Lost to Normal Mode
  - `au FocusLost * call feedkeys("\<C-\>\<C-n>")`
  - `use {"907th/vim-auto-save"}`
  - `autocmd BufLeave,TabLeave,FocusLost * silent! wall`
- mark gutter
- remove gutter from tree
- todo https://www.reddit.com/r/neovim/comments/nbh8ik/todo_comments_highlight_list_and_search_todo/
- yank to system buffer

### Safe start
- be able to work without any plugins

### Tabs

### Snippets
  - luasnip https://github.com/L3MON4D3/LuaSnip

### Utils / Fuzzy Matching
- https://github.com/RishabhRD/nvim-lsputils
- https://github.com/ojroques/nvim-lspfuzzy

### LSP
- more reliable restart command
- show diagnostics in list?
- show diagnostics from all files in workspace?

### Git
- fugitive/magit/?
- show diffs https://www.reddit.com/r/neovim/comments/n2vww8/diffviewnvim_cycle_through_diffs_for_all_modified/

### Projectile
- async background
- multiple instances all writing
- cwd management
- de-dup sources (or at least omit recent)
- source names
- all git repos

### Quickfix
- <M-q> doesnt work if in a vertical split (and the wrong window)

### Filetypes
#### Lua
- format
#### Markdown
- tables
#### Org
- neorg https://github.com/nvim-neorg/neorg
- orgmode https://github.com/kristijanhusak/orgmode.nvim

