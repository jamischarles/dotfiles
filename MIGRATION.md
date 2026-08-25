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

## Not yet decided

- Brewfile (`~/.dotfiles/Brewfile`, 107 entries) has not been pruned -- review before
  running `brew bundle` on the new machine.
