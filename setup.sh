#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./setup.sh

Sets up dotfiles symlinks and installs common tools.
'
    exit
fi

cd "$(dirname "$0")"

main() {
    # Homebrew
    ################################################################################
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # ZSH
    ################################################################################
    # Install oh-my-zsh
    if [ ! -d ~/.oh-my-zsh ]; then
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Install zsh plugins
    ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi

    # Symlink dotfiles
    rm -f ~/.zshrc; ln -s ~/dotfiles/.zshrc ~/.zshrc
    rm -f ~/.zprofile; ln -s ~/dotfiles/zprofile ~/.zprofile
    rm -f ~/.tmux.conf; ln -s ~/dotfiles/tmux.conf ~/.tmux.conf

    # GIT
    ################################################################################
    rm -f ~/.gitconfig; ln -s ~/dotfiles/git/gitconfig ~/.gitconfig

    # CLI Tools
    ################################################################################
    brew install fnm           # Fast Node Manager (replaces nvm)
    brew install pyenv         # Python version manager
    brew install go
    brew install tmux
    brew install wget
    brew install cmake

    # Modern CLI tools
    brew install dust          # du replacement
    brew install fd            # find replacement
    brew install duf           # df replacement
    brew install eza           # ls replacement (exa is unmaintained)
    brew install ripgrep       # grep replacement
    brew install bat           # cat replacement
    brew install git-delta     # git diff pager
    brew install sd            # sed replacement
    brew install pdfgrep       # grep for PDFs
    brew install fzf           # fuzzy finder
    brew install zoxide        # smarter cd
    brew install atuin         # better shell history
    brew install the_silver_searcher  # ag search

    # Vim
    brew install neovim
    if [ ! -d ~/.vim_runtime ]; then
        git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
        sh ~/.vim_runtime/install_awesome_vimrc.sh
    fi

    # Rust
    if ! command -v rustc &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi

    # Apps (casks)
    ################################################################################
    brew install --cask warp
    brew install --cask visual-studio-code
    brew install --cask google-chrome
    brew install --cask chromium --no-quarantine
    brew install --cask firefox
    brew install --cask slack
    brew install --cask istat-menus
    brew install --cask spotify
    brew install --cask alfred
    brew install --cask rectangle
    brew install --cask the-unarchiver
    brew install --cask vlc
    brew install --cask whatsapp
    brew install --cask docker
    brew install --cask google-cloud-sdk
    brew install --cask google-drive

    echo "Done! Restart your terminal or run: source ~/.zshrc"
}

main "$@"
