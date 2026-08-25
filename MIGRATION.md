# Work laptop migration

Dotfiles setup: see `README.md` (clone `~/.dotfiles`, run `./makesymlinks.sh`).
This doc covers everything else -- non-dotfiles folders to bring over.

## rsync exclude list

Use this exclude list for every rsync below. Save it once and reuse:

```
# ~/.dotfiles/migration-rsync-excludes.txt
node_modules/
.git/
build/
dist/
.next/
target/
DerivedData/
*.xcarchive
*.xcframework
*.ipa
*.pck
venv/
.venv/
__pycache__/
```

Example invocation:

```
rsync -avh --progress --exclude-from=~/.dotfiles/migration-rsync-excludes.txt \
  ~/dev_xo/ newmachine:~/dev_xo/
```

`.git/` is excluded deliberately -- these are real repos with a remote; re-clone
instead of rsyncing history, then rsync back only uncommitted/stashed work if needed
(check `git status` on each repo first).

## Folders to bring

| Path | Size (untrimmed) | Notes |
|---|---|---|
| `~/dev_freelance` | ~large, 100+ node_modules dirs | Mostly git repos -- re-clone from remote where possible, rsync only repos with local-only history/uncommitted work |
| `~/dev_games` | 4.4G | Mostly Xcode/Godot build outputs (`.ipa`, `.xcarchive`, `.xcframework`) -- **drop these, rebuild fresh**. Bring only source (`.xcodeproj`, actual project files) |
| `~/dev_side_projects` | 237M | Small, no node_modules found -- straightforward rsync with exclude list |
| `~/dev_xo` | large, 2562 node_modules dirs across 55+ repos | Work repos. Re-clone from remote where possible; rsync with exclude list for anything with local state |
| `~/dev_xo_ai_experiments` | 3.9G | 15 node_modules dirs -- rsync with exclude list |
| `~/TestBuilds` | 6.5G | Stale build outputs only (paypal build artifacts) -- **drop, do not bring**. Rebuild if needed |
| `~/Dos Games` | 80M | Small, straightforward rsync |
| `~/Desktop` | 61G | Rsync with exclude list, lands as "old desktop" on new machine (not merged into new Desktop) |

## Before rsyncing dev_xo / dev_freelance

These contain many separate git repos, several with `_old`/`_broken`/`_backup`/`.back`
suffixes suggesting abandoned copies. Before bulk rsyncing:

1. For each repo with a remote, prefer `git clone` fresh on the new machine over rsync.
2. Check `git status` for uncommitted changes or stashes in each repo -- only those
   need rsyncing (or `git stash` + push to a branch first).
3. Consider just skipping the `_old`/`_broken`/`_backup`/`.back`-suffixed folders
   entirely rather than migrating dead weight forward again.

## Mobile-specific rule

Only bring mobile project build artifacts/state over if doing so is clearly faster
than a fresh clone + build on the new machine. Default: **don't bring build outputs**
(`.xcarchive`, `.xcframework`, `.ipa`, `DerivedData`) -- source + fresh build is the
normal path. `TestBuilds` and `dev_games`'s built artifacts fall under this rule.

## Not yet decided

- Brewfile (`~/.dotfiles/Brewfile`, 107 entries) has not been pruned -- review before
  running `brew bundle` on the new machine.
