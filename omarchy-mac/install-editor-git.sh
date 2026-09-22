#!/usr/bin/env bash
set -euo pipefail
profile_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
omarchy pkg add neovim git-delta gcc make unzip tree-sitter-cli
"$profile_dir/configs.py" apply --scope editor-git
nvim --headless '+Lazy! restore' +qa
printf '\nAstroNvim and Git configured. Open nvim to let Mason finish any missing language tools.\n'
