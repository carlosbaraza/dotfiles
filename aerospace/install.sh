#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./install.sh

Installs AeroSpace and borders.
'
    exit
fi

cd "$(dirname "$0")"

main() {
    # AeroSpace – tiling window manager
    brew install --cask nikitabobko/tap/aerospace

    # borders – window border highlights
    brew install FelixKratz/formulae/borders

    echo "Done! Run aerospace/setup.sh to create config symlinks."
}

main "$@"
