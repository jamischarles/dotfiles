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

# make .vim folder if it doesn't exist...
mkdir ~/.vim

# make nvim seamlessly work with vim configs
# ~/.config/nvim -> ~/.vim
# ~/.config/nvim/init.vim -> ~/.vimrc


# symlink ~/config/nvim to ~/.vim Used for Vim and Neovim.
echo "Linking fake nvim folder to real .vim folder"
#rm -rf "$HOME/.vim/$FOLDER"
ln -s "$HOME/.vim" "$HOME/.config/nvim"  

echo "Linkin .vimrc for nvim instead of nvim config file"
ln -s "$HOME/.vimrc" "$HOME/.config/nvim/init.vim"


# symlink .vim/plugin to ~/.dotfiles/plugin. Used for Vim and Neovim.
FOLDER='plugin'
echo "Deleting and creating ~/.vim/$FOLDER symlink"
rm -rf "$HOME/.vim/$FOLDER"
ln -s "$HERE/$FOLDER" "$HOME/.vim/$FOLDER"


# symlink .vim/after to ~/.dotfiles/after. Used for Vim and Neovim.
FOLDER='after'
echo "Deleting and creating ~/.vim/$FOLDER symlink"
rm -rf "$HOME/.vim/$FOLDER"
ln -s "$HERE/$FOLDER" "$HOME/.vim/$FOLDER"


# symlink ~/.config/ files (powerline mainly for now)
rm ~/.config/powerline
ln -s ~/.dotfiles/powerline.sym ~/.config/powerline # do these need to be quoted?
