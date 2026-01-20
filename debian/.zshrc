# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# =============================================================================
# PATH Configuration
# =============================================================================

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Neovim (if installed to /opt)
[ -d /opt/nvim-linux-x86_64/bin ] && export PATH="/opt/nvim-linux-x86_64/bin:$PATH"

# =============================================================================
# Tool Initialization (only if installed)
# =============================================================================

command -v fnm &> /dev/null && eval "$(fnm env --use-on-cd)"
command -v zoxide &> /dev/null && eval "$(zoxide init zsh)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# =============================================================================
# External Sources
# =============================================================================

[ -f ~/.env ] && source ~/.env

# =============================================================================
# Aliases
# =============================================================================

alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# Claude (installed at ~/.local/bin/claude)
alias c="claude --allow-dangerously-skip-permissions"
