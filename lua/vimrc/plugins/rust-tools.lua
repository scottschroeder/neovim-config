local log = require("vimrc.log")

local ok, mason_path = pcall(require, "mason-core.path")
if not ok then
  log.warn("mason-core not installed")
  return
end

local codelldb_package = mason_path.package_prefix("codelldb")
local codelldb_path = 'codelldb'
local liblldb_path = codelldb_package .. 'lldb/lib/liblldb.so'

local opts = {
    -- ... other configs
    dap = {
        adapter = require('rust-tools.dap').get_codelldb_adapter(
            codelldb_path, liblldb_path)
    }
}


require('rust-tools').setup(opts)
