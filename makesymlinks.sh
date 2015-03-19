#!/bin/bash

#TODO: Consider suffixing these files with -symlink so we know which to fetch specifically. And so it doesn't include the shell script...

# this script links all the dotfiles (.*) in the ~/.dotfiles folder and symlinks them to ~/
# This assumes that you've moved all your important dotfiles from ~/.* to ~/.dotfiles.

# Run this script from your dotfiles directory.

# current folder
HERE=$(pwd)

# Create symlinks

# from http://unix.stackexchange.com/questions/64459/create-symbolic-links-to-files-using-wildcards
# symlink from nondot file in this folder to a dotfile in the home folder...
 #echo 'Creating symlinks from ~/ to ~/.dotfiles/*.sym files';

# get all *.sym files in the current folder and symlink them to the home folder MINUS the .sym extension
for FILE in *.sym; do
    echo 'Deleting and creating symlink: ' $(echo "$HOME/.$FILE" | sed 's/.sym$//');
    rm  $(echo "$HOME/.$FILE" | sed 's/.sym$//');
    ln -s "$HERE/$FILE" $(echo "$HOME/.$FILE" | sed 's/.sym$//');
done;
#for FILE in *.sym;  done;

# symlink my zsh theme
FILE="jamis-doubleend.zsh-theme"
FILE_PATH="$HOME/.oh-my-zsh/themes/$FILE"
echo "Deleting and creating $FILE_PATH symlink"
rm "$FILE_PATH"
ln -s "$HERE/$FILE" "$FILE_PATH"


# symlink .vim/plugin to ~/.dotfiles/plugin
FOLDER='plugin'
echo "Deleting and creating ~/.vim/$FOLDER symlink"
rm -rf "$HOME/.vim/$FOLDER"
ln -s "$HERE/$FOLDER" "$HOME/.vim/$FOLDER"


# symlink .vim/after to ~/.dotfiles/after
FOLDER='after'
echo "Deleting and creating ~/.vim/$FOLDER symlink"
rm -rf "$HOME/.vim/$FOLDER"
ln -s "$HERE/$FOLDER" "$HOME/.vim/$FOLDER"
