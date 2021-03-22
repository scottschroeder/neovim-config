# neovim-config

## TODO
- Spell Checking
- Line wrapping
- Auto Save
  - `use {"907th/vim-auto-save"}`
  - `autocmd BufLeave,TabLeave,FocusLost * silent! wall`
- Focus Lost to Normal Mode
  - `au FocusLost * call feedkeys("\<C-\>\<C-n>")`
- Projectile
- Auto Comment out/in
- AutoCompletion
    - Deoplete shougo/deoplete-lsp & shougo/deoplete.nvim
    - completion.nvim  nvim-lua/completion-nvin
- Fuzzy Selection
  - fzf fzf.vim lspfuzzy
- Treesitter
- LSP
  - https://github.com/neovim/nvim-lspconfig
  - coc
- Statusline
  - galaxyline
  - nvim-bufferline