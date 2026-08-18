# dotfiles

Reproducible terminal setup. No sudo required.

## Stack

| Tool | What | Version |
|------|------|---------|
| zsh | Shell | 5.8.1+ |
| Oh My Zsh | Zsh framework | latest |
| Powerlevel10k | Prompt theme | Pure style |
| tmux | Terminal multiplexer | 3.7 |
| fastfetch | System info | 2.67.1 |
| myx | Spotify TUI | latest |
| opencode | AI coding agent | latest |

### Zsh plugins

- `git` — Oh My Zsh git aliases
- `zsh-autosuggestions` — fish-like suggestions
- `zsh-syntax-highlighting` — command highlighting
- `zsh-autocomplete` — real-time completions

## Theme

**Modern Neutrals** — cream, greige, taupe, charcoal, blush. Shared across tmux, fastfetch, and LS_COLORS for a cohesive look.

```
cream    #e8e4dd    pane borders, directories
greige   #c7beb1    inactive borders, separators
taupe    #b39c89    status accents, sockets
charcoal #2e2c31    backgrounds
blush    #e5c9c0    links, executables
```

## Install

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
make
```

Everything installs to `~/.local`, `~/.cargo`, or `~/.oh-my-zsh`. No root needed.

## Structure

```
dotfiles/
├── .zshrc                      # shell config
├── .p10k.zsh                   # powerlevel10k prompt
├── .tmux.conf                  # tmux + 3-pane auto-layout
├── fastfetch/
│   ├── config.jsonc            # Berserk logo + Modern Neutrals
│   └── config.alt.jsonc        # alternate colorful config
├── myx/config.toml             # spotify TUI
├── opencode/opencode.jsonc     # opencode config
└── Makefile                    # install everything
```

## Makefile targets

```
make           # install everything (default)
make zsh       # check zsh is available
make oh-my-zsh # install Oh My Zsh
make plugins   # install zsh plugins
make p10k      # install Powerlevel10k
make tmux      # build tmux from source
make tpm       # install tmux plugin manager
make fastfetch # download fastfetch binary
make cargo     # install Rust toolchain
make myx       # install myx via cargo
make opencode  # install opencode
make link      # symlink configs to ~
make unlink    # remove symlinks
make help      # show all targets
```

Idempotent — running `make` again skips what's already installed.

## Tmux layout

New sessions auto-split into 3 panes:

```
┌─────────────┬─────────────┐
│  fastfetch  │     myx     │
│  (refresh)  │  (spotify)  │
├─────────────┴─────────────┤
│          shell             │
└────────────────────────────┘
```

fastfetch refreshes every 30s. myx opens in the top-right. Shell takes the bottom.
