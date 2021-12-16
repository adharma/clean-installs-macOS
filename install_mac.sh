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


# ask admin if they need MS office installed
echo "do they need MS Office? non-eng will need it! enter y if they are non-eng?"
read answer
if [ $answer == "y" ]; then
	brew install microsoft-office
fi
	echo "got it, not installing MS Office, must be an #eng..."

#install other apps
apps=(
google-chrome
zoom
slack
1password
viscosity
)

echo "installing apps..."
brew install --appdir="/Applications" ${apps[@]}

echo "cleaning up brew..."
brew cleanup

# turn on filevault - not necessary with MDM that enforce it
# echo "turning on SSD ecryption..."
# sudo fdesetup enable

# remove default macOS apps that typically need updates. iMovie, Keynote, Pages, Numbers.
sudo rm -rf /Applications/Pages.app /Applications/Keynote.app /Applications/GarageBand.app /Applications/iMovie.app /Applications/Numbers.app

# install all macOS updates.
echo "installing macOS updates..."
sudo softwareupdate --install --all


# https://cloud.malwarebytes.com/download?t=nvIk4Zc_E6Cgh8LWpypV13i0Tkk7nKl-tzj9w4CaxmUb53U-PIGt7vXEbZYPO4AJCK0FmwiNZPLGE3tQ6AEcgcNAeECO_LrpLYzEJtlqrdrR&via=copy&source=Downloads%20Page
# https://chrome.google.com/webstore/detail/1password-extension-deskt/aomjjhallfgjeglblehebfpbcfeobpgk?hl=en-US
