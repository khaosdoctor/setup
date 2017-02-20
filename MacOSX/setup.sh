#!/bin/bash

TITLE_START="\033]0;"
TITLE_END="\007"

#Color pallete
RED='\033[0;031m'
CYAN='\033[0;036m'
YELLOW='\033[1;33m'
NC='\033[0m'

function change_title {
  echo -ne "${TITLE_START}$1${TITLE_END}"
}

echo -e "${CYAN}=> Beginning installation process${NC}"
echo -e "${YELLOW}--THIS MAY REQUIRE YOUR PASSWORD--${NC}"

change_title "Setting your computer up"
echo -e "${CYAN}=> Installing brew${NC}"

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/homebrew-php
brew tap homebrew/completions
brew tap caskroom/fonts
brew tap homebrew/bundle

echo -e "${CYAN}=> Installing brew apps${NC}"
brew install $(grep . brew.ini | xargs)

echo -e "${CYAN}=> Running services${NC}"
brew services start mysql
brew services start postgres
brew services start mongodb

echo -e "${CYAN}=> Installing brew cask apps${NC}"
brew cask install $(grep . cask.ini | xargs)

brew upgrade

echo -e "${CYAN}=> Installing AppStore apps${NC}"
echo -n "Enter your AppleID (0 to skip): "
read appleId

if [ $appleId != 0 ]; then
  mas signin $appleId
  mas install 415181149
  mas install 1127253508
  mas install 967004861
  mas install 1103992594
  mas install 1078016835
  mas install 921458519
  mas install 937984704
  mas install 715768417
  mas install 803453959
  mas install 497799835
  mas upgrade
  sudo xcode-select --install
fi

echo -ne "${TITLE_START}Downloading DotFiles${TITLE_END}"

git clone https://github.com/khaosdoctor/.dotfiles.git ~/Desktop/dotfiles

echo -e "${RED}=> Moving files${NC}"
echo -e "${RED}=> Moving excludes${NC}"
mv ~/Desktop/dotfiles/Global/.gitexcludes ~/
echo -e "${RED}=> Moving vimrc${NC}"
mv ~/Desktop/dotfiles/Global/.vimrc ~/
echo -e "${RED}=> Moving update-all${NC}"
mv ~/Desktop/dotfiles/Global/update-all /usr/local/bin/
echo -e "${RED}=> Moving services${NC}"
mv *.workflow ~/Library/Services/

# Ask for path
echo -n "Enter path to your .pem files (globs permitted): "
read pemfiles

# Replace the token with the typed text
sed -i "s/pemfiles/$pemfiles/g" ~/Desktop/dotfiles/MacOSX/.bash_profile

echo -e "${RED}=> Moving .bash_profile${NC}"
mv ~/Desktop/dotfiles/MacOSX/.bash_profile ~/
echo -e "${RED}=> Moving .gemrc${NC}"
mv ~/Desktop/dotfiles/MacOSX/.gemrc ~/
echo -e "${RED}=> Moving .gitconfig${NC}"
mv ~/Desktop/dotfiles/MacOSX/.gitconfig ~/

echo -e "${CYAN}=> Configuring Git${NC}"

echo -n "Enter your git username: "
read gituser

echo -n "Enter git email: "
read gitmail

git config —-global user.name "${gituser}"
git config —-global user.email "${gitmail}"
git config --global apply.whitespace nowarn
git config --global core.excludesfile "~/.gitexcludes"

echo -e "${CYAN}=> Installing terminal profiles${NC}"
open ~/Desktop/dotfiles/MacOSX/Snazzy.itermcolors
open ~/Desktop/dotfiles/MacOSX/Snazzy.terminal

rm -rf ~/Desktop/dotfiles

echo -e "${CYAN}=> Installing Ruby Gems${NC}"
gem update
sudo gem update --system

gem install $(grep . gems.ini | xargs)

echo -e "${CYAN}=> Configuring Yarn${NC}"

yarn config set prefix /usr/local
yarn global add $(grep . yarn.ini | xargs)

echo -e "${CYAN}=> Installing composer packages${NC}"
composer global require "laravel/installer"


