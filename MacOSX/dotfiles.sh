#!/bin/bash

git clone https://github.com/khaosdoctor/.dotfiles.git ~/Desktop/dotfiles

cd ~/Desktop/dotfiles/Global

mv .gitexcludes ~/
mv .vimrc ~/

cd ~/Desktop/dotfiles/MacOSX

# Ask for path
echo -n "Enter path to your .pem files (globs permitted): "
read pemfiles

echo -n "Enter your git username: "
read gituser

echo -n "Enter git email: "
read gitmail

# Replace the token with the typed text
sed -i "s/!pemfiles!/$pemfiles/g" .bash_profile
sed -i "s/!user.name!/$gituser/g" .gitconfig
sed -i "s/!user.email!/$gitmail/g" .gitconfig

mv .bash_profile ~/
mv .gemrc ~/
mv .gitconfig ~/
mv update-all /usr/local/bin/

open Snazzy.itermcolors
open Snazzy.terminal

rm -rf ~/Desktop/dotfiles

exit 0

