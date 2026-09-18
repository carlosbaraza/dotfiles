# Sets reasonable macOS defaults.

# Show hidden files.
defaults write com.apple.finder AppleShowAllFiles -bool true

# Disable press-and-hold for keys in favor of key repeat.
defaults write -g ApplePressAndHoldEnabled -bool false

# Use AirDrop over every interface.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Always open everything in Finder's list view.
defaults write com.apple.finder FXPreferredViewStyle Nlsv

# Show the ~/Library folder.
chflags nohidden ~/Library

# Set a really fast key repeat.
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# Set the Finder prefs for showing a few different volumes on the Desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Run the screensaver if we're in the bottom-left hot corner.
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

# Speed up Dock animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Disable control+up mission control
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 '<dict><key>enabled</key><false/></dict>'
# Disable control+down app expose (33; 35 is its shift variant)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 33 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 35 '<dict><key>enabled</key><false/></dict>'

# Disable navigation with two fingers in Chrome
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

# Apply changes
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
killall Finder Dock cfprefsd 2>/dev/null || true
