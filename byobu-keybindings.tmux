
# bind a send-prefix
# set -g prefix ^A
# unbind-key -n C-a
# unbind-key -n C-a
unbind-key -n C-a
# set -g prefix ^A
set -g prefix2 F12
# bind a send-prefix
set -g prefix C-space
bind-key C-space send-prefix

# split-window -h
# F5 reloads config
 # These are normal tmux commands
# bindings (taken from .tmux.conf
# TODO: enable syntax highlighting
# PERFECT. c-a is the prefix key currently... then these do the rest...
# Q: How can we map a direct key to the command? Like the fn keys?

## Window splits

bind | split-window -h
bind % split-window

bind n new-window

# bing Ctrl+k without prefix key...
bind-key -n C-k clear-history

bind-key -n C-h resize-pane -L
bind-key -n C-i resize-pane -R

# resize up/down... This conflicts with vim, though I almost never use pg up/down  in vim...
bind-key -n C-n resize-pane -D
bind-key -n C-e resize-pane -U



# no idea why this is needed... Somehow Ctrl+i is the same at tab in all terminals, and remapping ctrl+i interferes with tab...
unbind-key -n tab

#############################3
## Troubleshoot key bindings!!!
#############################3
# Ctrl ?
# :list-keys


# These didn't work here, so I put them in karabiner instead...
# F3, F4
# bind-key -n M-h select-pane -t :.-
# bind-key -n M-i select-pane -t :.+

# bind N rename-window
# FIXME: Q why is this ALWAYS firing? is it because of karabiner? disable for now...
# I bet capital letter means something else...
# bind N command-prompt -p "(rename-window) " "rename-window '%%'"
# This is how you bind a standalone key...?
# bind-key -n F8 command-prompt -p "(rename-window) " "rename-window '%%'"
# TODO
# - map working with sessions
# - how can I pull up the command window? ctr-a+:
# - Figure out how to save the session setup so I can jump straight into that...
# - - a WORK panes setup
# - - a config session with karabiner,
# remove all bindings
# https://unix.stackexchange.com/questions/57641/reload-of-tmux-config-not-unbinding-keys-bind-key-is-cumulative
# have to be careful with this ^ because it removed ALL bindings and didn't return them...
## Helpful docs
# default bindings for byobu https://gist.github.com/wincus/e9596e828fc513ded86c
# unbind-key -n C-a
# get




# bind S new-window
# bind S new-window copy-mode

# bind N rename-window
# FIXME: Q why is this ALWAYS firing? is it because of karabiner? disable for now...
# I bet capital letter means something else...
# bind N command-prompt -p "(rename-window) " "rename-window '%%'"
# This is how you bind a standalone key...?
# bind-key -n F8 command-prompt -p "(rename-window) " "rename-window '%%'"

# TODO
# - map working with sessions
# - how can I pull up the command window? ctr-a+:
# - Figure out how to save the session setup so I can jump straight into that...
# - - a WORK panes setup
# - - a config session with karabiner,
# make window mappings really easy and fast... some really nice mapping
# maybe make a long layer with caps lock? and the ne home row keys...?
# remove all bindings
# https://unix.stackexchange.com/questions/57641/reload-of-tmux-config-not-unbinding-keys-bind-key-is-cumulative
# have to be careful with this ^ because it removed ALL bindings and didn't return them...
## Helpful docs
# -s overview of windows 5


# TODO
# - make a help page of all my stuff I like...

# Reading
# https://lukaszwrobel.pl/blog/tmux-tutorial-split-terminal-windows-easily/5
# default bindings for byobu https://gist.github.com/wincus/e9596e828fc513ded86c
# https://unix.stackexchange.com/questions/57641/reload-of-tmux-config-not-unbinding-keys-bind-key-is-cumulative
