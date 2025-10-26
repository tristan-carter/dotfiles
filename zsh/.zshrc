# Use Oh-My-Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"  # minimal hacker style
plugins=(git)

# Alias examples
alias ll='ls -la'
alias gs='git status'
alias ga='git add'
alias gc='git commit'

# Auto-start tmux if not already inside
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach -t main || tmux new -s main
fi

# Use Neovim as default editor
export EDITOR="nvim"


# Auto-start or attach to tmux when opening a terminal
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach -t main || tmux new -s main
fi

