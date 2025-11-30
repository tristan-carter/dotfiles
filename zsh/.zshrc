# Enable Powerlevel10k instant prompt.
# This block must remain at the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Environment & Path Configuration ─────────────────
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export VISUAL="nvim"

OS="$(uname -s)"

# ── macOS Configuration ──────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
    # Homebrew Setup (Apple Silicon / Intel fallback)
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    # Build Flags
    export LDFLAGS="-L$(brew --prefix)/opt/openssl/lib"
    export CPPFLAGS="-I$(brew --prefix)/opt/openssl/include"
    export PATH="$(brew --prefix)/opt/llvm/bin:$PATH"

    # Kitty Terminal Integration
    # 'kitten ssh' automatically propagates terminfo and clipboard capability
    alias s="kitty +kitten ssh"
    
    # Mosh Integration (Optional: requires 'brew install mosh')
    alias m="kitty +kitten ssh --kitten=mosh"

# ── Linux Configuration (Razer) ──────────────────────
elif [[ "$OS" == "Linux" ]]; then
    export PATH="$HOME/.local/bin:$PATH"

    # Performance Analysis Tools (perf wrappers)
    # Basic cache miss and cycle analysis
    alias pstat="sudo perf stat -e cache-misses,cache-references,cycles,instructions,branches,branch-misses"
    
    # Sampling profiler configuration
    alias precord="sudo perf record -g"
    alias preport="sudo perf report"
fi

# ── Oh My Zsh Plugins ────────────────────────────────
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins:
# - git: standard git aliases
# - z: jump to frequent directories
# - sudo: double-tap ESC to prepend sudo
plugins=(git z sudo) 

if [ -f "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# ── Aliases: General ─────────────────────────────────
alias v='nvim'
alias vim='nvim'
alias ll='ls -la'

# Use GNU ls colors if available (Linux)
if [[ "$OS" == "Linux" ]]; then
    alias ls='ls --color=auto'
fi

# ── Aliases: Git ─────────────────────────────────────
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'

# ── Aliases: Session Management ──────────────────────
# Attach to existing 'main' session or create new
alias t="tmux attach -t main || tmux new -s main"

# ── Prompt Configuration ─────────────────────────────
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
