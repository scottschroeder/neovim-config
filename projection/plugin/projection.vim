if exists("g:loaded_projection") || v:version < 800 || !has("nvim")
  finish
endif
let g:loaded_projection = 1

lua projection = require("projection")

" command -nargs=1
