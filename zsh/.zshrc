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
    alias s="kitty +kitten ssh ubuntu@fdserver"
    
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

    # ── Screen Power Management (X Authority Fix) ────────────────
    # Use these functions to safely turn off the screen power when SSHing.
    function display-off() {
        local AUTH_FILE=$(find /run/user/$(id -u) -name 'Xauthority' 2>/dev/null | head -n 1)
        
        if [ -n "$AUTH_FILE" ]; then
            # Export the XAUTH key and the correct display number (:1 worked)
            export XAUTHORITY=$AUTH_FILE
            export DISPLAY=:1 
            
            echo "Turning display off..."
            xset dpms force off
        else
            echo "ERROR: Xauthority key missing. Ensure the Razer is logged in locally."
        fi
    }

    # Alias to restore the screen power
    alias display-on="xset dpms force on"
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
alias t="tmux new-session -A -s main"

# ── Firedancer Development ───────────────────────────
alias makefd="make -j fddev fdctl solana firedancer-dev"
alias pullfd="git pull && git submodule update && ./deps.sh && make -j fddev fdctl solana firedancer-dev"
alias pktfd="sudo fddev pktgen --config ~/config.toml"
alias devfd="sudo fddev dev --config ~/config.toml"
alias confd="nvim ~/config.toml"

# ── Hardware & Performance Tuning ────────────────────
alias disable-ht="echo off | sudo tee /sys/devices/system/cpu/smt/control"

function clockspeed() {
    if [ -z "$1" ]; then
        echo "Usage: clockspeed <GHz> (e.g., clockspeed 3.2)"
        return 1
    fi
    sudo cpupower frequency-set -u "${1}GHz" -d "${1}GHz"
}

# ── Firedancer Branch Management ─────────────────────
function branchfd() {
    if [ -z "$1" ]; then
        echo "Usage: branchfd <branch-name>"
        return 1
    fi
    git pull
    git checkout -b "$1" "tristan/tristan-carter/$1"
    make -j fddev fdctl solana firedancer-dev
}

# ── Prompt Configuration ─────────────────────────────
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
