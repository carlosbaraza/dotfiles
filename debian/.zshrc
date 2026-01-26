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

# fnm (Fast Node Manager)
[ -d "$HOME/.local/share/fnm" ] && export PATH="$HOME/.local/share/fnm:$PATH"

# =============================================================================
# Tool Initialization (only if installed)
# =============================================================================

command -v fnm &> /dev/null && eval "$(fnm env --use-on-cd)"
command -v zoxide &> /dev/null && eval "$(zoxide init zsh)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# atuin (better shell history)
[ -f "$HOME/.atuin/bin/env" ] && source "$HOME/.atuin/bin/env" && eval "$(atuin init zsh)"

# =============================================================================
# External Sources
# =============================================================================

[ -f ~/.env ] && source ~/.env
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# =============================================================================
# Aliases
# =============================================================================

alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# Claude (installed at ~/.local/bin/claude)
alias c="claude --allow-dangerously-skip-permissions"

# OSC52 clipboard (works over SSH)
yank() { printf "\033]52;c;%s\a" "$(cat | base64 | tr -d '\r\n')"; }
[[ "$OSTYPE" == linux* ]] && alias pbcopy='yank'
