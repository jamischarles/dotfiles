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

### Clone-now list (recently active, last commit 2025-06 or later)

Everything else across `dev_xo` / `dev_freelance` gets JIT-cloned later, on demand,
rather than front-loaded. Clone these 24 now:

```
dev_xo/modularcheckoutnodeweb          2026-08-05
dev_xo/xobuyerbrandedapiserv           2026-06-25
dev_xo/checkoutorchserv                2026-06-25
dev_xo/identityappsnodeserv            2026-05-19
dev_xo/_brain                          2026-04-03
dev_xo/pagerduty-configurations        2026-03-24
dev_freelance/asciinema2mp4            2025-08-15
dev_xo/billingmanagementserv           2025-07-31
dev_xo/jupyter-notebook-queries        2025-07-24
dev_freelance/asciinema-player         2025-07-22
dev_xo/checkout-mcp                    2025-07-17
dev_xo/jupyter-local-fpti-db-bq-emulator 2025-07-10
dev_xo/jupyter-local-fpti-db           2025-07-10
dev_xo/duckdb-to-bigquery-exploration  2025-07-10
dev_xo/bigquery-local-api-exp          2025-07-10
dev_xo/jupyter-notebook-jetpack-rust   2025-07-09
dev_xo/jupyter-notebook-jetpack        2025-07-09
dev_xo/jupyter-fpti-sample-dataset     2025-07-09
dev_xo/neil-appswitch-research         2025-06-14
dev_xo/jupyter-appswitch-research      2025-06-14
dev_xo/appswitch-investigations        2025-06-13
dev_xo/event-viewer                    2025-06-11
dev_xo/cal-ectoken-ai-crawler          2025-06-11
dev_xo/cal-ectoken-api-scripts         2025-06-10
```

Everything with a last commit before 2025-06 is skipped up front. Clone individually
from its remote the first time you actually need it -- full archive list below so
nothing is forgotten.

### Archive: older git repos (last commit before 2025-06, JIT-clone if needed)

```
2025-05-09  dev_freelance/tauri-differ
2025-04-30  dev_xo/PayPalSwiftUI
2025-04-28  dev_xo/reveal.js
2025-03-03  dev_xo/xorouternodeweb
2025-02-03  dev_xo/checkoutuinodeweb
2025-01-10  dev_xo/react-components
2024-11-06  dev_freelance/zed
2024-10-30  dev_xo/checkoutorchserv_old
2024-10-17  dev_freelance/til
2024-09-13  dev_xo/atomic-events-monorepo
2024-08-08  dev_xo/atomic-server-logger
2024-08-05  dev_xo/clientsdknodeweb
2024-07-23  dev_xo/UnifiedLoginNodeWeb
2024-07-23  dev_xo/iwc
2024-07-18  dev_xo/ngRL-AjaxChallengeInterceptor
2024-06-03  dev_freelance/learning_rust
2024-04-16  dev_xo/capeuinodeweb
2024-04-13  dev_xo/capeuinodeweb_broken
2024-02-07  dev_freelance/libgit2
2024-01-31  dev_xo/ppclientinteractions
2024-01-26  dev_xo/remoteconfig
2024-01-11  dev_freelance/tauri
2023-12-28  dev_xo/nextjs-dashboard
2023-10-31  dev_xo/loggernodeweb
2023-10-25  dev_xo/beaver-logger-paypal
2023-08-31  dev_xo/opentelemetry
2023-07-12  dev_freelance/snappy
2023-06-01  dev_xo/checkoutuinodeweb_old
2023-05-10  dev_xo/shush
2023-04-04  dev_xo/loggernodeweb-old
2023-03-08  dev_xo/beaver-logger
2023-03-04  dev_xo/supercal
2023-02-28  dev_freelance/til-personal
2023-02-27  dev_freelance/sveltekit-markdown-starter
2023-02-22  dev_freelance/codemirror-server-render
2023-01-28  dev_xo/exp-cal-api-log-analyzer
2023-01-27  dev_xo/exp-megatron-frontend
2023-01-18  dev_xo/xobuyernodeserv
2022-11-30  dev_xo/WeasleyAutoForm
2022-11-07  dev_freelance/github-commit-browser
2022-10-03  dev_freelance/til-personal.back
2022-09-28  dev_xo/cal-log-reducer
2022-09-07  dev_xo/xo-mezzo
2022-01-04  dev_xo/event-explorer
2018-06-12  dev_freelance/github-org-browser
(no commits) dev_freelance/github-org-browser-old
(no commits) dev_xo/sauron-poc-cal-iframes
```

### Archive: non-git folders (dev_xo / dev_freelance)

