#!/bin/sh

# https://lukaszwrobel.pl/blog/tmux-tutorial-split-terminal-windows-easily/

# Set Session Name
SESSION="Website"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

# START_FOLDER=$1

# FIXME: currently it just uses the folder you called the script in...
# ideally you can pass it a param and it'll do it all there...

# [[ ! -z "$1" ]] && START_FOLDER=$("cd $PWD/$1") || START_FOLDER=$(z)
# echo $START_FOLDER
# echo $PWD


# TODO: make this different sessions instead of different windows...
# CONFIG session...

# Only create tmux session if it doesn't already exist
if [ "$SESSIONEXISTS" = "" ]
then
    # Start New Session with our name
    byobu new-session -d -s $SESSION
    # tmux split-window -h -t 0
    # tmux split-window -t 0

    tmux rename-window -t 0 'Work'
    tmux splitw -h -p 20 # split it into two halves
    tmux selectp -t 1 # select the new, second (1) pane
    tmux splitw -v -p 10 # split it into two halves
    tmux selectp -t 0 # go back to the first pane


    # FIXME: add some sort of "open right folder" step?
    tmux send-keys -t 'Work' 'nvim' C-m # Switch to bind script?

    # tmux split-window -h -t 0:1

    # Name first Pane and start zsh
    # tmux send-keys -t 'Work' 'zsh' C-m 'clear' C-m # Switch to bind script?

    # Create and setup pane for hugo config
    tmux new-window -t $SESSION:1 -n 'wdd230'
    tmux send-keys -t 'wdd230' 'cd ~/dev_freelance/byui-teaching-wdd230; nvim . ' C-m # Switch to bind script?

    tmux new-window -t $SESSION:2 -n 'TIL'
    tmux send-keys -t 'TIL' 'cd ~/dev_freelance/til; clear' C-m # Switch to bind script?

    # setup Writing window
    # tmux new-window -t $SESSION:2 -n 'Writing'
    # tmux send-keys -t 'Writing' "nvim" C-m

    # Setup an additional shell
    # tmux new-window -t $SESSION:3 -n 'Shell'
    # tmux send-keys -t 'Shell' "zsh" C-m 'clear' C-m
fi

# Attach Session, on the Main window
tmux attach-session -t $SESSION:0
