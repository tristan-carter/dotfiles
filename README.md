# Tristan Carter's macOS/Linux Development Setup
Sets up my configured development environment with Neovim, tmux, Zsh, and Kitty. Designed for macOS and Linux.

## Prerequisites
Ensure git is installed before running the setup.

### macOS:
git is usually available or will prompt to install the Command Line Tools automatically.

### Linux:
```bash
sudo apt update && sudo apt install git -y
```
## Installation
Clone the repository and run the installation script:

```bash
git clone https://github.com/tristan-carter/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

## Post-Installation
Restart your terminal or run
```bash
source ~/.zshrc
```
to apply the changes.
