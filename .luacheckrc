std = "luajit"
cache = true
globals = { "_G", "vim" }
self = false
max_line_length = false

files["tests/**/*_spec.lua"] = {
  read_globals = { "describe", "it", "before_each", "after_each", "assert" },
}

-- Luasnip snippet files use template imports for authoring convenience
files["lua/rc/plugins/luasnip/all.lua"] = { ignore = { "211" } }
files["lua/rc/plugins/luasnip/go.lua"] = { ignore = { "211" } }
files["lua/rc/plugins/luasnip/lua.lua"] = { ignore = { "211" } }
files["lua/rc/plugins/luasnip/rust.lua"] = { ignore = { "211" } }
