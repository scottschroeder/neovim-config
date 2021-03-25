-- https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
USER = vim.fn.expand('$USER')

local home = vim.fn.expand("$HOME")

local sumneko_root_path = home .. "/.hab/build/lua-language-server"
local sumneko_binary = ""

if vim.fn.empty(vim.fn.glob(sumneko_root_path)) > 0 then
  print(sumneko_root_path)
    return
end

if vim.fn.has("mac") == 1 then
    sumneko_binary = sumneko_root_path .. "/bin/macOS/lua-language-server"
elseif vim.fn.has("unix") == 1 then
    sumneko_binary = sumneko_root_path .. "/bin/Linux/lua-language-server"
else
      print("sumneko only setup for mac/linux")
end

require('lspconfig').sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = vim.split(package.path, ';')
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
            }
        }
    }
}
