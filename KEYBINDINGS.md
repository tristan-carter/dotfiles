# Keybindings & Commands Reference

| Command / Alias | Description |
| :--- | :--- |
| **s** | **SSH into the Razer Laptop** (`tristan@pop-os`) |
| **t** | **Tmux Session Management** (Attach to `main` session or create new) |
| **display-off** | Power off the remote Razer display (via SSH/X authority) |
| **display-on** | Power on the remote Razer display |

-----

## Kitty Terminal Emulator

| Shortcut | Action |
| :--- | :--- |
| **Cmd+Enter** | Open new Kitty **window** |
| **Cmd+T** | Open new **tab** |
| **Cmd+W** | Close window/tab |
| **Ctrl+A** | Send prefix to tmux (Primary Prefix) |
| **Ctrl+B** | Send prefix to tmux (Alternate Prefix) |
| **Cmd+Shift+→ / ←** | Switch tabs |
| **Cmd+Q** | Quit Kitty |

-----

## tmux Multiplexer

> Prefix = `Ctrl+A`

| Shortcut | Action |
| :--- | :--- |
| **Prefix + "** | Split pane horizontally |
| **Prefix + %** | Split pane vertically |
| **Prefix + C** | Create new tmux window |
| **Prefix + N / P** | Next / previous tmux window |
| **Prefix + Arrow keys** | Move between panes |
| **Prefix + R** | **Reload tmux config** (`~/.tmux.conf`) |
| **Prefix + D** | Detach from session (session stays running) |
| **Prefix + Z** | Zoom / unzoom pane |
| **Mouse drag / click** | Resize / focus panes (mouse enabled) |

-----

## Neovim Editor

### Navigation & Core

| Shortcut | Action |
| :--- | :--- |
| **Ctrl+h / j / k / l** | **Seamlessly move** between Neovim splits *and* tmux panes |
| **gd** | Go to definition (LSP) |
| **\<leader\>e** | Show diagnostics (LSP) |
| **\<leader\>ff** | Fuzzy find files (Telescope) |
| **:NvimTreeToggle** | Toggle file explorer |
| **:Git** | Open fugitive Git interface |

### Build & Debugging

| Shortcut | Action |
| :--- | :--- |
| **\<leader\>m** | Run `:make` (Build project) |
| **\<leader\>mr** | Run `:make run` |
| **\<leader\>v** | **Run Valgrind** (Memory Check) |
| **\<leader\>d** | **Debug** (Start/Continue DAP) |
| **\<leader\>du** | Toggle DAP UI |
| **:TSUpdate** | Update Treesitter parsers |

-----

## Shell & Utilities (Zsh)

| Command / Alias | Description |
| :--- | :--- |
| **v** | Open Neovim (`nvim`) |
| **ll** | List files (long format: `ls -la`) |
| **gs / ga / gc** | Git status / add / commit |
| **pstat** | Run **`perf stat`** for cache miss/cycle analysis |
| **precord** | Run **`perf record`** for profiling |
| **exit** | Leave current shell or detach from tmux session |

-----

## Notes

  * **Persistence:** Closing the Kitty window **does not kill** your remote Neovim or tmux session.
  * **Reattach:** Use the `t` alias or `s` alias to reconnect and run `t` to reattach instantly.
  * **Clipboard:** Copying in Neovim automatically copies to your Mac's system clipboard (OSC 52 via Kitty).
