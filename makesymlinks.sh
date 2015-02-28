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
 echo 'Creating symlinks from ~/ to ~/.dotfiles/*.sym files';

# get all *.sym files in the current folder and symlink them to the home folder MINUS the .sym extension
for FILE in *.sym; do ln -s "$HERE/$FILE" $(echo "$HOME/.$FILE" | sed 's/.sym$//'); done;




