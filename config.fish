# TODO:
# add folds here? Using modeline? Use ## for 1, and # for 2
# only show timing data when command is slower than 5 seconds...
# consider starting to use tmux again

# fix switching iterm prompts in fish. !!!
# - remap alt ne to up down sequences in iterm
# - Add git status back... - https://stackoverflow.com/questions/866989/fish-interactive-shell-full-path
# 	- duration and status right side?
# 	- or pick one of the premade ones that look nice...
# 	- consider removing git from first prompt to make the prompt faster? Is it slower every time?
# - Add symlinks for config file, so it's in dotfiles... (add bashrc too)
	# - ctags file
# - install z for zsh too? It's friggin amazing...
# - pick one of these? https://github.com/jbucaran/awesome-fish
# - get the terminal switch to work...
# 	- try my method above
# 	- ask on SO, try the escape route...
# - install fasd or similar? so I can just type the folder name?
# - use informative prompt? Or shop around?
# http://mariuszs.github.io/blog/2013/informative_git_prompt.html
# - git prompt? https://www.martinklepsch.org/posts/git-prompt-for-fish-shell.html
# - vim mode? https://fedragon.github.io/vimode-fishshell-osx/

# Gets nanoseconds for current timestamp. Could also use this for ms timestamp. (gdate '+%s.%3N')
function getTime
  echo (gdate '+%s%N') #https://github.com/fish-shell/fish-shell/issues/117
end

# Timing metrics for how long this setup takes...
set -g START_TIME (getTime)




# This fn seems to be the last thing that runs (makes sense), so good place to profile.
# FIXME: Move this to fns or into /functions?

# Git status adds ~500ms to startup so skip on startup.
function fish_prompt
	if test $CMD_DURATION
	  # Show duration of the last command in seconds
	  set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.1fs", $1 / $2}')
	  # echo $duration
	end


	echo "" # newline before
	set_color cyan
	echo -n "⚡ Mjølner " # -n means no new-line after echo
	set_color yellow
	echo -n (getPWDFromHome) # consider using prompt_pwd
	# echo -n $PWD | sed -e "s|^$HOME|~|" -e 's|^/private||'
	set_color normal

	# log startup or priopr command duration
	if test ! $FISH_STARTUP_DONE
	  echo " "(getTimeSinceStart) # more accurate to have it after GIT. FIXME: Put this in function
	  set -g FISH_STARTUP_DONE true # Never enter this block again
	else
	  echo " "$duration
	end

	echo "→ "

end

function fish_right_prompt
  if test $FISH_STARTUP_DONE
    printf '%s ' (__fish_git_prompt) # adds 600ms, so delay loading this to 2nd prompt. FIXME: Makes others slow too...
  end
end


#################
### Config
#################
# nvm use 8 # relies on https://github.com/brigand/fast-nvm-fish
nvm use v8 # Running this at prompt adds 200 - 500ms. Can we delay this? Or manually do it?

# This kind of breaks nvm... Consider another way to do it...? Maybe do it on 2nd prompt? Or wait for a special command?
# alias node="/Users/jacharles/.nvm/versions/node/v8.4.0/bin/node" # usually use abbr instead, but here it's justified
# alias npm="node /Users/jacharles/.nvm/versions/node/v8.4.0/lib/node_modules/npm/bin/npm-cli.js"
# TODO: maybe hack the fast-nvm plugin so that we can use this fast method, and have that replaced by nvm later...

# Themes: https://github.com/jbucaran/awesome-fish
# Theme, color, prompt GIT info
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_hide_untrackedfiles 1

set -g __fish_git_prompt_color_branch magenta
set -g __fish_git_prompt_showupstream "informative"
set -g __fish_git_prompt_char_upstream_ahead "↑"
set -g __fish_git_prompt_char_upstream_behind "↓"
set -g __fish_git_prompt_char_upstream_prefix ""

set -g __fish_git_prompt_char_stagedstate "●"
set -g __fish_git_prompt_char_dirtystate "✚"
set -g __fish_git_prompt_char_untrackedfiles "…"
set -g __fish_git_prompt_char_conflictedstate "✖"
set -g __fish_git_prompt_char_cleanstate "✔"

set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green

#################
### Abbreviations
#################

