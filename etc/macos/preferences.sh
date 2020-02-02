#!/usr/bin/env sh

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
if [ -z ${GITHUB_ACTION} ]; then
    sudo -v
fi

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

##################################################
# General UI/UX
##################################################
defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int 1
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

##################################################
# Screen
##################################################
defaults write com.apple.screensaver idleTime -int 0

##################################################
# Dock
##################################################
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 55

##################################################
# Keyboard
##################################################

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 13

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

##################################################
# Trackpad
##################################################

# enable tap to click for this user and for the login screen
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# enable dragging
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -bool true

# three finger
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.apple.systempreefeerences trackpad.lastselectedtab -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 1

# cursor speed
defaults write NSGlobalDomain com.apple.trackpad.scaling -int 5

##################################################
# Statusbar
##################################################

# show Date MM/DD
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.clock" -bool true
defaults write com.apple.systemuiserver menuExtras -array \
    "/System/Library/CoreServices/Menu Extras/Battery.menu" \
    "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
    "/System/Library/CoreServices/Menu Extras/Displays.menu" \
    "/System/Library/CoreServices/Menu Extras/SafeEjectGPUExtra.menu" \
    "/System/Library/CoreServices/Menu Extras/Clock.menu"
defaults write com.apple.menuextra.clock DateFormat -string "M\\U6708d\\U65e5(EEE)  H:mm"

# show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

##################################################
# Finder
##################################################

# show all file extension
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# disable to create .DS_Store files
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

###############################################################################
# Energy saving
###############################################################################

# Disable hibernatemode
sudo pmset -a \
    standby              0 \
    hibernatemode        0 \
    highstandbythreshold 0 \
    standbydelaylow      86400 \
    standbydelayhigh     86400

# Disable to write sleepimage
sudo rm -f /private/var/vm/sleepimage
sudo touch /private/var/vm/sleepimage
sudo chflags -f uchg /private/var/vm/sleepimage

# Disable disksleep
sudo pmset -a \
    disksleep   0

# On battery
sudo pmset -b \
    sleep           10 \
    displaysleep    10 \
    powernap        0

# While charging
sudo pmset -c \
    sleep           0 \
    displaysleep    0 \
    powernap        1 \
    womp            1

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Google Chrome Canary" \
	"Mail" \
	"Messages" \
	"Photos" \
	"Safari" \
	"SystemUIServer" \
	"Terminal" \
	"iCal"; do
	killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."

