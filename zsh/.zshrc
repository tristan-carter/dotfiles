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

# ── Kitty helper alias ──────────────────────────────
# Opens new Kitty window attached to same tmux session
alias ktmux='kitty @ launch --type=window tmux attach -t main'
