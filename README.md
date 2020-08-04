# dotfiles
TODO:
- [X] Replace Janus with Vundle
- [x] After Vundle is there, remove the silly install script and explicitly do it...
- [X] rip out ZSH and store only the one file I've modified
- [ ] Screenshot of my prompt and vim
- [ ] Make a note about colemak
- [ ] Abbreviations, git sugar, colemak etc

Currently using neovim on the terminal

Any serious plugin modifications (like a whole file's worth, should go in /plugin, which is linked to ~/.vim/plugin)



## Update:
Now uses fish instead of zsh. Update this every time I change laptops.

### How to set up Vim:
0. Run makemysymlinks.sh
1. `brew install neovim`
2. Setup plugin system by copying `plug.vim` to `~/.vim/autoload` folder https://github.com/junegunn/vim-plug#installation
3. Start neovim. Run `PlugInstall` to install all the plugins.

--------------

This readme is very out of date...

If you want to override plugins, like for keyboard collisions, place a file in after/plugin. That will be loaded AFTER the plugins.

My understanding is that .vimrc is loaded FIRST, and plugins are loaded sometime after (seems strange to me...

To see the startup time and LOAD order for things, run this:
```
$ mvim -v --startuptime /dev/stdout/ +qall
```

For ZSH, copy `jamis-doubleend.zsh.theme` to `~/.oh-my-zsh/themes`.
