# ZSH
###############################################################################
# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install theme for shell
mkdir -p ~/.oh-my-zsh/custom/themes/
curl -L -o ~/.oh-my-zsh/custom/themes/bullet-train.zsh-theme http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme
rm ~/.zshrc; ln -s ~/dotfiles/.zshrc ~/.zshrc

# Add history if you want to keep the command history
# rm ~/.zsh_history; ln -s ~/dotfiles/.zsh_history ~/.zsh_history

# Install powerline compatible fonts
git clone https://github.com/powerline/fonts ~/powerline-fonts
~/powerline-fonts/install.sh
rm -rf ~/powerline-fonts


# GIT
################################################################################
rm ~/.gitconfig; ln -s ~/dotfiles/git/gitconfig ~/.gitconfig
rm ~/.gitignore; ln -s ~/dotfiles/git/gitignore ~/.gitignore


# Homebrew
################################################################################
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install caskroom/cask/brew-cask

brew install node
brew install nvm
brew install mongo
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
cp ~/dotfiles/iterm/profiles.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/profiles.json

brew install --cask visual-studio-code
brew install --cask google-chrome
brew install --cask firefox
brew install --cask slack
brew install --cask evernote
brew install --cask istat-menus
brew install --cask spotify
brew install --cask flux
brew install --cask cakebrew
brew install --cask charles # Proxy debugging HTTP
brew install --cask clipy
brew install --cask rectangle
brew install --cask the-unarchiver
brew install --cask skitch
brew install --cask skype
brew install --cask vlc
brew install --cask sourcetree
brew install --cask robo-3t
brew install --cask diffmerge
brew install --cask whatsapp
brew install --cask docker
brew install --cask geekbench
brew install --cask google-cloud-sdk
brew install --cask intel-power-gadget
brew install --cask google-backup-and-sync
brew install --cask steveschow-gfxcardstatus

# Meteor Installation
curl https://install.meteor.com/ | sh

brew install wget
brew install cmake

# Install macvim
brew install macvim
brew linkapps macvim
ln -s /usr/local/opt/macvim/MacVim.app/Contents/MacOS/Vim /usr/local/bin/vim
ln -s /usr/local/opt/macvim/MacVim.app/Contents/MacOS/Vim /usr/local/bin/vi

# Install vimrc (Cool vim configuration)
# https://github.com/amix/vimrc
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

# Install vim plugins
cd ~/.vim_runtime/sources_non_forked/

# HTML5 for vim syntastic
brew install tidy-html5

# Install ag search command
brew install the_silver_searcher

# Android
brew install --cask java
brew install --cask android-studio

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
