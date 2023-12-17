# neovim-config

## Development / Testing

```bash
docker build -t neovim-config .
docker run -v $(pwd):/home/manager/.config/nvim -it neovim-config
```

or just run `nvim` directly
```bash
docker run -v $(pwd):/home/manager/.config/nvim -it neovim-config nvim
```

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

### Copy/Paste
- OSX unnamed(plus) go to system clipboard
- Linux unnamed & unnamedplus go to tmux buffer
  - yank to system buffer (and or get tmux buffers to sync to system?)

### Status Bar
- **bug: new windows don't always inherit the right settings**

### Safe start
- be able to work without any plugins

### Projectile
- sort by recently used
- vim.ui.select

### Filetypes
#### Lua
- format https://github.com/andrejlevkovitch/vim-lua-format

#### Rust
- way to run cargo test for only this test/module
- don't show clippy errors as error diagnostics?

#### Markdown
- tables
#### Org
- orgmode https://github.com/kristijanhusak/orgmode.nvim

### GUI
https://github.com/neovide/neovide
