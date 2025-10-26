#!/bin/bash
set -e

echo "Installing Homebrew if needed..."
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing essential packages..."
brew install neovim tmux git zsh reattach-to-user-namespace
brew install --cask kitty

echo "Setting up symlinks for dotfiles..."
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
mkdir -p ~/.config/kitty
ln -sf ~/dotfiles/kitty/kitty.conf ~/.config/kitty/kitty.conf

echo "Setting Neovim as default editor..."
export EDITOR="nvim"

echo "Dotfiles setup complete"
echo "Please restart your terminal or source ~/.zshrc"

