#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo $CURRENT_DIR

rm ~/.gitconfig
ln -s $CURRENT_DIR/../git/gitconfig ~/.gitconfig

rm ~/.gitignore
ln -s $CURRENT_DIR/../git/gitignore ~/.gitignore