#!/usr/bin/env bash
set -euo pipefail

echo "==== Starting dotfiles installation ===="

# -----------------------------------------------------
# Detect OS
# -----------------------------------------------------
OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
    PLATFORM="mac"
elif [[ "$OS" == "Linux" ]]; then
    PLATFORM="linux"
else
    echo "[ERROR] Unsupported OS: $OS"
    exit 1
fi

echo "[INFO] Detected platform: $PLATFORM"

# -----------------------------------------------------
# Install packages (macOS vs Linux)
# -----------------------------------------------------
if [[ "$PLATFORM" == "mac" ]]; then
    echo "[INFO] Checking Homebrew installation..."
    if ! command -v brew &>/dev/null; then
        echo "[INFO] Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "[INFO] Homebrew already installed."
    fi

    echo "[INFO] Installing macOS packages..."
    brew install neovim tmux git zsh reattach-to-user-namespace
    brew install --cask kitty

elif [[ "$PLATFORM" == "linux" ]]; then
    echo "[INFO] Updating package lists..."
    sudo apt update

    echo "[INFO] Installing Linux packages..."
    sudo apt install -y neovim tmux git zsh curl wget kitty

    echo "[INFO] Installing Nerd Fonts..."
    sudo apt install -y fonts-jetbrains-mono
fi

# -----------------------------------------------------
# Symlinks (shared)
# -----------------------------------------------------
echo "[INFO] Creating symlinks..."

ln -sf "$HOME/dotfiles/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$HOME/dotfiles/tmux/.tmux.conf" "$HOME/.tmux.conf"

mkdir -p "$HOME/.config/nvim"
ln -sf "$HOME/dotfiles/nvim/init.lua" "$HOME/.config/nvim/init.lua"

mkdir -p "$HOME/.config/kitty"
ln -sf "$HOME/dotfiles/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# -----------------------------------------------------
# Neovim setup
# -----------------------------------------------------
echo "[INFO] Installing lazy.nvim plugin manager..."

LAZY_PATH="$HOME/.config/nvim/lazy/lazy.nvim"
if [[ ! -d "$LAZY_PATH" ]]; then
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH"
fi

echo "[INFO] Installing Neovim plugins..."
nvim --headless +Lazy! sync +qa || true

# -----------------------------------------------------
# Tmux session
# -----------------------------------------------------
if command -v tmux &>/dev/null && [[ -z "${TMUX:-}" ]]; then
    echo "[INFO] Creating/attaching tmux session..."
    tmux attach -t main || tmux new -s main
fi

echo "==== Dotfiles installation complete ===="
echo "[INFO] Restart your terminal or run: source ~/.zshrc"
