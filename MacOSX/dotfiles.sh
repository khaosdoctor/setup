#!/bin/bash

TITLE_START="\033]0;"
TITLE_END="\007"

echo -ne "${TITLE_START}Downloading DotFiles${TITLE_END}"

git clone https://github.com/khaosdoctor/.dotfiles.git ~/Desktop/dotfiles

mv ~/Desktop/dotfiles/Global/.gitexcludes ~/
mv ~/Desktop/dotfiles/Global/.vimrc ~/
mv ~/Desktop/dotfiles/Global/update-all /usr/local/bin/

# Ask for path
echo -n "Enter path to your .pem files (globs permitted): "
read pemfiles

echo -n "Enter your git username: "
read gituser

echo -n "Enter git email: "
read gitmail

# Replace the token with the typed text
sed -i "s/!pemfiles!/$pemfiles/g" ~/Desktop/dotfiles/MacOSX/.bash_profile
sed -i "s/!user.name!/$gituser/g" ~/Desktop/dotfiles/MacOSX/.gitconfig
sed -i "s/!user.email!/$gitmail/g" ~/Desktop/dotfiles/MacOSX/.gitconfig

mv .bash_profile ~/
mv .gemrc ~/
mv .gitconfig ~/

open Snazzy.itermcolors
open Snazzy.terminal

rm -rf ~/Desktop/dotfiles

exit 0

