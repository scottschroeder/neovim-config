-- Test runner for headless CI
require("plenary.test_harness").test_directory("tests/", {
  minimal_init = "tests/minimal_init.lua",
  sequential = true,
  pattern = "_spec%.lua$",
})
