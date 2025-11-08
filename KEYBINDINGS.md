
# ⌨️ Keybindings & Shortcuts Reference

Quick reference for all common keybinds across **Kitty**, **tmux**, and **Neovim** in this setup.  
Designed for macOS + Windows keyboard using Kitty + tmux + Zsh + Neovim.

---

## 🐱 Kitty

| Shortcut | Action |
|-----------|--------|
| **Cmd+Enter** | Open new Kitty **window** |
| **Cmd+T** | Open new **tab** |
| **Cmd+W** | Close window/tab |
| **Ctrl+A** | Send prefix to tmux |
| **Ctrl+B** | Send prefix to tmux (alt prefix) |
| **Cmd+,** | Open Kitty preferences |
| **Cmd+Shift+→ / ←** | Switch tabs (Kitty default) |
| **Cmd+Q** | Quit Kitty |
| **ktmux** *(shell alias)* | Open new Kitty window attached to same tmux session |

---

## 🧱 tmux

> Prefix = `Ctrl+A`

| Shortcut | Action |
|-----------|--------|
| **Prefix + " ** | Split pane horizontally |
| **Prefix + %** | Split pane vertically |
| **Prefix + C** | Create new tmux window |
| **Prefix + N / P** | Next / previous tmux window |
| **Prefix + ,** | Rename current window |
| **Prefix + &** | Close current window |
| **Prefix + Arrow keys** | Move between panes |
| **Prefix + Z** | Zoom / unzoom pane |
| **Prefix + R** | Reload tmux config |
| **Prefix + D** | Detach from session |
| **tmux ls** | List active sessions |
| **tmux attach -t main** | Reattach to main session |
| **Prefix + ?** | Show keybindings inside tmux |
| **Mouse drag / click** | Resize / focus panes (mouse enabled) |

---

## 🌀 Neovim

### 🔁 Navigation

| Shortcut | Action |
|-----------|--------|
| **Ctrl+h / j / k / l** | Move between Neovim splits *and* tmux panes |
| **:q** | Quit buffer |
| **:w** | Save file |
| **:wq** | Save + quit |
| **:NvimTreeToggle** | Toggle file explorer |
| **:Git** | Open fugitive Git interface |

### 🌈 Visual & Utility

| Shortcut | Action |
|-----------|--------|
| **Space** | Reserved for leader key (future mappings) |
| **:TSUpdate** | Update Treesitter parsers |
| **:colorscheme catppuccin** | Switch to soft color theme |
| **:colorscheme gruvbox** | Switch to classic dark theme |

---

## 🧩 Shell / Zsh

| Command / Shortcut | Action |
|---------------------|--------|
| **ll** | List files (long format) |
| **gs / ga / gc** | Git status / add / commit |
| **tmux attach -t main** | Reattach to existing tmux session |
| **ktmux** | Launch new Kitty window attached to tmux |
| **exit** | Leave shell (or detach from tmux) |

---

## 🧰 Tips

- Close Kitty anytime — tmux + Neovim stay alive in the background.  
  Reattach later with:
  ```bash
  tmux attach -t main
