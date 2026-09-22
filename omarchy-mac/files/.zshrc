# Carlos's Omarchy / Apple Silicon shell. See omarchy-mac/README.md.
# Preserve Omarchy's inherited PATH; never replace it with macOS paths.
typeset -U path PATH
path=("$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/.local/share/mise/shims" $path)
export SHELL=/usr/bin/zsh
export EDITOR=nvim
export VISUAL=nvim
export LESS='-R --mouse'

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
zstyle ':omz:update' mode disabled
plugins=(git)
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  autoload -Uz compinit && compinit
  PROMPT='%n@%m %~ %# '
fi

[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Keep the existing Omarchy Node / Codex manager. Do not activate fnm alongside it.
(( $+commands[mise] )) && eval "$(mise activate zsh)"
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
(( $+commands[fzf] )) && source <(fzf --zsh)
# Last history integration owns Ctrl+R and Up, as on the Mac.
(( $+commands[atuin] )) && eval "$(atuin init zsh)"

alias v=nvim
alias vi=nvim
alias vim=nvim
alias cx=codex
alias c=claude

# OSC 52 works over SSH. For local apps use the Wayland clipboard.
yank() { printf '\033]52;c;%s\a' "$(base64 | tr -d '\r\n')"; }
pbcopy() {
  if [[ -n "$WAYLAND_DISPLAY" ]] && (( $+commands[wl-copy] )); then
    wl-copy
  else
    yank
  fi
}
pbpaste() { wl-paste --no-newline; }
open() { xdg-open "$@"; }
chrome() { chromium --new-window "$@"; }

claude-tmux() {
  local folder="${1:-.}"
  tmux new-window -c "$folder" \; send-keys 'claude' C-m \; split-window -h -c "$folder"
}

# Search files by contents, preview matches, then open the selected file.
rga-fzf() {
  (( $+commands[rga] && $+commands[fzf] )) || {
    print -u2 'rga-fzf requires ripgrep-all and fzf'; return 1
  }
  local file
  file=$(rga --files-with-matches -- "${1:-.}" |
    fzf --preview 'rga --pretty --context 5 -- . {}' --preview-window '60%:wrap') || return
  [[ -n "$file" ]] && xdg-open "$file"
}

# Private values and project-specific helpers stay outside Git.
[[ -r "$HOME/.env" ]] && source "$HOME/.env"
[[ -r "$HOME/dev/inpractise/.shell-utils.zsh" ]] && source "$HOME/dev/inpractise/.shell-utils.zsh"
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Syntax highlighting should be loaded after widgets and user keybindings.
[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
