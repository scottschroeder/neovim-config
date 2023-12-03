local log = require("vimrc.log")

local ok, copilot_cmp = require("vimrc.utils").safe_reloader("copilot_cmp")
if not ok then
  return {
    setup = function()
      log.warn("copilot_cmp is not installed")
    end
  }
end

local setup = function()
  log.warn("setup copilot cmp")
  copilot_cmp.setup({
  })
end

return {
  setup = setup
}
