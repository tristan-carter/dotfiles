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

    echo "Installing Core Tools & Dependencies..."
    # 'node' is required for Pyright; 'wget' is useful for lazy.nvim
    brew install git zsh reattach-to-user-namespace wget node

    echo "Installing Neovim (Stable)..."
    # If neovim is already installed, unlink it to ensure we don't stick with a 'HEAD' or 'Nightly' version
    if brew list neovim &>/dev/null; then
        brew unlink neovim || true
    fi
    brew install neovim

    echo "Installing Fonts & Terminal..."
    brew install --cask kitty font-fira-code-nerd-font

    echo "Installing Language Servers..."
    # 1. Python (Pyright) - Requires Node.js
    if ! command -v pyright &>/dev/null; then
        echo "Installing Pyright..."
        npm install -g pyright
    fi

    # 2. Lua (Lua Language Server) - Crucial for editing Neovim config
    brew install lua-language-server

    # 3. Rust - Handled by Rustup
    if ! command -v rustup &>/dev/null; then
        echo "Installing Rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi

elif [[ "$OS" == "Linux" ]]; then
    # Linux Setup (Assumes Debian/Ubuntu based)
    sudo apt update
    sudo apt install -y neovim tmux git zsh curl wget xclip nodejs npm

    # Install Pyright
    sudo npm install -g pyright

    # Install Kitty (Official Binary)
    if ! command -v kitty &>/dev/null; then
        echo "Installing Kitty..."
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
        
        # Link binary to path
        mkdir -p ~/.local/bin
        ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty

        # Create Desktop Launcher
        mkdir -p ~/.local/share/applications
        cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
        
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
    
    # Ensure parent directory exists
    mkdir -p "$(dirname "$dest")"

    if [ -e "$dest" ]; then
        if [ "$(readlink "$dest")" != "$src" ]; then
            mv "$dest" "${dest}.backup"
            echo "Backed up existing $dest to ${dest}.backup"
        fi
    fi
    ln -sf "$src" "$dest"
}

create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
create_symlink "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
create_symlink "$DOTFILES_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# ── 4. Neovim Bootstrap ──────────────────────────────
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [[ ! -d "$LAZY_PATH" ]]; then
    echo "Bootstrapping Lazy.nvim..."
    mkdir -p "$(dirname "$LAZY_PATH")"
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH"
fi

echo "==== Setup Complete ===="
echo "Please restart your terminal for changes to take effect."
