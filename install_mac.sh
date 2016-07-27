#!/bin/bash

# install brew
echo "installing brew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install cask & update brew
echo "installing & updating cask..."
brew tap caskroom/cask
brew install caskroom/cask/brew-cask
brew update && brew upgrade brew-cask && brew-cleanup && brew cask cleanup

#install cast apps
caskapps=(
caffeine
flux
appcleaner
adium
vlc
skype
box-sync
bettertouchtool
teamviewer
grandperspective
google-chrome
joinme
iterm2
nosleep
virtualbox
microsoft-office365
spotify
vlc
avast
)

echo "installing cask apps..."
brew cask install --appdir="/Applications" ${caskapps[@]}

echo "cleaning up brew..."
brew cleanup

#resets all printers
lpstat -p | grep printer | cut -d" " -f2
lpstat -p | grep printer | cut -d" " -f2 | xargs -I{} lpadmin -x {}
sudo launchctl unload /System/Library/LaunchDaemons/org.cups.cupsd.plist
sudo launchctl load /System/Library/LaunchDaemons/org.cups.cupsd.plist

#turn on filevault
echo "turning on SSD ecryption..."
sudo fdesetup enable

echo "installing apple updates..."
sudo softwareupdate --install --all