No `.git` found at the top level -- either a nested repo one level deeper, a
downloaded/cloned tool checkout, or scratch content. Not ranked by recency; treat
each as JIT-recover-if-needed rather than bulk migrate. Check for a `.git` one level
down before assuming there's nothing to reclone.

```
dev_xo/_data_science
dev_xo/appswitch
dev_xo/appswitch_patterns
dev_xo/appswitch-data-science
dev_xo/atomic-events-refs
dev_xo/atomic-events2
dev_xo/checkoutuinodeweb_backup
dev_xo/hermesnodeweb
dev_xo/ios
dev_xo/load_testing
dev_xo/local_jupyter
dev_xo/looker-sdk-example
dev_xo/looker-sdk-examples
dev_xo/looker-sdk-experiments
dev_xo/mcp_servers
dev_xo/metrics
dev_xo/oslo_work
dev_xo/preact-starter
dev_xo/sdk_work
dev_xo/signalfx-docker-agent
dev_xo/vibe-tools
dev_xo/xo-eng-blog
dev_xo/xo-eng-blog2
dev_freelance/_by_usecase
dev_freelance/_road-to-100MRR
dev_freelance/_sites
dev_freelance/3-day-cycles
dev_freelance/ai_experiments
dev_freelance/amplify_demo
dev_freelance/amplify-js-app
dev_freelance/animation_playground
dev_freelance/beastie
dev_freelance/blog
dev_freelance/blog-11ty
dev_freelance/blog-nuxt
dev_freelance/blog-sapper
dev_freelance/byui-teaching-wdd230
dev_freelance/carrd_clone
dev_freelance/carrd_clone_data_fetcher
dev_freelance/code-it
dev_freelance/codemirror-ssr.backup
dev_freelance/codemirror-svelte
dev_freelance/content-site-no-idea
dev_freelance/ctags-patterns-for-javascript
dev_freelance/differ
dev_freelance/dm_client
dev_freelance/exp-focus-proxy
dev_freelance/interviews
dev_freelance/js60-site
dev_freelance/kentcdodds.com
dev_freelance/lite-xl
dev_freelance/medium-to-gatsby
dev_freelance/moo_moo_app
dev_freelance/my-app
dev_freelance/my-app2
dev_freelance/neovide
dev_freelance/netflix_takehome
dev_freelance/nvim-lua-plugin-template.nvim
dev_freelance/omm_blog
dev_freelance/pl_redux
dev_freelance/plylst
dev_freelance/prism_wrapper_exp
dev_freelance/replicache
dev_freelance/replicache-todo
dev_freelance/rocket-landing-company
dev_freelance/rocket-scraper
dev_freelance/rocket-www
dev_freelance/rocket-www-next
dev_freelance/rust-demo-app2
dev_freelance/rustlings
dev_freelance/simple_next_app
dev_freelance/stripe
dev_freelance/swift_projects
dev_freelance/tauri-apps
dev_freelance/test-monorepo
dev_freelance/test-monorepo-lerna
dev_freelance/testing-rust-app
dev_freelance/testing-rust-app2
dev_freelance/turborepo
dev_freelance/umami
dev_freelance/vibe_coding
dev_freelance/walmart_takehome
dev_freelance/webpack_demos
```

## Mobile-specific rule

Only bring mobile project build artifacts/state over if doing so is clearly faster
than a fresh clone + build on the new machine. Default: **don't bring build outputs**
(`.xcarchive`, `.xcframework`, `.ipa`, `DerivedData`) -- source + fresh build is the
normal path. `TestBuilds` and `dev_games`'s built artifacts fall under this rule.

## Git setup (public GitHub first, then EMU / work)

Public GitHub access has to come first on a new machine -- `~/.dotfiles` itself
lives at `github.com/jamischarles/dotfiles`, so it's a hard dependency of even
cloning the dotfiles repo. EMU/work access can follow once the base environment
is up.

`gitconfig.sym` (symlinked to `~/.gitconfig` by `makesymlinks.sh`) covers identity and
git behavior, but **not** SSH keys or the SSH-level host routing -- those live in
`~/.ssh/`, which isn't part of the dotfiles repo (private key material should never be
committed) and needs manual setup on the new machine.

### SSH keys needed

- **`github_rsa`** -- personal/public `github.com` key. Set up first; needed to clone
  the dotfiles repo itself.
- **`paypal_github`** -- the EMU/work key, used via the `github.com-paypal` SSH alias
  (see below). Set up second, once the base environment is running.
- `id_rsa` exists as a generic fallback (`Host *` default `IdentityFile` in
  `~/.ssh/config`) -- not tied to a specific GitHub account, low priority.

### SSH config (`~/.ssh/config`)

Confirmed live config (verified 2026-08-25, not speculative):

