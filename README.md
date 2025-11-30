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
Clone the repository and run the installation/update script:

```bash
(
  if [ -d ~/dotfiles ]; then
    cd ~/dotfiles
    echo "Syncing repository state..."
    git fetch
    git reset --hard origin/main
  else
    echo "Cloning repository..."
    git clone https://github.com/tristan-carter/dotfiles.git ~/dotfiles
    cd ~/dotfiles
  fi
  
  echo "Running installer..."
  chmod +x install.sh
  ./install.sh
)
```

## Post-Installation
### All Users:
Restart your terminal.

### Linux Users:
Run:
```bash
chsh -s $(which zsh)
update-desktop-database ~/.local/share/applications
```
