Here is a revamped, workflow-optimized version of your `Keybinds.md`.

Instead of organizing purely by *tool* (which buries your daily workflow at the bottom), I have reorganized this cheat sheet by **Action**.

Your Firedancer commands, session management, and the all-important `Ctrl+h/j/k/l` navigation are now right at the top where you need them.

---

# Environment Cheat Sheet

## 1. Daily Firedancer Workflow

*These aliases are available instantly in your Zsh prompt.*

| Command | Action |
| --- | --- |
| **`s`** | **SSH into the server** (`ubuntu@fdserver`) |
| **`t`** | **Attach / Create Tmux session** (Run this right after `s`) |
| **`pullfd`** | Full sync: `git pull`, submodules, `deps.sh`, and `make -j ...` |
| **`makefd`** | Fast build: `make -j fddev fdctl solana firedancer-dev` |
| **`devfd`** | Run `sudo fddev dev` with `config.toml` |
| **`pktgenfd`** | Run `sudo fddev pktgen` with `config.toml` |
| **`confd`** | Open `config.toml` in Neovim |
| **`exit`** | Leave current shell or detach from tmux session |

---

## 2. Seamless Navigation

*How to move around at the speed of light.*

| Shortcut | Action | Tool |
| --- | --- | --- |
| **`Ctrl` + `h/j/k/l**` | **Move between Neovim splits *and* Tmux panes** | Global |
| **`Shift` + `→ / ←**` | **Fast switch Tmux windows** (tabs) | Tmux |
| **`gd`** | Go to definition under cursor | Neovim |
| **`<leader>e`** | Show floating diagnostics / errors | Neovim |
| **`<leader>ff`** | Fuzzy find files | Neovim |
| **`<leader>fg`** | Live grep / search inside all files | Neovim |

---

## 3. Window & Pane Splitting

*Managing your screen real estate.*

> **Tmux Prefix = `Ctrl+A**`

| Shortcut | Action | Tool |
| --- | --- | --- |
| **`Prefix` + `h/j/k/l**` | **Split pane** left / down / up / right | Tmux |
| **`Prefix` + `Shift` + `H/J/K/L**` | **Resize pane** in that direction | Tmux |
| **`Prefix` + `Z**` | **Zoom** (fullscreen) current pane, press again to unzoom | Tmux |
| **`Prefix` + `C**` | Create a new Tmux window | Tmux |
| **`Prefix` + `D**` | Detach from session (leaves everything running) | Tmux |
| **`Cmd` + `Enter` / `T**` | Open a new local Kitty Window or Tab | Kitty |

---

## 4. Editor Extras (Neovim)

| Shortcut | Action |
| --- | --- |
| **`<leader>fb`** | Find open buffers |
| **`:NvimTreeToggle`** | Open the sidebar file explorer |
| **`:Git`** | Open Fugitive (Git interface) |
