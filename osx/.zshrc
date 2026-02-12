# Path to your oh-my-zsh installation.
export ZSH=/Users/carlosbaraza/.oh-my-zsh

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# =============================================================================
# PATH Configuration
# =============================================================================

# Base PATH (Homebrew will prepend to this)
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Go
export GOPATH=$HOME/go
export PATH="$PATH:$GOPATH/bin"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Deno
export PATH="$HOME/.deno/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# PostgreSQL
export PATH="/opt/homebrew/opt/postgresql@13/bin:$PATH"

# Android SDK
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# Local binaries
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cache/lm-studio/bin:$PATH"
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# =============================================================================
# Tool Initialization
# =============================================================================

# pyenv - must be before any Python usage
eval "$(pyenv init -)"

# fnm (Fast Node Manager)
eval "$(fnm env --use-on-cd)"

# zoxide - smarter cd command
eval "$(zoxide init zsh)"

# atuin - better shell history search (Ctrl+R)
eval "$(atuin init zsh)"

# =============================================================================
# External Sources
# =============================================================================

# iTerm2 shell integration
test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"

# Google Cloud SDK
source '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Private env variables
source ~/.env

# =============================================================================
# Editor
# =============================================================================

export EDITOR="nvim"
export VISUAL="nvim"

# =============================================================================
# Pager (enable mouse scrolling in less/git diff)
# =============================================================================

export LESS='-R --mouse'

# =============================================================================
# Aliases
# =============================================================================

# Neovim
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# Chrome
chrome() { open -na "Google Chrome" --args --new-window "$@"; }

# Claude
alias claude="$HOME/.local/bin/claude"
alias c="ENABLE_TOOL_SEARCH=true claude --allow-dangerously-skip-permissions"

# =============================================================================
# Functions
# =============================================================================

# Ripgrep + fzf for searching files
rga-fzf() {
    RG_PREFIX="rga --files-with-matches"
    local file
    file="$(
        FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
            fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
                --phony -q "$1" \
                --bind "change:reload:$RG_PREFIX {q}" \
                --preview-window="60%:wrap"
    )" &&
    echo "opening $file" &&
    open "$file"
}

# Claude tmux setup - create tmux window with Claude on left, terminal on right
claude-tmux() {
    local folder="${1:-.}"
    tmux new-window -c "$folder" \; \
        send-keys "claude" C-m \; \
        split-window -h -c "$folder"
}

# InPractise utilities (ip, ipa, wt)
# source ~/dev/inpractise/.shell-utils.zsh
source ~/dev/inpractise/.shell-utils.zsh

# Local overrides (not tracked in dotfiles)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
