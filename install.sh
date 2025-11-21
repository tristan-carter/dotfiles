#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OS="$(uname -s)"

echo "==== Starting Setup ===="

# ── 1. Package Installation ──────────────────────────
if [[ "$OS" == "Darwin" ]]; then
    # macOS Setup
    if ! command -v brew &>/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Note: homebrew/cask-fonts is deprecated; fonts are now in the default tap
    brew install neovim tmux git zsh reattach-to-user-namespace
    brew install --cask kitty font-fira-code

elif [[ "$OS" == "Linux" ]]; then
    # Linux Setup
    sudo apt update
    sudo apt install -y neovim tmux git zsh curl wget xclip fonts-firacode

    # Install Kitty (Official Binary)
    if ! command -v kitty &>/dev/null; then
        echo "Installing Kitty..."
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
        
        # Link binary to path
        mkdir -p ~/.local/bin
        ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty

        # Create Desktop Launcher (for Pop!_OS Apps Menu)
        mkdir -p ~/.local/share/applications
        cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
        
        # Update paths in the desktop file to point to the local installation
        sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty.desktop
        sed -i "s|Exec=kitty|Exec=$HOME/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty.desktop
        
        echo "Kitty added to applications menu."
    fi
fi

# ── 2. Oh My Zsh & Powerlevel10k ─────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# ── 3. Symlinks ──────────────────────────────────────
create_symlink() {
    local src=$1
    local dest=$2
    if [ -e "$dest" ]; then
        # Only backup if it's not already a symlink to the correct location
        if [ "$(readlink "$dest")" != "$src" ]; then
            mv "$dest" "${dest}.backup"
            echo "Backed up existing $dest to ${dest}.backup"
        fi
    fi
    ln -sf "$src" "$dest"
}

create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

mkdir -p "$HOME/.config/nvim"
create_symlink "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"

mkdir -p "$HOME/.config/kitty"
create_symlink "$DOTFILES_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# ── 4. Neovim Bootstrap ──────────────────────────────
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [[ ! -d "$LAZY_PATH" ]]; then
    mkdir -p "$(dirname "$LAZY_PATH")"
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH"
fi

echo "==== Setup Complete ===="
