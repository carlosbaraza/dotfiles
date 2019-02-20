# Path to your oh-my-zsh installation.
export ZSH="/home/carlosbaraza/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

export EDITOR='vim'

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Go configuration
export PATH=$PATH:"/usr/lib/go-1.11/bin" # Go binary path
export GO111MODULE=on # Enable modules
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin