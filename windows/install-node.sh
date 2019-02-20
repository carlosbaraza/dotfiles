#!/bin/bash

apt-get update

export PROFILE=~/.zshrc
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

source ~/.zshrc

nvm install 8
nvm install 10
nvm install 11
nvm alias default 11