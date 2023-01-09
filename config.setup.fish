#!/opt/homebrew/bin/fish

# TODO: look into unsetting all these before I run them. If I see perf issues do that!!!

# This can be run via $source config.setup.fish from fish shell, or by executing this file (see shebang ^)

# Many of the fish commands are NOT meant to be put into config.fish because they'll run every time fish inits and get slower and slower over time.
# Those are meant to be run from the command line. Because I like to preserve history, I'll add them here in this script so they can be run anytime changes are needed in a way you can restore them
# This setup makes fish MUCH faster!


# Set up PATHS -------------------------------------------


# Abbreviations --------------------------------------------


#################
### Abbreviations
#################

# https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_git_prompt.fish  ?
# this sets them privately for each session, even though the 'proper' way is to set them globally for lal sessions once from the command line
# if below is too slow, try this https://superuser.com/questions/1049368/add-abbreviations-in-fish-config

# these are adding overhead... think about ripping them out... .05s -> .06s (added 10ms)
# TODO: Look at this for placeholders
# > https://github.com/fish-shell/fish-shell/issues/2287
# > Params !!! https://github.com/fish-shell/fish-shell/issues/731
if status --is-interactive
    set -g fish_user_abbreviations
    abbr --add ef 'nvim ~/.config/fish/config.fish'
    abbr --add gpu 'nvim ~/.config/fish/config.fish'
    abbr --add gs 'nvim ~/.config/fish/config.fish'
    abbr --add itermps 'setItermProfile Pluralsight'

    # git
    abbr --add gpu 'git pull --rebase upstream'
    abbr --add grb 'git rebase -i upstream/develop'
    abbr --add gra 'git rebase --abort'
    abbr --add grc 'git rebase --continue'
    abbr --add gs  'git status -s'
    abbr --add gb  'git branch -v'
    abbr --add gd  'git diff --color | delta --diff-so-fancy | less --tabs=1,5 -R'
    abbr --add gdc 'git diff --cached --color | delta --diff-so-fancy | less --tabs=1,5 -R'
    abbr --add gdcn 'git diff --cached --color ":!package-lock.json" | delta --diff-so-fancy | less --tabs=1,5 -R'
    abbr --add gdn  'git diff --color ":!package-lock.json" | delta --diff-so-fancy | less --tabs=1,5 -R'
    abbr --add gch 'git checkout'
    abbr --add gc 'git commit -v'
    abbr --add grm 'git remote -v'
    abbr --add gca 'git commit -v --amend'
    abbr --add gsp 'git stash pop'
    abbr --add gsgd 'git stash; git stash drop'
    # stash unstaged files (including new ones)
    abbr --add gsu 'git stash -k -u; git status -s'
    # open conflicted files in nvim
    abbr --add gfc 'git diff --name-only --diff-filter=U | xargs nvim'
    abbr --add gfca 'git diff --name-only --diff-filter=U | xargs git add'

    # node
    abbr --add nv 'node --version'

    # vim
    abbr --add ns 'nvim -S' # resume session
    abbr --add nps 'nvim --cmd "let is_ps=1"' # Launch nvim with PS settings

    # system
    abbr --add ka 'kill -9 (pgrep "")' # resume session

    abbr --add kport  "sudo lsof -i tcp:8000"

    abbr --add profile "fish --profile prompt.prof -ic 'fish_prompt; exit'; sort -nk 2 prompt.prof" # Profile fish startup time. https://github.com/fish-shell/fish-shell/issues/2854

    abbr --add list "find . | fzf" # list files and pass to fzf

    abbr --add rmf "rm -rf"

    # docker
    abbr --add dp "docker ps"

    # file searching utils
    # FD is my util, like rg but for files
    # list of special utils I use: z, rg, fd, bat, fzf (not often anymore)
    # abbr --add rgf "rg --files . | grep"
    abbr --add rgf "fd "
    abbr --add rga "rg --no-ignore -iF" # Searches ALLL files, exact string . ignore all gitignore etc. And case insensitive.
    abbr --add rgfi "rg --files-with-matches"
    abbr --add fbat "fzf | xargs bat" # find and then bat the file
    abbr --add rbat "rg --files-with-matches | xargs bat" #bat files with matches


  # special rust-based commands that I like
  # z, fd, rg, bat, exa,lsd, dust(du) (trying out): broot   (not much anymore) fzf
  # zk zettelkasten https://github.com/mickael-menu/zk


    # search hidden files (not node_modules or .git but other ones), including dotfiles and files hidden by .gitignore
    abbr --add rgh "rg --follow --no-ignore-vcs  --files-with-matches --hidden -g \"!.git\" -g \"!node_modules\""
    # abbr --add rgh "rg --follow --no-ignore-vcs --ignore-file node_modules --ignore-file .gitt" #bat files with matches
    # abbr --add rghf "rg --files-with-matches " #bat files with matches


    # Estimate JS Size after minify and gzip... from clipboard. TODO: add a before/after size...
    abbr --add jssize "pbpaste | terser -c -m | gzip -c9n | wc -c | awk '{\$1=\$1/1000; print \$1,\"KB\";}'"


    # Wipe topos
    abbr --add topos "rm node_modules/topos/toposcache.json"

    # history?
    # history --merge # will merge history from other sessions
    # history | fzf # goodness. TODO: bind this to ctrl-r?
    #

    # Rust hacking
    abbr --add cr "cargo run"
end


## ENV VARIABLES ------------------------------------------


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

# Set nvim as default editor for crontab etc
set -x EDITOR "nvim"


# set the greeting
set -x fish_greeting " Forward motion is the key."



## Random config ---------------------------------


# Brew version of ctags (exuberant) instead of universal ctags (which is installed by xcode)
# brewDir=`brew --prefix`
# FIXME: Can I remove this?
set brewDir (brew --prefix)

