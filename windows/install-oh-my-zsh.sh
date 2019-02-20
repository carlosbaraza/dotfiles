#!/bin/bash

sudo apt-get install zsh

# Configure ZSH
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
rm ~/.bashrc
ln -s $CURRENT_DIR/.bashrc ~/.bashrc

# Install Oh My ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"