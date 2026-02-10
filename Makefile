.PHONY: all test lint fmt fmt-check check

all: fmt-check lint test

test:
	nvim --headless -u tests/minimal_init.lua -c "luafile tests/run_tests.lua"

lint:
	luacheck lua/ init.lua tests/ after/

fmt:
	stylua lua/ init.lua tests/ after/

fmt-check:
	stylua --check lua/ init.lua tests/ after/

check: fmt-check lint test
