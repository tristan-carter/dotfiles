#!/bin/bash
set -euo pipefail

echo "==== Starting dotfiles installation ===="

# ---------------------------
# Homebrew installation
#!/bin/bash
set -euo pipefail

echo "==== Starting dotfiles installation ===="

# Homebrew
echo "[INFO] Checking Homebrew installation..."
if ! command -v brew &>/dev/null; then
    echo "[INFO] Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "[INFO] Homebrew is already installed."
fi

# Packages
echo "[INFO] Installing essential packages..."
brew install neovim tmux git zsh reattach-to-user-namespace
brew install --cask kitty

# Symlinks
echo "[INFO] Creating symlinks for dotfiles..."
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
mkdir -p ~/.config/kitty
ln -sf ~/dotfiles/kitty/kitty.conf ~/.config/kitty/kitty.conf

# Editor
echo "[INFO] Setting Neovim as default editor..."
export EDITOR="nvim"

# Neovim plugins
echo "[INFO] Installing Neovim plugin manager (lazy.nvim) if missing..."
LAZY_PATH="$HOME/.config/nvim/lazy/lazy.nvim"
if [ ! -d "$LAZY_PATH" ]; then
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH"
fi

echo "[INFO] Installing Neovim plugins..."
nvim --headless +Lazy! sync +qa

# Tmux
echo "[INFO] Setting up tmux session..."
if command -v tmux &> /dev/null && [ -z "${TMUX:-}" ]; then
    tmux attach -t main || tmux new -s main
fi

echo "==== Dotfiles installation complete ===="
echo "[INFO] Restart your terminal or run: source ~/.zshrc"
echo "[INFO] Neovim is now C++ ready with Treesitter and a professional Lualine status line."
