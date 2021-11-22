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
- yank to system buffer (and or get tmux buffers to sync to system?)

### Safe start
- be able to work without any plugins

### Tabs

### File Tree
- does not start in project root?

### Snippets
  - luasnip https://github.com/L3MON4D3/LuaSnip

### Utils / Fuzzy Matching
- https://github.com/RishabhRD/nvim-lsputils
- https://github.com/ojroques/nvim-lspfuzzy

### LSP
- more reliable restart command
- show diagnostics in list?
- show diagnostics from all files in workspace?

### Projectile
- async background
- multiple instances all writing
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
- orgmode https://github.com/kristijanhusak/orgmode.nvim

