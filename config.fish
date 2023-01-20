# DEPS we need to isntall for fish shell to work as we have it set up...
# - gdate via  '$brew install coreutils'        (for gdate)
# - nvm (or alternative with fish. see lower section on NVM)

# READ
# https://developerlife.com/2021/01/19/fish-scripting-manual/#:~:text=A%20fish%20function%20is%20just,variables%20in%20fish%20are%20lists).

## most config is here
## TODO: Run once on new init
# ~/.dotfiles/config.setup.fish

# FIXME: use this for abbr?

# TODO: perf profiling?
# https://superuser.com/questions/1049368/add-abbreviations-in-fish-config

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

# https://developerlife.com/2021/01/19/fish-scripting-manual/#variable-scopes-local-global-global-export
## FUNCTIONS
function diffjson
  # set local vars 
	set -l FILE_A $argv[1]
	set -l FILE_B $argv[2]
  delta --diff-so-fancy (jq --sort-keys . $FILE_A | psub ) (jq --sort-keys . $FILE_B | psub )
end

#################################
# Amazing tools I use (install via brew)
# original tool -> replacement I use now
# cat -> bat
# find -> fd
# grep -> rg
# NVM -> Volta
# z -> zoxide
# grep -> ripgrep
# zsh(terminal prompt config) -> starship
# Fzf
# lsd (super powered ls)
# coreutils (for gdate)
# @fsouza/prettierd (via volta/npm) (prettier FAST daemon)
# eslint_d (via volta/npm) (eslint FAST daemon)
##################################


#######################################
# PATHS - should be set here
#######################################
# https://fishshell.com/docs/current/tutorial.html?highlight=path#path

# -x exports it... https://fishshell.com/docs/current/tutorial.html?highlight=path#exports-shell-variables


# Homebrew path
set -x PATH $PATH /opt/homebrew/bin

# Ctags - exuberant... Because there's already one installed for universal ctags
set -x PATH $PATH /usr/local/Cellar/ctags/5.8_1/bin/ctags

# Needs to be done first for gDate... to be available below...
set -x PATH $PATH /usr/local/opt/coreutils/libexec/gnubin
# Add all the utils that are normally in the path. Need to set this up now, so all the other commands work...
set -x PATH $PATH /usr/local/bin/
# Needed for providers to call python3 properly in nevim in anacritty only... https://neovim.io/doc/user/provider.html
set -x PATH $PATH /usr/bin/python3
# Needed for some cargo build commands includes py2 in the path. means python2 execute can be called?
set -x PATH $PATH /Users/jacharles/.pyenv/versions/pypy2.7-7.3.9/bin

# PYTHON env var
set -x PYTHON /usr/bin/python3

set -x BYOBU_PREFIX /usr/local


# For gdate...
set -x PATH $PATH /usr/local/opt/coreutils/libexec/gnubin

# manually set the path for golang and rust
set -x PATH $PATH $HOME/go $HOME/go/bin $HOME/.cargo/bin

# path for genymotion android simulator
set -x PATH $PATH /Applications/Genymotion.app/Contents/MacOS/tools/

# For rbenv (ruby version manager)
set -x PATH $PATH ~/.rbenv/shims
set -x PATH $PATH ~/.rbenv/bin

# theme for BAT... useful for vim preview etc...
set -x BAT_THEME 'Monokai Extended'

# Fixes local issuer cert issues
set -x NODE_EXTRA_CA_CERTS '/usr/local/etc/openssl/certs/paypal_proxy_cacerts.pem'

# Gets nanoseconds for current timestamp. Could also use this for ms timestamp. (gdate '+%s.%3N')
function getTime
  echo (gdate '+%s%N') #https://github.com/fish-shell/fish-shell/issues/117
end

# Timing metrics for how long this setup takes...
set -g START_TIME (getTime)

# Homebrew default brewfile location
set -x HOMEBREW_BUNDLE_FILE '~/.config/brewfile/Brewfile'


#################################################
## ALIASES -----------------------------------------------
#################################################


alias ctags="$brewDir/bin/ctags"

alias ls="lsd"
alias la="lsd -a --long --date=relative --blocks permission,size,date,name"
alias lsl="lsd --long --date=relative --blocks permission,size,date,name"
alias lsa="lsd --long --all --date=relative --blocks permission,size,date,name"

alias PYTHON="/usr/bin/python3"


# ###############################################
# NOTE: removing all the custom functions in lieu of starship.rs
# ###############################################

# This fn seems to be the last thing that runs (makes sense), so good place to profile.
# FIXME: Move this to fns or into /functions?

