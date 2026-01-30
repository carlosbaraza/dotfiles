#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./setup.sh

Sets up dotfiles and common tools on Ubuntu/Debian.
'
    exit
fi

cd "$(dirname "$0")"

main() {
    # Update package list
    sudo apt update

    # Install essentials
    sudo apt install -y \
        git \
        curl \
        wget \
        zsh \
        tmux \
        build-essential \
        unzip

    # ZSH
    ################################################################################
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

    # Set zsh as default shell
    chsh -s $(which zsh)

    # Symlink dotfiles
    ################################################################################
    mkdir -p ~/.config
    rm -f ~/.zshrc; ln -s ~/dotfiles/debian/.zshrc ~/.zshrc
    rm -f ~/.tmux.conf; ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
    rm -f ~/.gitconfig; ln -s ~/dotfiles/git/gitconfig ~/.gitconfig
    rm -rf ~/.config/atuin; ln -s ~/dotfiles/atuin ~/.config/atuin

    # Modern CLI tools (via cargo or direct download)
    ################################################################################

    # Install Rust
    if [ ! -f "$HOME/.cargo/env" ]; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi
    # Source cargo env for this session
    [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

    # Install tools via cargo (only if not already installed)
    [ ! -f "$HOME/.cargo/bin/fd" ] && cargo install fd-find       # find replacement
    [ ! -f "$HOME/.cargo/bin/rg" ] && cargo install ripgrep       # grep replacement
    [ ! -f "$HOME/.cargo/bin/bat" ] && cargo install bat          # cat replacement
    [ ! -f "$HOME/.cargo/bin/eza" ] && cargo install eza          # ls replacement
    [ ! -f "$HOME/.cargo/bin/dust" ] && cargo install du-dust     # du replacement
    [ ! -f "$HOME/.cargo/bin/sd" ] && cargo install sd            # sed replacement
    [ ! -f "$HOME/.cargo/bin/zoxide" ] && cargo install zoxide    # smarter cd

    # Install fzf
    if [ ! -d ~/.fzf ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
    fi

    # Install fnm (Fast Node Manager)
    if [ ! -d "$HOME/.local/share/fnm" ]; then
        curl -fsSL https://fnm.vercel.app/install | bash
    fi

    # Install atuin (better shell history)
    if [ ! -d "$HOME/.atuin" ]; then
        curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
    fi

    # Neovim (from GitHub releases - apt version is very outdated)
    ################################################################################
    if [ ! -f /usr/local/bin/nvim ]; then
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        sudo rm -rf /opt/nvim-linux-x86_64
        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
        sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
        rm nvim-linux-x86_64.tar.gz
    fi

    # Set nvim as the default editor system-wide
    sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/nvim 60

    # Neovim config symlink
    rm -rf ~/.config/nvim; ln -s ~/dotfiles/nvim ~/.config/nvim

    echo "Done! Log out and back in, or run: zsh"
}

main "$@"
