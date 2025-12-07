#!/usr/bin/env bash
set -euo pipefail
# -----------------------------------------------------------------------------
# Configuration & Variables
# -----------------------------------------------------------------------------
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OS="$(uname -s)"
FONT_DIR="$HOME/.local/share/fonts"
echo "==== Initializing Environment Setup ===="
# -----------------------------------------------------------------------------
# MacOS (Darwin) Setup
# -----------------------------------------------------------------------------
if [[ "$OS" == "Darwin" ]]; then
    echo "[MacOS] Detected. Checking Homebrew..."
    if ! command -v brew &>/dev/null; then
        echo "[MacOS] Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    echo "[MacOS] Installing Core Utilities..."
    brew install git zsh wget node ripgrep fd
    echo "[MacOS] Installing Development Tools & UI..."
    brew install neovim
    brew install --cask kitty font-fira-code-nerd-font
    # LLVM/Clang required for robust C++ development and Treesitter compilation
    echo "[MacOS] Installing LLVM & Build Tools..."
    brew install llvm cmake
# -----------------------------------------------------------------------------
# Linux (Pop!_OS / Ubuntu) Setup
# -----------------------------------------------------------------------------
elif [[ "$OS" == "Linux" ]]; then
    echo "[Linux] Detected. Updating package lists..."
    sudo apt update
    echo "[Linux] Installing System Dependencies..."
    # build-essential: Required for GCC/Make (Neovim plugins, C++ projects)
    # python3-venv: Required for Mason (Neovim LSP manager)
    # ripgrep / fd-find: Required for Telescope
    # xclip: Required for system clipboard integration
    sudo apt install -y build-essential git zsh curl wget unzip tar \
                        xclip nodejs npm ripgrep fd-find python3-venv
    # Symlink fd-find to fd (Neovim expects 'fd')
    if ! command -v fd &>/dev/null; then
        sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
    fi
    # Install Neovim (Stable PPA for consistency with Mac)
    # Default apt version is often too old (v0.6) for modern plugins
    echo "[Linux] Adding Neovim Stable PPA..."
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt update
    echo "[Linux] Installing/Upgrading Neovim..."
    sudo apt install -y neovim
    # Install Linux Performance Tools (perf)
    echo "[Linux] Installing Performance Counters (perf)..."
    sudo apt install -y linux-tools-common linux-tools-generic linux-tools-$(uname -r)
    # Install Kitty Terminal
    if ! command -v kitty &>/dev/null; then
        echo "[Linux] Installing Kitty Terminal..."
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
       
        # Symlink binary to path
        mkdir -p ~/.local/bin
        ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty
       
        # Desktop Integration
        mkdir -p ~/.local/share/applications
        cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
        sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty.desktop
        sed -i "s|Exec=kitty|Exec=$HOME/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty.desktop
    fi
    # Install Nerd Fonts (FiraCode)
    if [[ ! -d "$FONT_DIR/FiraCode" ]]; then
        echo "[Linux] Installing FiraCode Nerd Font..."
        mkdir -p "$FONT_DIR/FiraCode"
        wget -q --show-progress -P "$FONT_DIR/FiraCode" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
        unzip -q "$FONT_DIR/FiraCode/FiraCode.zip" -d "$FONT_DIR/FiraCode"
        rm "$FONT_DIR/FiraCode/FiraCode.zip"
        echo "[Linux] Refreshing font cache..."
        fc-cache -fv
    fi
fi
# -----------------------------------------------------------------------------
# Shell Configuration (Oh-My-Zsh & Powerlevel10k)
# -----------------------------------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "[Shell] Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "[Shell] Installing Powerlevel10k Theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi
# -----------------------------------------------------------------------------
# Dotfiles Symlinking
# -----------------------------------------------------------------------------
create_symlink() {
    local src=$1
    local dest=$2
    mkdir -p "$(dirname "$dest")"
    if [ -L "$dest" ]; then
        if [ "$(readlink "$dest")" != "$src" ]; then
            echo "[Link] Updating symlink: $dest"
            ln -sf "$src" "$dest"
        fi
    elif [ -e "$dest" ]; then
        echo "[Link] Backing up existing file: ${dest}.backup"
        mv "$dest" "${dest}.backup"
        ln -sf "$src" "$dest"
    else
        echo "[Link] Creating symlink: $dest"
        ln -sf "$src" "$dest"
    fi
}
echo "==== Linking Configuration Files ===="
# Zsh
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
# Tmux
create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
# Kitty
create_symlink "$DOTFILES_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
# Neovim (Links the entire configuration directory)
# Ensures 'lua', 'plugin', and 'init.lua' are all synced
if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
    echo "[Link] Backing up existing nvim directory..."
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%s)"
fi
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
echo "==== Setup Complete ===="
echo "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
