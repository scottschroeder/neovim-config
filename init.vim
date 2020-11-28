scriptencoding utf-8
set fileencoding=utf8

" Leader - Use <space>
map <Space> <nop>
let mapleader="\<Space>"

" Edit and Reload this file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :lua require'tools'.reload_nvim()<CR>


" Working with Split Windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
"
" Open new vertical split
nnoremap <leader>w <C-w>v<C-w>l
" Open a new horizontal split
nnoremap <leader>h <C-w>s<C-w>j
" Close your current split
nnoremap <leader>c <C-w>c
" Close everything except your current split
nnoremap <leader>o :only<CR>  foo

" Create a new tab (use gt gT to cycle)
nnoremap <leader>t :tabnew<CR>

" This should be system copy paste for y d p P
vmap <Leader>y "+y
nmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>d "+d

nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Auto indentation
" TODO maybe this should be a fancy hook into more language aware formatting
nmap <Leader>= ggV''G=''

" Clear search highlighting
nmap <silent> <Leader>/ :let @/ = ""<CR>
vmap <silent> <Leader>/ :let @/ = ""<CR>

" For going up/down one line even with text wrap on
nnoremap j gj
nnoremap k gk

" D is d$ C is c$ A is $a but Y is yy. WHY?
map Y y$
noremap Y y$

" Turn Spellcheck on with <leader>s
nmap <silent> <leader>s :set spell!<CR>
" Attempt to fix error with <leader>sz
nmap <silent> <leader>sz 1z=
" fix not spellchecking certain things
syntax spell toplevel

" Indentation
command! -nargs=* Wrapon set wrap linebreak nolist " TO ENABLE WRAP "set wrap"
command! -nargs=* Wrapoff set nowrap linebreak list " TO ENABLE WRAP "set wrap"

" set very magic to default
nnoremap / /\v
vnoremap / /\v

" Enable file type detection
filetype on

" autosave
autocmd BufLeave,TabLeave,FocusLost * silent! wall
au FocusLost * call feedkeys("\<C-\>\<C-n>")

" TODO NVIM Terminal
" tnoremap <Esc> <C-\><C-n>
" autocmd TermOpen * if &buftype == 'terminal' | :set nolist | endif


map <C-p> :Files<CR>

" Lua Ext
let g:lua_autoloads = ['tools', 'plug', 'util', 'init']
command! ReloadLua lua require'tools'.unload_auto()

" Plugins
nmap <leader>k :NERDTreeToggle<CR>
map <C-_> :Commentary<CR> " This is actually Ctrl-/, but for some reason that is <C-_>
let NERDTreeIgnore = ['\.pyc$']


" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
"nnoremap <silent> K :call <SID>show_documentation()<CR>

"function! s:show_documentation()
  "if (index(['vim','help'], &filetype) >= 0)
    "execute 'h '.expand('<cword>')
  "else
    "call CocAction('doHover')
  "endif
"endfunction

" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
"nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)

"augroup mygroup
  "autocmd!
  "" Setup formatexpr specified filetype(s).
  "autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  "" Update signature help on jump placeholder.
  "autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
"nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
"nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
"xmap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap if <Plug>(coc-funcobj-i)
"omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
"nmap <silent> <TAB> <Plug>(coc-range-select)
"xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
"command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
"command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
"nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
"nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
"nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
"nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
"nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
"nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
"nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
"nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

lua << EOF
 require('init')
EOF


