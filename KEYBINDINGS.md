# Keybindings & Commands Reference

| Command / Alias | Description |
| --- | --- |
| **s** | **SSH into the fd server** (`ubuntu@fdserver`) |
| **t** | **Tmux Session Management** (Attach to `main` session or create new) |

---

## Kitty Terminal Emulator

| Shortcut | Action |
| --- | --- |
| **Cmd+Enter** | Open new Kitty **window** |
| **Cmd+T** | Open new **tab** |
| **Cmd+W** | Close window/tab |
| **Cmd+Shift+→ / ←** | Switch Kitty tabs |
| **Cmd+Q** | Quit Kitty |

---

## tmux Multiplexer

> **Prefix = `Ctrl+A**`

### Splitting & Resizing (New!)

| Shortcut | Action |
| --- | --- |
| **Prefix + h / j / k / l** | **Split pane** left / down / up / right |
| **Prefix + Shift + H / J / K / L** | **Resize pane** in that direction (repeatable) |
| **Prefix + Z** | Zoom / unzoom current pane |
| **Mouse drag / click** | Resize / focus panes (mouse enabled) |

### Window & Session Navigation

| Shortcut | Action |
| --- | --- |
| **Shift + → / ←** | **Fast switch windows** (No Prefix required) |
| **Prefix + C** | Create new tmux window (tab) |
| **Prefix + N / P** | Next / previous tmux window (legacy) |
| **Prefix + R** | **Reload tmux config** (`~/.tmux.conf`) |
| **Prefix + D** | Detach from session (session stays running) |

---

## Neovim Editor

### Navigation & Core

| Shortcut | Action |
| --- | --- |
| **Ctrl+h / j / k / l** | **Seamlessly move** between Neovim splits *and* tmux panes |
| **gd** | Go to definition (LSP) |
| **<leader>e** | Show diagnostics (LSP) |
| **<leader>ff** | Fuzzy find files (Telescope) |
| **<leader>fg** | Live grep / search inside files (Telescope) |
| **<leader>fb** | Find open buffers (Telescope) |
| **:NvimTreeToggle** | Toggle file explorer |
| **:Git** | Open fugitive Git interface |

### Build, Debugging & Tools

| Shortcut | Action |
| --- | --- |
| **<leader>m** | Run `:make` (Build project) |
| **<leader>mr** | Run `:make run` (Execute project) |
| **<leader>mc** | Run `:make clean` |
| **<leader>v** | **Run Valgrind** (Memory Check) |
| **<leader>d** | **Debug** (Start/Continue DAP) |
| **<leader>db** | Toggle Debug Breakpoint |
| **<leader>du** | Toggle DAP UI |
| **:TSUpdate** | Update Treesitter parsers |

---

## Shell & Utilities (Zsh)

| Command / Alias | Description |
| --- | --- |
| **v** | Open Neovim (`nvim`) |
| **ll** | List files (long format: `ls -la`) |
| **gs / ga / gc** | Git status / add / commit |
| **pstat** | Run **`perf stat`** for cache miss/cycle analysis |
| **precord** | Run **`perf record`** for profiling |
| **exit** | Leave current shell or detach from tmux session |

---

## Notes

* **Persistence:** Closing the Kitty window **does not kill** your remote Neovim or tmux session.
* **Reattach:** Use the `t` alias or `s` alias to reconnect and run `t` to reattach instantly.
* **Clipboard:** Copying in Neovim automatically copies to your Mac's system clipboard (OSC 52 via Kitty).