```
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa

Host github.com-paypal
  HostName github.com
  IdentityFile ~/.ssh/paypal_github
  User git

host github.com
  HostName github.com
  IdentityFile ~/.ssh/github_rsa
  User git
```

Note: EMU/work access uses the `github.com-paypal` **alias** with `github.com` as the
actual hostname -- it is NOT a distinct `github.paypal.com` hostname. Anything cloned
from `github.paypal.com` (e.g. via browser copy-paste of an HTTPS URL) relies on
`gitconfig.sym`'s `url "git@github.paypal.com:".insteadOf` rewrite to redirect through
SSH -- that rewrite targets a different literal host than the `github.com-paypal` SSH
alias above, so double-check which one a given work repo's remote actually uses. If in
doubt, `git remote -v` on an old-machine clone of the same repo to see which form it
resolved to.

### What's in gitconfig.sym

- `user.email` is `jacharles@paypal.com` (work identity, used for everything by default
  -- there's no per-directory `includeIf` split between work/personal repos currently)
- `url "git@github.paypal.com:".insteadOf = https://github.paypal.com/` -- rewrites any
  `https://github.paypal.com/...` clone/fetch URL to SSH via `git@github.paypal.com`
  (a literal host, distinct from the `github.com-paypal` alias above)
- `http.postBuffer` / `http.maxRequestBuffer` bumped up -- needed for large repo pushes
  (e.g. `dev_xo` monorepos), not strictly required but avoids "RPC failed" errors on push

### Setup steps on new machine

1. **Public GitHub first**: generate a new SSH key (or securely transfer `github_rsa` +
   `github_rsa.pub`) for personal `github.com` access. Add the `host github.com` block
   to `~/.ssh/config`. Add the public key to your personal GitHub account. Test with
   `git clone git@github.com:jamischarles/dotfiles.git`.
2. Optionally `gh auth login` (or transfer existing `gh` auth) for GitHub CLI access,
   separate from raw SSH.
3. **EMU/work second**: generate a new SSH key (or securely transfer `paypal_github` +
   `paypal_github.pub`) for EMU/work GitHub access.
4. Add the `Host github.com-paypal` block to `~/.ssh/config` (see above).
5. Add the public key to the EMU GitHub account/org settings.
6. Confirm `~/.gitconfig` (symlinked from `gitconfig.sym`) still has the
   `url.insteadOf` rewrite for `github.paypal.com` -- keep both mechanisms since some
   work repos may use either remote form.
7. Test with a clone of a known-small work repo before relying on it for real work.

## Version manager (mise)

`pyenv`/`rbenv`/`ruby-build`/`volta` were dropped from the Brewfile and shell config in
favor of `mise` (polyglot version manager, replaces all three). `config.fish` already
activates it (`mise activate fish`), but mise does **not** honor `.nvmrc`/`.node-version`/
`.tool-versions` files by default -- this is the single most important post-install step:

```
mise settings add idiomatic_version_file_enable_tools node,python,ruby
```

Run this once after `brew bundle` installs `mise` on the new machine, before relying on
per-project version files to work.

## Claude Code install

Install Claude Code via the native installer, not `npm install -g`:

```
curl -fsSL https://claude.ai/install.sh | bash
```

This decouples Claude Code's own Node runtime from whatever mise/node version is active
in the shell, so switching project Node versions can't break the `claude` CLI itself.

## Brewfile audit (complete)

Full package-by-package review done 2026-08-25. Trimmed from 219 to 129 lines.
Removed: pyenv/rbenv/ruby-build/volta (superseded by mise), broot (superseded by
yazi), alacritty/wezterm/hyper (superseded by Rio), all `vscode "..."` extension
lines (superseded by zed/nvim), yarn (superseded by bun), nnn, unison, scooter,
choose-rust, sd, gnu-sed, harlequin/dbeaver-community/clickhouse (cask), bruno,
kiro, glance-chamburr, keycastr, lookaway, sleek-app, timelapze, awscli,
bigquery-emulator, k6, guile, jrsonnet, r, and several dead taps
(`domq/gdb`, `homebrew/aliases`, `ms-jpq/sad`, `ctrlspice/otel-desktop-viewer`,
`equinix-labs/otel-cli`, `nextdns/tap`, `fsouza/prettierd`).

Also removed the now-unused `/clickhouse` Claude command (depended on the
`clickhouse` CLI client, dropped in the same pass).

Also removed (2026-08-25, follow-up): the media/codec library cluster (`aom`,
`jpeg-xl`, `cairo`, `gnutls`, `harfbuzz`, `libass`, `pango`, `tesseract`) and
`ffmpeg` itself -- not directly used day-to-day. JIT-reinstall
(`brew install ffmpeg`, which pulls the rest back in as deps) if a future
project needs audio/video/OCR processing.
