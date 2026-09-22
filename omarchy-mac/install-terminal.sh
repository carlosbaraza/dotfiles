#!/usr/bin/env bash
set -euo pipefail
profile_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
mapfile -t packages < <(sed '/^[[:space:]]*#/d; /^[[:space:]]*$/d' "$profile_dir/packages.txt")
# Omarchy handles package elevation; run in a terminal for its sudo prompt.
omarchy pkg add "${packages[@]}"
if [[ ! -e "$HOME/.oh-my-zsh" ]]; then
  git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi
"$profile_dir/configs.py" apply --scope terminal
printf '\nTerminal config installed. Run chsh -s /usr/bin/zsh to make Zsh your login shell.\n'
