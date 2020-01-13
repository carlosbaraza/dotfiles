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

# Install GO
brew install go
brew install svn

# Install iterm2
brew install tmux
brew cask install iterm2
cp ~/dotfiles/iterm/profiles.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/profiles.json

brew cask install visual-studio-code
brew cask install google-chrome
brew cask install firefox
brew cask install slack
brew cask install evernote
brew cask install istat-menus
brew cask install spotify
brew cask install flux
brew cask install cakebrew
brew cask install charles # Proxy debugging HTTP
brew cask install clipy
brew cask install spectacle
brew cask install the-unarchiver
brew cask install skitch
brew cask install skype
brew cask install vlc
brew cask install sourcetree
brew cask install robo-3t
brew cask install diffmerge
brew cask install whatsapp
brew cask install docker
brew cask install geekbench
brew cask install google-cloud-sdk
brew cask install intel-power-gadget
brew cask install google-backup-and-sync
brew cask install steveschow-gfxcardstatus

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
brew cask install java
brew cask install android-studio

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
