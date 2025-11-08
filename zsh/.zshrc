# ── Oh My Zsh ────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

# ── Aliases ─────────────────────────────────────────
alias ll='ls -la'
alias gs='git status'
alias ga='git add'
alias gc='git commit'

# ── Default editor ──────────────────────────────────
export EDITOR="nvim"

# ── Auto-start or attach tmux ───────────────────────
if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
  tmux attach -t main || tmux new -s main
fi

# ── Kitty helper alias ──────────────────────────────
# Opens new Kitty window attached to same tmux session
alias ktmux='kitty @ launch --type=window tmux attach -t main'
