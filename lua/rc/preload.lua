-- These are the minimal amount of settings I want applied before anything
-- else is loaded.




-- Set the leader immediately so that any applied bindings use
-- the correct leader key
vim.g.mapleader = " "

-- Turn off some builtin plugins
require("rc.disable_builtin")
