#!/bin/bash
#
# Symlinks the dotfiles in ~/.dotfiles into their expected locations in $HOME.
# Run from the ~/.dotfiles directory.

HERE=$(pwd)

# *.sym files -> hidden dotfiles in $HOME (can't symlink directly to a hidden
# file target, so files are named without the leading dot and a .sym suffix).
echo "Linking *.sym files into \$HOME"
for FILE in *.sym; do
    TARGET="$HOME/.$(basename "$FILE" .sym)"
    echo "  ~/.${FILE%.sym} -> $HERE/$FILE"
    rm -f "$TARGET"
    ln -s "$HERE/$FILE" "$TARGET"
done

echo "Linking neovim config"
rm -rf "$HOME/.config/nvim"
ln -s "$HERE/nvim" "$HOME/.config/nvim"

echo "Linking Rio terminal config"
mkdir -p "$HOME/.config/rio"
rm -f "$HOME/.config/rio/config.toml"
ln -s "$HERE/rio/config.toml" "$HOME/.config/rio/config.toml"

echo "Linking Claude config (CLAUDE.md, agents, commands)"
mkdir -p "$HOME/.claude"
rm -f "$HOME/.claude/CLAUDE.md"
ln -s "$HERE/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
rm -rf "$HOME/.claude/agents"
ln -s "$HERE/claude/agents" "$HOME/.claude/agents"
rm -rf "$HOME/.claude/commands"
ln -s "$HERE/claude/commands" "$HOME/.claude/commands"
echo "  NOTE: claude/mcp.json.template has machine-specific paths (e.g. Tolaria.app)."
echo "        Review and copy manually to ~/.claude/mcp.json -- not symlinked."

echo "Linking Brewfile"
mkdir -p "$HOME/.config/brewfile"
rm -f "$HOME/.config/brewfile/Brewfile"
ln -s "$HERE/Brewfile" "$HOME/.config/brewfile/Brewfile"

echo "Linking fish shell config"
mkdir -p "$HOME/.config/fish"
rm -f "$HOME/.config/fish/config.fish"
ln -s "$HERE/config.fish" "$HOME/.config/fish/config.fish"
rm -f "$HOME/.config/fish/fishfile"
ln -s "$HERE/fishfile" "$HOME/.config/fish/fishfile"

echo "Linking starship prompt config"
rm -f "$HOME/.config/starship.toml"
ln -s "$HERE/starship.toml" "$HOME/.config/starship.toml"

echo "Linking yazi file manager config"
rm -rf "$HOME/.config/yazi"
ln -s "$HERE/yazi" "$HOME/.config/yazi"

echo "Linking bun config"
rm -f "$HOME/.bunfig.toml"
ln -s "$HERE/bunfig.toml" "$HOME/.bunfig.toml"

echo "Done. Next steps:"
echo "  1. brew bundle --file=$HERE/Brewfile (review the Brewfile first -- it hasn't been pruned)"
echo "  2. Review claude/mcp.json.template and copy to ~/.claude/mcp.json if needed"
echo "  3. Install Rio, nvim, fish, yazi, starship if not already present"
