#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./setup.sh

Creates symlinks for AeroSpace config files.
'
    exit
fi

cd "$(dirname "$0")"

main() {
    rm -f ~/.aerospace.toml; ln -s ~/dotfiles/aerospace/.aerospace.toml ~/.aerospace.toml

    echo "Aerospace config symlinks created."
}

main "$@"
