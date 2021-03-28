
-- https://github.com/norcalli/nvim-colorizer.lua/issues/35 
package.loaded['colorizer'] = nil
-- this unloads some modules which do not reload correctly
-- require("plenary.reload").reload_module("colorizer", true)
require("colorizer").setup{
  '*'; -- Highlight all files, but customize some others.
}
require('colorizer').attach_to_buffer(0)

-- Some examples
-- #D8DEE9
-- #282c34
-- #282c34
-- #3C4048
-- #f2594b
-- #f28534
-- #e9b143
-- #b0b846
-- #8bba7f
-- #80aa9e
-- #d3869b
-- #af2528
-- #b94c07
-- #b4730e
-- #72761e
-- #477a5b
-- #266b79
-- #924f79
