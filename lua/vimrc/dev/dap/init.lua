local log = require("vimrc.log")
local map = require("vimrc.config.mapping").map

local ok, dap = pcall(require, "dap")
if not ok then
  log.warn("dap not installed")
  return
end

local ok, dapui = pcall(require, "dapui")
if not ok then
  log.warn("dapui not installed")
  return
end

local ok, dapvirt = pcall(require, "nvim-dap-virtual-text")
if not ok then
  log.warn("nvim-dap-virtual-text not installed")
  return
end

dapui.setup()
dapvirt.setup({})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close({})
end

local my_dap_go_config = require("vimrc.dev.dap.go")

local debug_test = function()
  local ft = vim.bo.filetype
  if ft == "go" then
    my_dap_go_config.debug_test()
  elseif ft == "rust" then
    require("rust-tools.debuggables").debuggables()
    -- log.error("rust not setup")
  else
    log.warn("DAP Debug Test not configured for", ft)
  end
end

vim.fn.sign_define('DapBreakpoint',{ text ='🟥', texthl ='', linehl ='', numhl =''})
vim.fn.sign_define('DapStopped',{ text ='▶️', texthl ='', linehl ='', numhl =''})

map({ "n" }, "<F5>", function() dap.continue() end, { desc = "DAP Continue" })
map({ "n" }, "<Leader>db", function() dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
map({ "n" }, "<Leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint Condition: ")) end,
  { desc = "Toggle Breakpoint" })
map({ "n" }, "<Leader>dt", function() debug_test() end, { desc = "DAP Test" })

-- TODO only when actively debugging?
map({ "n" }, "<F9>", function() dap.step_into() end, { desc = "DAP Step Into" })
map({ "n" }, "<F10>", function() dap.step_out() end, { desc = "DAP Step Out" })
map({ "n" }, "<F12>", function() dap.step_over() end, { desc = "DAP Step Over" })
map({ "n" }, "<Leader>dr", function() dap.repl.open() end, { desc = "Toggle Debugger Repl" })
map({ "n" }, "<Leader>di", function() dapui.toggle({}) end, { desc = "Toggle Debugger UI" })
