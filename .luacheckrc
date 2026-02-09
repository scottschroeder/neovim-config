std = "luajit"
cache = true
read_globals = { "vim" }
globals = { "_G" }
self = false
max_line_length = false

files["tests/**/*_spec.lua"] = {
  read_globals = { "describe", "it", "before_each", "after_each", "assert" },
}
