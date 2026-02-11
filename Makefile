.PHONY: all test lint fmt fmt-check check helptags helptags-check

all: fmt-check lint test helptags-check

helptags:
	nvim --headless --clean -c "helptags doc/" -c "quit"

helptags-check: helptags
	@git diff --exit-code doc/tags || (echo "doc/tags is out of date, run 'make helptags'" && exit 1)

test:
	nvim --headless -u tests/minimal_init.lua -c "luafile tests/run_tests.lua"

lint:
	luacheck lua/ init.lua tests/ after/

fmt:
	stylua lua/ init.lua tests/ after/

fmt-check:
	stylua --check lua/ init.lua tests/ after/

check: fmt-check lint test
