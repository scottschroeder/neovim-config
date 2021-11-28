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
- auto braces {}
- autocomplete on tab

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

### Snippets
- luasnip https://github.com/L3MON4D3/LuaSnip

### Projectile
- sort by recently used

### Filetypes
#### Lua
- format https://github.com/andrejlevkovitch/vim-lua-format

#### Rust
- snippets for tfn tmod
- way to run cargo test for only this test/module
- don't show clippy errors as error diagnostics?

#### Markdown
- tables
#### Org
- orgmode https://github.com/kristijanhusak/orgmode.nvim

### GUI
https://github.com/neovide/neovide
