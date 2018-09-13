# ZSH
###############################################################################
# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install theme for shell
mkdir -p $ZSH/custom/themes/
curl -L -o $ZSH/custom/themes/bullet-train.zsh-theme http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme
rm ~/.zshrc; ln -s ~/dotfiles/.zshrc ~/.zshrc

# Add history if you want to keep the command history
# rm ~/.zsh_history; ln -s ~/dotfiles/.zsh_history ~/.zsh_history

# Install powerline compatible fonts
git clone https://github.com/powerline/fonts ~/powerline-fonts
~/powerline-fonts/install.sh
rm -rf ~/powerline-fonts

# TODO: Add iterm2 profile config
cp ~/dotfiles/iterm/blue.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/blue.json


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

# Install GO
brew install go
echo "export PATH=$PATH:/usr/local/opt/go/libexec/bin" >> ~/.zshrc
brew install svn

# Install iterm2
brew install tmux
brew cask install iterm2
cp ./iterm/blue.json "/Users/carlosbaraza/Library/Application Support/iTerm2/DynamicProfiles"

brew cask install atom
brew cask install google-chrome
brew cask install firefox
brew cask install chitchat # whatsapp web wrapper
brew cask install slack
brew cask install evernote
brew cask install istat-menus
brew cask install spotify
brew cask install dockertoolbox
brew cask install flux
brew cask install cakebrew
brew cask install charles # Proxy debugging HTTP
brew cask install clipmenu
brew cask install spectacle
brew cask install the-unarchiver
brew cask install skitch
brew cask install skype
brew cask install vlc
brew cask install sourcetree
brew cask install robomongo
brew cask install diffmerge

# Meteor Installation
curl https://install.meteor.com/ | sh

brew install wget
brew install cmake

# Atom
apm install docblockr
apm install goto-definition
apm install highlight-selected
apm install linter
apm install linter-eslint
npm install -g eslint eslint-plugin-meteor
apm install toggle-quotes

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