# https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_git_prompt.fish  ?
# this sets them privately for each session, even though the 'proper' way is to set them globally for lal sessions once from the command line
# if below is too slow, try this https://superuser.com/questions/1049368/add-abbreviations-in-fish-config

# these are adding overhead... think about ripping them out... .05s -> .06s (added 10ms)
# TODO: Look at this for placeholders
if status --is-interactive
    set -g fish_user_abbreviations
    abbr --add ef 'nvim ~/.config/fish/config.fish'
    abbr --add gpu 'nvim ~/.config/fish/config.fish'
    abbr --add gs 'nvim ~/.config/fish/config.fish'
    abbr --add itermps 'setItermProfile Pluralsight'

    # git
    abbr --add gpu 'git pull --rebase upstream'
    abbr --add grb 'git rebase -i upstream/develop'
    abbr --add gs  'git status -s'
    abbr --add gb  'git branch -v'
    abbr --add gd  'git diff --color | diff-so-fancy | less --tabs=1,5 -R'
    abbr --add gdc 'git diff --cached --color | diff-so-fancy | less --tabs=1,5 -R'
    abbr --add gch 'git checkout'
    abbr --add gc 'git commit -v'
    abbr --add grm 'git remote -v'
    abbr --add gca 'git commit -v --amend'

    # node
    abbr --add nv 'node --version'

    # vim
    abbr --add ns 'nvim -S' # resume session
    abbr --add nps 'nvim --cmd "let is_ps=1"' # Launch nvim with PS settings

    # system
    abbr --add ka 'kill -9 (pgrep "")' # resume session

    abbr --add profile "fish --profile prompt.prof -ic 'fish_prompt; exit'; sort -nk 2 prompt.prof" # Profile fish startup time. https://github.com/fish-shell/fish-shell/issues/2854

    abbr --add list "find . | fzf" # list files and pass to fzf

    abbr --add rmf "rm -rf"

    # docker
    abbr --add dp "docker ps"

    # history?
    # history --merge # will merge history from other sessions
    # history | fzf # goodness. TODO: bind this to ctrl-r?
    #
end


#######################
# Brew things installed
#######################
# brew install coreutils (gdate) https://apple.stackexchange.com/questions/135742/time-in-milliseconds-since-epoch-in-the-terminal

######################
# PLUGINS
######################
# https://github.com/fisherman/fisherman
# fisher ls|rm
# FIXME: I manually put in and edited the nvm one... just use a gist?!?
# fast-nvm-fish - use my fork of it anyway
# z (folder jumping) - https://github.com/fisherman/z

######
# PATH
######
# manually set the path for golang and rust
set -x PATH $PATH $HOME/go $HOME/.cargo/bin

# set -x PATH $GOPATH $HOME/go $HOME/.cargo/bin
###########################
# CUSTOM FUNCTIONS
###########################
# Installed functions (TODO: Try a manager?)
# https://github.com/brigand/fast-nvm-fish

# /Users/jacharles/dev -> ~/dev  dirs showed the whole dir stack...
function getPWDFromHome
  echo $PWD | string replace $HOME '~'
end

# http://adrian-philipp.com/post/cmd-duration-fish-shell
function getTimeSinceStart
	# fish version (faster?)
	# gdate +%s.%3N   down to ms (3 digits)
	set END_TIME (gdate '+%s%N')
	set DURATION (math "$END_TIME - $START_TIME")

	set pretty_duration (echo "$DURATION 1000000000" | awk '{printf "%.2fs", $1 / $2}') #get nano seconds down to 0.1s format
	echo $pretty_duration # 0.09s
end

# FIXME: Doesn't work...
# this instead? https://iterm2.com/documentation-shell-integration.html
# https://github.com/fish-shell/fish-shell/issues/767 ?
# Kind  of cheating, but we'll use the zsh function I have, since I can't figure out how to do this here...
# TODO: Pass an env flag to either iterm or zsh that will trigger the profile switch...
# TODO
function setItermProfile
	# TODO: Look at what happens when you use shift-left Arrow in zsh / fish
	# https://www.iterm2.com/documentation-escape-codes.html
	# zsh -c 'set_iterm_profile Pluralsight'  # \x ?!?
	zsh; zsh -c 'echo -e "\033]50;SetProfile=$1\a" '  # \x ?!?
	# echo -e "\033]50;SetProfile=$1\a"
end


