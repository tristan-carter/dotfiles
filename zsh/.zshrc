# ── Oh My Zsh ────────────────────────────────────────
# Check if OMZ is actually installed before sourcing
if [ -d "$HOME/.oh-my-zsh" ]; then
  export ZSH="$HOME/.oh-my-zsh"
  ZSH_THEME="powerlevel10k/powerlevel10k"
  plugins=(git)
  source $ZSH/oh-my-zsh.sh
fi

# ── Aliases ─────────────────────────────────────────
alias ll='ls -la'
alias gs='git status'
alias ga='git add'
alias gc='git commit'

# ── Default editor ──────────────────────────────────
export EDITOR="nvim"

# ── OS Specific Configuration (The Switch) ──────────
OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
    # -- MAC OS Setup --
    # Detect Apple Silicon vs Intel Homebrew
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    # Mac specific flags
    export LDFLAGS="-L$(brew --prefix)/opt/openssl/lib"
    export CPPFLAGS="-I$(brew --prefix)/opt/openssl/include"
    export PATH="$(brew --prefix)/opt/llvm/bin:$PATH"

elif [[ "$OS" == "Linux" ]]; then
    # -- LINUX Setup --
    # Add Linux specific paths if needed, e.g., .local/bin
    export PATH="$HOME/.local/bin:$PATH"
fi
