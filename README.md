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
- tabline?

### File Tree
- does not start in project root?

### Snippets
- luasnip https://github.com/L3MON4D3/LuaSnip

### Projectile
- async background
- multiple instances all writing
- de-dup sources (or at least omit recent)
- show source names during selection
- all git repos source

### Quickfix
- <M-q> doesnt work if in a vertical split (and the wrong window)

### Filetypes
#### Lua
- format
#### Markdown
- tables
#### Org
- orgmode https://github.com/kristijanhusak/orgmode.nvim

