#!/usr/bin/env bash
set -euo pipefail
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OS="$(uname -s)"
echo "==== Starting Setup ===="
if [[ "$OS" == "Darwin" ]]; then
    if ! command -v brew &>/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo "Installing Core Tools & Dependencies..."
    brew install git zsh reattach-to-user-namespace wget node
    echo "Fixing Neovim Version..."
    if brew list neovim &>/dev/null; then
        echo "Uninstalling current Neovim to ensure clean state..."
        brew uninstall neovim --ignore-dependencies || true
    fi
    echo "Installing Neovim (Stable)..."
    brew install neovim
    echo "Installing Fonts & Terminal..."
    brew install --cask kitty font-fira-code-nerd-font
    echo "Installing Language Servers..."
    if ! command -v pyright &>/dev/null; then
        npm install -g pyright
    fi
    brew install lua-language-server
    brew install llvm
    if ! grep -q '/opt/homebrew/opt/llvm/bin' ~/.zshrc; then
        echo 'export PATH="/opt/homebrew/opt/llvm/bin:$PATH"' >> ~/.zshrc
    fi
elif [[ "$OS" == "Linux" ]]; then
    sudo apt update
    sudo apt install -y neovim tmux git zsh curl wget xclip nodejs npm clangd
    sudo npm install -g pyright
    if ! command -v lua-language-server &>/dev/null; then
        mkdir -p ~/.local/share/lua-language-server ~/.local/bin
        wget https://github.com/LuaLS/lua-language-server/releases/download/3.15.0/lua-language-server-3.15.0-linux-x64.tar.gz -O /tmp/lua-ls.tar.gz
        tar -xzf /tmp/lua-ls.tar.gz -C ~/.local/share/lua-language-server
        ln -sf ~/.local/share/lua-language-server/bin/lua-language-server ~/.local/bin/lua-language-server
        rm /tmp/lua-ls.tar.gz
    fi
    if ! command -v kitty &>/dev/null; then
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
        mkdir -p ~/.local/bin
        ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty
        mkdir -p ~/.local/share/applications
        cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
        sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty.desktop
        sed -i "s|Exec=kitty|Exec=$HOME/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty.desktop
    fi
fi
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi
create_symlink() {
    local src=$1
    local dest=$2
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
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [[ ! -d "$LAZY_PATH" ]]; then
    echo "Bootstrapping Lazy.nvim..."
    mkdir -p "$(dirname "$LAZY_PATH")"
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH"
fi
echo "==== Setup Complete ===="
echo "Please restart your terminal or run 'source ~/.zshrc'."
