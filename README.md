# dotfiles

Minimal, current setup: fish, neovim, Rio, yazi, starship, and Claude Code global config.

Legacy setup (zsh/oh-my-zsh, vim, wezterm/alacritty, byobu/tmux, karabiner, powerline,
broot, ctags) is preserved on the `legacy-setup-pre-2026` branch / `legacy-pre-2026` tag,
not maintained here.

## Clean install on a new machine

1. Clone this repo to `~/.dotfiles`.
2. Run `./makesymlinks.sh` from inside `~/.dotfiles`.
3. Install Homebrew if needed, then `brew bundle --file=~/.dotfiles/Brewfile`.
   (The Brewfile hasn't been pruned in this pass -- skim it before installing everything.)
4. Review `claude/mcp.json.template` -- it has machine-specific paths (e.g. the Tolaria
   app path) and is not symlinked automatically. Copy to `~/.claude/mcp.json` once verified.
5. Install Rio, neovim, fish, yazi, starship if not already present.
6. Open neovim and let lazy.nvim install plugins.
7. Restart the terminal / fish shell.

## Layout

- `config.fish`, `config.setup.fish`, `fishfile` -- fish shell config
- `nvim/` -- neovim config (lazy.nvim)
- `rio/config.toml` -- Rio terminal config
- `starship.toml` -- prompt
- `yazi/` -- file manager config
- `claude/` -- global Claude Code config (`CLAUDE.md`, `agents/`, `commands/`, MCP template)
- `Brewfile` -- package list (unaudited)
- `gitconfig.sym`, `gitignore_global.sym` -- git config
- `zshrc.sym` -- bare survival config in case zsh ever launches directly (fish is primary)
- `.private-env-vars-gitignored.fish` -- local secrets, not checked in
