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


# Documenting Setup

## View Icons

```
:NvimWebDeviconsHiTest
```

```lua
-- 󰆧
-- 
-- 󰗀
--  git
--  git diff
-- 󰜘 git commit
--  gitlab
-- 󰡨 docker
--  book
-- λ lambda
--  terraform
--  test
--   vim
--   vault
--  browser
--  settings gear
--  settings dials
--  settings wrench
--  keys
--  star
--  shell
--  shell prompt
-- 󰚩 robot
-- 󰒃 security / shield
--  tmux
--  apple
-- 󰣇 arch
--  linux
--
--  file
--  golang
--  python
--  rust
--  lua
```


## Diffs and Conflict Resolution

Inspiration from https://www.naseraleisa.com/posts/diff#deep-diffing-comparing-against-one-or-more-commits

Open the diff menu
```
<leader>d
```

- diff current working tree `<leader>dd`
- diff smart PR base `<leader>dO`
- conflict resolution `<leader>dc`
    - lhs `<leader>dch`
    - rhs `<leader>dcl`
- History
    - whole repo `<leader>dhr`
    - this file `<leader>dhf` (in visual mode tracks just highlighted section)

#### Markdown diffs

```diff
+ line added
- line removed
```

#### Markdown Table

| Month    | Savings |
| -------- | ------- |
| January  | $250    |
| February | $80     |
| March    | $420    |



## Spell checking

- `z=` for suggestions
- `]s` or `[s` to jump to next/previous misspelled word
- `zg` add word to dictionary (spell good)
- `zug` undo add to dictionary
- `zw` mark word as wrong
- `zG` add word to tmp dictionary

#### Manually edit the spell dictionary
```
:e ~/.config/nvim/spell/en.utf-8.add
:mkspell! %
```

# TODO
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