# Git status adds ~500ms to startup so skip on startup.
# function fish_prompt
# 	if test $CMD_DURATION
# 	  # Show duration of the last command in seconds
# 	  set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.1fs", $1 / $2}')
# 	  # echo $duration
# 	end
#
#
# 	echo "" # newline before
# 	set_color cyan
# 	echo -n "⚡ Mjølner " # -n means no new-line after echo
# 	set_color yellow
# 	echo -n (getPWDFromHome) # consider using prompt_pwd
# 	# echo -n $PWD | sed -e "s|^$HOME|~|" -e 's|^/private||'
# 	set_color normal
#
# 	# log startup or priopr command duration
# 	if test ! $FISH_STARTUP_DONE
# 	  echo " "(getTimeSinceStart) # more accurate to have it after GIT. FIXME: Put this in function
# 	  set -g FISH_STARTUP_DONE true # Never enter this block again
# 	else
# 	  echo " "$duration
# 	end
#
# 	echo "→ "
#
# end
#
# function fish_right_prompt
#   if test $FISH_STARTUP_DONE
#     printf '%s ' (__fish_git_prompt) # adds 600ms, so delay loading this to 2nd prompt. FIXME: Makes others slow too...
#   end
# end



###########################
# CUSTOM FUNCTIONS
###########################
# Installed functions (TODO: Try a manager?)
# https://github.com/brigand/fast-nvm-fish

# /Users/jacharles/dev -> ~/dev  dirs showed the whole dir stack...
# function getPWDFromHome
#   echo $PWD | string replace $HOME '~'
# end
#
# # http://adrian-philipp.com/post/cmd-duration-fish-shell
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
# function setItermProfile
# 	# TODO: Look at what happens when you use shift-left Arrow in zsh / fish
# 	# https://www.iterm2.com/documentation-escape-codes.html
# 	# zsh -c 'set_iterm_profile Pluralsight'  # \x ?!?
# 	zsh; zsh -c 'echo -e "\033]50;SetProfile=$1\a" '  # \x ?!?
# 	# echo -e "\033]50;SetProfile=$1\a"
# end


#####################################################
# END of section replaced by starship.rs
#####################################################


#################
### Config
#################
# nvm use 8 # relies on https://github.com/brigand/fast-nvm-fish


# Use fnm instead of NVM (faster for fish) https://github.com/Schniz/fnm
# Set up fnm
# fnm env --multi | source
# nvm use v10 # Running this at prompt adds 200 - 500ms. Can we delay this? Or manually do it?

# This kind of breaks nvm... Consider another way to do it...? Maybe do it on 2nd prompt? Or wait for a special command?
# alias node="/Users/jacharles/.nvm/versions/node/v8.4.0/bin/node" # usually use abbr instead, but here it's justified
# alias npm="node /Users/jacharles/.nvm/versions/node/v8.4.0/lib/node_modules/npm/bin/npm-cli.js"
# TODO: maybe hack the fast-nvm plugin so that we can use this fast method, and have that replaced by nvm later...

# -a for --all including hidden
# alias lsl="lsd --long --total-size --date=relative --blocks permission,size,date,name"


# Fix local cert issues with npm
# Didn't work...
# https://github.paypal.com/gist/jeswitzer/67ae2a04a1c871878fa6ff6d6d135818
# set -g NODE_EXTRA_CA_CERTS ~/certs/paypal-proxy-chain.pem
# set -g NODE_EXTRA_CA_CERTS ~/certs/paypal-cloud.pem




#######################
# Brew things installed
#######################
# TODO: Use brewfile to manage / restore brew deps 

# brew install coreutils (gdate) https://apple.stackexchange.com/questions/135742/time-in-milliseconds-since-epoch-in-the-terminal

######################
# PLUGINS
######################
# Package manager
# https://github.com/jorgebucaran/fisher
# - fisher add z


######
# PATH
######
#FIXME: Is the problem here that we haven't set the path in zsh...? So we have to add everythign manually?


# for z didntwor k
# sh /usr/local/etc/profile.d/z.sh

# set -x PATH $GOPATH $HOME/go $HOME/.cargo/bin

# set up starship prompt
# starship init fish | source

# Iterm2 shell integration
# https://iterm2.com/documentation-shell-integration.html
# source ~/.iterm2_shell_integration.fish


######################################################
## ONLY PARTS THAT MATTER NOW (after starship.rs)
######################################################
# see ~/.dotfiles/config.setup.fish for ocasional config changes

# running all these commands every time changes startup time from .03s to .16s (4x slowdown)
# source ~/.dotfiles/config.setup.fish


# Z command. HACKY workaround for the "abbr to reomve doesn't exist.
abbr --add z 'ls'
abbr --add zi 'ls'
zoxide init fish | source

# adds 0.03s (30ms?) (from 0.00s)
# special terminal parts
starship init fish | source

# echo "Startup time: "(getTimeSinceStart) # more accurate to have it after GIT. FIXME: Put this in function





# Use fnm instead of NVM (faster for fish) https://github.com/Schniz/fnm
# Set up fnm
# fnm env --multi | source


# historic time
# 0.03s - 12/09

# List of things I have brew installed...
# - https://github.com/yqrashawn/GokuRakuJoudo - easy karabiner config
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
