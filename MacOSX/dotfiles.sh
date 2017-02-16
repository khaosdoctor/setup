#!/bin/bash

cd ~/Desktop
git clone https://github.com/khaosdoctor/.dotfiles.git dotfiles

cd ~/Desktop/dotfiles/Global

mv .gitexcludes ~/
mv .vimrc ~/

cd ~/Desktop/dotfiles/MacOSX

# Ask for path
echo -n "Enter path to your .pem files (globs permitted): "
read pemfiles

# Replace the token with the typed text
sed -i "s/!pemfiles!/$pemfiles/g" .bash_profile

mv .bash_profile ~/
mv .gemrc ~/
mv .gitconfig ~/

open Snazzy.itermcolors
open Snazzy.terminal

cd ~/Desktop
rm -rf dotfiles

exit 0

