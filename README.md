# dotfiles

TODO:

- change the whole folder structure to work with nvim... (it's not going
  x Move all my vimscript files over to lua (SO much better).
- Replace my complex symlinking with 1 symlink  
  `~/.config/nvim` ->.dotfiles/nvim
  anywhere for a long time)
- [ ] Screenshot of my prompt and vim
- [ ] Make a note about colemak
- [ ] Abbreviations, git sugar, colemak etc

Currently using neovim on the terminal
 

Todo (pressing):
- figure out how to be able to packer-install in one pass instead of many passes?
 - (write a quick node module that scans all the lua files, extracts the lua requires, (builds a require tree), then installs all those in one pass)
try one of these? https://www.google.com/search?q=lua+build+dependency+tree&ie=UTF-8&oe=UTF-8&hl=en-us&client=safari&safe=active

Read this? (esp for the brew stuff?)
https://cpojer.net/posts/set-up-a-new-mac-fast 

## Clean install steps needed
1. clone / restore ~/.dotfile
2. run makesymlinks.sh
3. install homebrew
4. brew install all the things found in the fish config file
5. have some shared location for iterm2 settings (restore those)
6. Install neovim via brew
7. Install packer manually
- brew install yarn (volta can't handle yarn in our PP locked down env)
brew install sqlite (needed for some nvim modules I use?
- brew install alacritty
- brew install lua-language-server
8. start and install packer modules that are missing until no more errors
9. npm i -g the lsp servers I need (lame. TODO: autmoate this better)
`npm install -g typescript typescript-language-server`

Any serious plugin modifications (like a whole file's worth, should go in /plugin, which is linked to ~/.vim/plugin)

## Update:

Now uses fish instead of zsh. Update this every time I change laptops.

### How to set up Vim:

0. Run makemysymlinks.sh
1. `brew install neovim`
2. Setup plugin system by copying `plug.vim` to `~/.vim/autoload` folder https://github.com/junegunn/vim-plug#installation
3. Start neovim. Run `PlugInstall` to install all the plugins.

---

This readme is very out of date...

If you want to override plugins, like for keyboard collisions, place a file in after/plugin. That will be loaded AFTER the plugins.

My understanding is that .vimrc is loaded FIRST, and plugins are loaded sometime after (seems strange to me...

To see the startup time and LOAD order for things, run this:

```
$ mvim -v --startuptime /dev/stdout/ +qall
```

For ZSH, copy `jamis-doubleend.zsh.theme` to `~/.oh-my-zsh/themes`.
