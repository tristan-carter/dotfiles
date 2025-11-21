# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Path & Environment (Cross-Platform) ──────────────
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"

OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
    # Detect Homebrew (Apple Silicon vs Intel)
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    # MacOS Compilation Flags
    export LDFLAGS="-L$(brew --prefix)/opt/openssl/lib"
    export CPPFLAGS="-I$(brew --prefix)/opt/openssl/include"
    export PATH="$(brew --prefix)/opt/llvm/bin:$PATH"

elif [[ "$OS" == "Linux" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# ── Oh My Zsh ────────────────────────────────────────
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

if [ -f "$ZSH/oh-my-zsh.sh" ]; then
    source "$ZSH/oh-my-zsh.sh"
fi

# ── Aliases ──────────────────────────────────────────
alias ll='ls -la'
alias gs='git status'
alias ga='git add'
alias gc='git commit'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
