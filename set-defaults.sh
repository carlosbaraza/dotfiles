# Sets reasonable OS X defaults.

# Show hidden files.
defaults write com.apple.Finder AppleShowAllFiles YES

# Disable press-and-hold for keys in favor of key repeat.
defaults write -g ApplePressAndHoldEnabled -bool false

# Use AirDrop over every interface. srsly this should be a default.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# Always open everything in Finder's list view. This is important.
defaults write com.apple.Finder FXPreferredViewStyle Nlsv
sudo find / -name '.DS_Store' -exec rm {} \;

# Show the ~/Library folder.
chflags nohidden ~/Library

# Set a really fast key repeat.
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 0
defaults write NSGlobalDomain KeyRepeat -int 0

# Set the Finder prefs for showing a few different volumes on the Desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Run the screensaver if we're in the bottom-left hot corner.
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

# Hide Safari's bookmark bar.
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Set up Safari for development.
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Speed up Dock animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Disable control+up mission control
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 '<dict><key>enabled</key><false/></dict>'
# Disable control+down app expose
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 35 '<dict><key>enabled</key><false/></dict>'

# Disable navigation with two fingers in Chrome
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE
