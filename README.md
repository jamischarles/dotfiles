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


This readme is very out of date...

If you want to override plugins, like for keyboard collisions, place a file in after/plugin. That will be loaded AFTER the plugins.

My understanding is that .vimrc is loaded FIRST, and plugins are loaded sometime after (seems strange to me...

To see the startup time and LOAD order for things, run this:
```
$ mvim -v --startuptime /dev/stdout/ +qall
```

For ZSH, copy `jamis-doubleend.zsh.theme` to `~/.oh-my-zsh/themes`.
