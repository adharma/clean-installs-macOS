#!/bin/bash

exitcode=0

# install brew
echo "installing brew..."
#deprecate /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Determine OS version
# Save current IFS state
OLDIFS=$IFS
IFS='.' read osvers_major osvers_minor osvers_dot_version <<< "$(/usr/bin/sw_vers -productVersion)"
# restore IFS to previous state
IFS=$OLDIFS
# Check to see if the Mac is reporting itself as running macOS 11
if [[ ${osvers_major} -ge 11 ]]; then
  # Check to see if the Mac needs Rosetta installed by testing the processor
  processor=$(/usr/sbin/sysctl -n machdep.cpu.brand_string | grep -o "Intel")
  if [[ -n "$processor" ]]; then
    echo "$processor processor installed. No need to install Rosetta."
  else
    # Check Rosetta LaunchDaemon. If no LaunchDaemon is found,
    # perform a non-interactive install of Rosetta.
    if [[ ! -f "/Library/Apple/System/Library/LaunchDaemons/com.apple.oahd.plist" ]]; then
        /usr/sbin/softwareupdate --install-rosetta --agree-to-license
        if [[ $? -eq 0 ]]; then
        	echo "Rosetta has been successfully installed."
          # export homebrew path for M1 machines
          export PATH=/opt/homebrew/bin:$PATH
        else
        	echo "Rosetta installation failed!"
        	exitcode=1
        fi   
    else
    	echo "Rosetta is already installed. Nothing to do."
    fi
  fi
  else
    echo "Mac is running macOS $osvers_major.$osvers_minor.$osvers_dot_version."
    echo "No need to install Rosetta on this version of macOS."
fi

# exit $exitcode

# install cask & update brew
# echo "installing & updating cask..."
# brew tap caskroom/cask
# brew install caskroom/cask/brew-cask
# brew update && brew upgrade && brew-cleanup && brew cask cleanup

#install apps
apps=(
# caffeine
# flux
# appcleaner
# adium
# box-sync
# bettertouchtool
# teamviewer
# grandperspective
google-chrome
zoom
slack
1password
viscosity
# joinme
# iterm2
# nosleep
# virtualbox
# microsoft-office
# spotify
# vlc
# avast
)

echo "installing apps..."
brew install --appdir="/Applications" ${apps[@]}

echo "cleaning up brew..."
brew cleanup

#resets all printers
# lpstat -p | grep printer | cut -d" " -f2
# lpstat -p | grep printer | cut -d" " -f2 | xargs -I{} lpadmin -x {}
# sudo launchctl unload /System/Library/LaunchDaemons/org.cups.cupsd.plist
# sudo launchctl load /System/Library/LaunchDaemons/org.cups.cupsd.plist

#turn on filevault
# echo "turning on SSD ecryption..."
# sudo fdesetup enable

echo "installing apple updates..."
sudo softwareupdate --install --all
