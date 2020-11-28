#!/bin/bash
set -e

nvim_dir="${HOME}/.config/nvim"

mkdir -pv "${nvim_dir}"

ln -sv "$(pwd)/init.vim" "${nvim_dir}"
ln -sv "$(pwd)/lua" "${nvim_dir}/lua"
