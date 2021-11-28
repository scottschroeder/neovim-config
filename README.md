# neovim-config

## TODO
Ideas: https://neovimcraft.com/


- Spell Checking
- neomake?
- Focus Lost to Normal Mode
  - `au FocusLost * call feedkeys("\<C-\>\<C-n>")`
  - `use {"907th/vim-auto-save"}`
  - `autocmd BufLeave,TabLeave,FocusLost * silent! wall`
- mark gutter
- remove gutter from tree
- todo https://www.reddit.com/r/neovim/comments/nbh8ik/todo_comments_highlight_list_and_search_todo/

### Copy/Paste
- OSX unnamed(plus) go to system clipboard
- Linux unnamed & unnamedplus go to tmux buffer
  - yank to system buffer (and or get tmux buffers to sync to system?)


### File Navigation
- <leader>^ for fuzzy find all buffers that were in that window?
- <leader>b for fuzzy find open buffers?
- https://github.com/ThePrimeagen/harpoon ?

### Status Bar
- new windows don't always inherit the right settings

### Safe start
- be able to work without any plugins

### File Tree
- does not start in project root?

### Snippets
- luasnip https://github.com/L3MON4D3/LuaSnip

### Projectile
- sort by recently used

### Filetypes
#### Lua
- format https://github.com/andrejlevkovitch/vim-lua-format

#### Markdown
- tables
#### Org
- orgmode https://github.com/kristijanhusak/orgmode.nvim

### GUI
https://github.com/neovide/neovide
