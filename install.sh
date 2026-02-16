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
# MacOS Setup
# -----------------------------------------------------------------------------
if [[ "$OS" == "Darwin" ]]; then
    echo "[MacOS] Detected. Checking Homebrew..."
    if ! command -v brew &>/dev/null; then
        echo "[MacOS] Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "[MacOS] Installing Core Utilities & Dev Tools..."
    brew install git zsh wget node ripgrep fd neovim cmake llvm cppcheck rustup-init
    brew install --cask kitty font-fira-code-nerd-font

# -----------------------------------------------------------------------------
# Linux Setup
# -----------------------------------------------------------------------------
elif [[ "$OS" == "Linux" ]]; then
    echo "[Linux] Detected. Updating package lists..."
    sudo apt update

    echo "[Linux] Installing System & Dev Dependencies..."
    # Added cppcheck (fix neovim error) and clang/llvm for C++
    sudo apt install -y build-essential git zsh curl wget unzip tar \
                        xclip nodejs npm ripgrep fd-find python3-venv \
                        cmake clang lldb lld cppcheck pkg-config libssl-dev

    # Install Rust if not present
    if ! command -v cargo &>/dev/null; then
        echo "[Linux] Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi

    # Symlink fd-find to fd (Neovim expects 'fd')
    if ! command -v fd &>/dev/null; then
        sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
    fi

    # Install Neovim Unstable PPA
    echo "[Linux] Adding Neovim Unstable PPA..."
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt update
    echo "[Linux] Installing/Upgrading Neovim..."
    sudo apt install -y neovim

    # Install Performance Tools (Graceful failure for mainline kernels)
    echo "[Linux] Installing Performance Counters (perf)..."
    sudo apt install -y linux-tools-common linux-tools-generic linux-tools-$(uname -r) || \
    echo "![WARNING] Could not install linux-tools via apt. Using manually compiled version."

    # Install Kitty Terminal
    if ! command -v kitty &>/dev/null; then
        echo "[Linux] Installing Kitty Terminal..."
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
        mkdir -p ~/.local/bin
        ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty
    fi

    # Install Nerd Fonts
    if [[ ! -d "$FONT_DIR/FiraCode" ]]; then
        echo "[Linux] Installing FiraCode Nerd Font..."
        mkdir -p "$FONT_DIR/FiraCode"
        wget -q --show-progress -P "$FONT_DIR/FiraCode" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
        unzip -q "$FONT_DIR/FiraCode/FiraCode.zip" -d "$FONT_DIR/FiraCode"
        rm "$FONT_DIR/FiraCode/FiraCode.zip"
        fc-cache -fv
    fi
fi

# -----------------------------------------------------------------------------
# Shell Configuration & Symlinking
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

create_symlink() {
    local src=$1
    local dest=$2
    mkdir -p "$(dirname "$dest")"
    [ -L "$dest" ] && rm "$dest"
    [ -e "$dest" ] && mv "$dest" "${dest}.backup"
    ln -sf "$src" "$dest"
    echo "[Link] $dest -> $src"
}

echo "==== Linking Configuration Files ===="
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%s)"
fi
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

echo "==== Setup Complete ===="
echo "Please restart your terminal or run 'source ~/.zshrc' and 'source ~/.cargo/env'."
