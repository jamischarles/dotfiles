#!/bin/bash

#TODO: Clean this up and remove a bunch of them...
#TODO: consider grouping vim or nvim folders in a folder named nvim?
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
# needed because we can't link to a hidden file
echo 'Converting *.sym files to hidden files in ~/ folder'
for FILE in *.sym; do
    echo 'Deleting and creating symlink: ' $(echo "$HOME/.$FILE" | sed 's/.sym$//');
    rm  $(echo "$HOME/.$FILE" | sed 's/.sym$//');
    ln -s "$HERE/$FILE" $(echo "$HOME/.$FILE" | sed 's/.sym$//');
done;
#for FILE in *.sym;  done;

# symlink my zsh theme (TODO: DELETE?)
# FILE="jamis-doubleend.zsh-theme"
# FILE_PATH="$HOME/.oh-my-zsh/themes/$FILE"
# echo "Deleting and creating $FILE_PATH symlink"
# rm "$FILE_PATH"
# ln -s "$HERE/$FILE" "$FILE_PATH"

# NEOVIM new setup. ~/.config/nvim -> ~/.dotfiles/nvim  
echo "NEOVIM setup"
ln -s "$HERE/nvim" "$HOME/.config/nvim"


# ln -s "$HERE/$FILE" "$FILE_PATH"

# make nvim seamlessly work with vim configs
# ~/.config/nvim -> ~/.vim
# ~/.config/nvim/init.vim -> ~/.vimrc

# FOR FISH SHELL ***************
# symlink homebrew nvm version for fish shell to ~/.nvm

# FISH config and FISHERMAN installed plugins, since these aren't dotfiles, I'm listing them manually here.
echo "Linking FISH SHELL CONFIG FILES (config.fish and fishfile (for fisherman))"
rm "$HOME/.config/fish/config.fish"
ln -s "$HERE/config.fish" "$HOME/.config/fish/config.fish"
rm "$HOME/.config/fish/fishfile"
ln -s "$HERE/fishfile" "$HOME/.config/fish/fishfile"
# END FOR FISH SHELL ************


# symlink ~/config/nvim to ~/.vim Used for Vim and Neovim.
# TODO: Just make the jump already? likely never going back to vim
echo "Delete ~/.vim and .vimrc"
rm -rf "$HOME/.vim"
rm ~/.vimrc

# echo "Linkin real main.shada to fake ~/.viminfo since nvim uses main.shada instead"
# ln -s "$HOME/.local/share/nvim/shada/main.shada" "$HOME/.viminfo"



# NOTE: if it's a HIDDEN file, then name it *.sym without . prefix. This is important but I can't rememeber why
# Probably because you can't symlink to hidden files, only from

# symlink ~/.config/ files
rm ~/.config/powerline
ln -s ~/.dotfiles/powerline.sym ~/.config/powerline # do these need to be quoted?

# symlink ~/.config/karabiner.edn
rm ~/.config/karabiner.edn
ln -s ~/.dotfiles/karabiner.edn ~/.config/karabiner.edn

rm ~/.config/alacritty.yml
ln -s ~/.dotfiles/alacritty.yml ~/.config/alacritty.yml

# tmux flavor for window management. #gotta name folders .sym to avoid symlinking weirdness
# TODO must do this when byobu is NOT running
rm ~/.byobu/.tmux.conf
rm ~/.byobu/color.tmux
rm ~/.byobu/keybindings.tmux
ln -s ~/.dotfiles/byobu-tmux.conf ~/.byobu/.tmux.conf
ln -s ~/.dotfiles/byobu-color.tmux ~/.byobu/color.tmux
ln -s ~/.dotfiles/byobu-keybindings.tmux ~/.byobu/keybindings.tmux

rm ~/.config/starship.toml
ln -s ~/.dotfiles/starship.toml ~/.config/starship.toml
