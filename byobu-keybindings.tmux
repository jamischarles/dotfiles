
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

bind C-k clear-history

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
# default bindings for byobu https://gist.github.com/wincus/e9596e828fc513ded86c5
# unbind-key -n C-a5
# get 5




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
# default bindings for byobu https://gist.github.com/wincus/e9596e828fc513ded86c5
# https://unix.stackexchange.com/questions/57641/reload-of-tmux-config-not-unbinding-keys-bind-key-is-cumulative
