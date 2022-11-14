#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./script.sh arg-one arg-two

This is an awesome bash script to make your life better.

'
    exit
fi

cd "$(dirname "$0")"

main() {
    # ZSH
    ###############################################################################
    # Install oh-my-zsh
    #sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    # Install theme for shell
    mkdir -p ~/.oh-my-zsh/custom/themes/
    curl -L -o ~/.oh-my-zsh/custom/themes/bullet-train.zsh-theme http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme
    rm -f ~/.zshrc; ln -s ~/dotfiles/.zshrc ~/.zshrc

    # Add history if you want to keep the command history
    # rm -f ~/.zsh_history; ln -s ~/dotfiles/.zsh_history ~/.zsh_history

    # Install powerline compatible fonts
    git clone https://github.com/powerline/fonts ~/powerline-fonts
    ~/powerline-fonts/install.sh
    rm -rf ~/powerline-fonts


    # GIT
    ################################################################################
    rm -f ~/.gitconfig; ln -s ~/dotfiles/git/gitconfig ~/.gitconfig
    rm -f ~/.gitignore; ln -s ~/dotfiles/git/gitignore ~/.gitignore


    # Homebrew
    ################################################################################
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    brew install node
    brew install nvm
    brew install terraform
    brew install watchman

    # Python
    brew install pyenv

    # Install GO
    brew install go
    brew install svn

    # Install iterm2
    brew install tmux
    brew install --cask iterm2
    brew install --cask warp

    brew install --cask visual-studio-code
    #brew install --cask google-chrome
    brew install --cask firefox
    brew install --cask slack
    brew install --cask istat-menus
    brew install --cask spotify
    brew install --cask cakebrew
    brew install --cask clipy
    brew install --cask rectangle
    brew install --cask the-unarchiver
    brew install --cask vlc
    brew install --cask diffmerge
    brew install --cask whatsapp
    brew install --cask docker
    brew install --cask geekbench
    brew install --cask google-cloud-sdk
    brew install --cask google-drive

    # https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/
    brew install dust
    brew install fd
    brew install duf
    brew install exa
    brew install ripgrep
    brew install bat
    brew install git-delta
    brew install dog
    brew install glances
    brew install sd
    brew install pdfgrep
    brew install broot
    brew install choose-rust
    brew install ctop
    brew install rga
    brew install fzf
    brew install ldns # DNS (drill)

    brew install wget
    brew install cmake

    # Install macvim
    brew install macvim
    ln -s /usr/local/opt/macvim/MacVim.app/Contents/MacOS/Vim /usr/local/bin/vim
    ln -s /usr/local/opt/macvim/MacVim.app/Contents/MacOS/Vim /usr/local/bin/vi
    brew install neovim

    # Install vimrc (Cool vim configuration)
    # https://github.com/amix/vimrc
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh

    # Install ag search command
    brew install the_silver_searcher

    # Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

main "$@"

