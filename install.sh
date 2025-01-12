#!/bin/bash

# Create VSCode-Neovim config directory
mkdir -p ~/.config/nvim-vscode

# Install vim-plug if not already installed
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim-vscode/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Link configuration
ln -s ./init.lua ~/.config/nvim-vscode/init.lua
ln -s ./lua/vscode-config ~/.config/nvim-vscode/lua/vscode-config 