#!/bin/bash

echo "installing apple updates..."
sudo softwareupdate --install --all

# install brew
echo "installing brew..."
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install cask & update brew
echo "installing & updating cask..."
brew tap caskroom/cask
brew install caskroom/cask/brew-cask
brew update && brew upgrade brew-cask && brew-cleanup

#install cast apps
caskapps=(
appcleaner
caffeine
flux
vlc
skype
box-sync
bettertouchtool
teamviewer
grandperspective
google-chrome
joinme
microsoft-office
spotify
vlc
avast
font-source-code-pro
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


#copy wallpaper and set it
echo "copying wallpaper..."
# sudo cp /Volumes/stem_installer/new\ hire/stem\ 600x200-EFEFEF.png ~/Pictures/


#turn on filevault
echo "turning on SSD ecryption..."
sudo fdesetup enable
