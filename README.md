# Tristan Carter's macOS/Linux Development Setup
Sets up my configured development environment with Neovim, tmux, Zsh, and Kitty. Designed for macOS and Linux.

## Prerequisites
Ensure `git` is installed before running the setup.

* **macOS:** Running `git` in the terminal will automatically prompt you to install the Command Line Tools if it's missing.
* **Linux:** `sudo apt update && sudo apt install git -y`

## Installation
Copy and paste this snippet into your terminal to clone (or update) the repository and run the setup script automatically:

```bash
git clone [https://github.com/tristan-carter/dotfiles.git](https://github.com/tristan-carter/dotfiles.git) ~/dotfiles 2>/dev/null || (cd ~/dotfiles && git fetch && git reset --hard origin/main) && cd ~/dotfiles && chmod +x install.sh && ./install.sh
```bash
chsh -s $(which zsh)
update-desktop-database ~/.local/share/applications
```
