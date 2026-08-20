# dotfiles

Reproducible terminal setup. No sudo required (except optional myx dependencies).

## Stack

| Tool | What | Version |
|------|------|---------|
| zsh | Shell | 5.8.1+ |
| Oh My Zsh | Zsh framework | latest |
| Powerlevel10k | Prompt theme | Pure style |
| tmux | Terminal multiplexer | 3.7b (static binary) |
| fastfetch | System info | 2.67.1 |
| myx | Spotify TUI | latest |
| opencode | AI coding agent | latest |

### Zsh plugins

| Plugin | What it does |
|--------|-------------|
| `git` | Oh My Zsh git aliases and prompt info |
| `zsh-autosuggestions` | Fish-like autosuggestions from history |
| `zsh-syntax-highlighting` | Color-coded command highlighting |
| `zsh-autocomplete` | Real-time tab completions as you type |

## Theme

**Modern Neutrals** — a cohesive palette shared across tmux, fastfetch, and LS_COLORS.

```
cream    #e8e4dd    pane borders, active highlights
greige   #c7beb1    inactive borders, separators, muted text
taupe    #b39c89    status bar accents, sockets
charcoal #2e2c31    backgrounds, status bar base
blush    #e5c9c0    links, executables
```

## Install

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
make
```

`make` runs all targets in order. Every target checks if its component is already installed before doing anything — safe to run multiple times.

On a school server with `/goinfre`, cargo and rustup are moved there to preserve home quota. On regular Ubuntu, they stay in `~/.cargo`.

## How it works

### Zsh (`.zshrc`)

The shell config adds `~/.local/bin` and `~/.opencode/bin` to PATH, loads Oh My Zsh with Powerlevel10k theme, enables the four plugins above, sets custom `LS_COLORS` matching the Modern Neutrals palette, and sources the cargo environment if present.

Tmux is configured to auto-start on every new shell via Oh My Zsh's `ZSH_TMUX_AUTOSTART=true`.

### Tmux (`.tmux.conf`)

**Mouse and clipboard:** Mouse is enabled. Right-click opens a context menu with split, swap, kill, paste from system clipboard (via `xclip`), and copy mode options. Copying with `y` in copy mode goes to both tmux buffer and system clipboard.

**Visual style:** Modern Neutrals palette applied to:
- Pane borders (greige inactive, cream active)
- Status bar (charcoal background, taupe accents)
- Window tabs (greige inactive, cream active)
- Messages

**Copy mode:** Vi keybindings. `y` copies selection to system clipboard.

**Auto-layout:** New sessions automatically split into 3 panes:

```
┌─────────────┬─────────────┐
│  fastfetch  │     myx     │
│  (refresh)  │  (spotify)  │
├─────────────┴─────────────┤
│          shell             │
└────────────────────────────┘
```

Top-left pane runs fastfetch in a loop (refreshes every 30s). Top-right opens myx (Spotify TUI). Bottom pane is your working shell.

### Fastfetch (`fastfetch/config.jsonc`)

Custom config with:
- **Logo:** ASCII art of the Brand of Sacrifice (Berserk) with cream gradient
- **Hardware section:** CPU, GPU, RAM, disk (home partition usage)
- **Software section:** OS, kernel, packages, shell, terminal, currently playing song (via `now-playing.sh`)
- **Session section:** Uptime, local IP
- **Colors:** 16-color palette matching Modern Neutrals

Disk info uses `df -h $HOME` to dynamically show the home partition for any user.

Alternate config (`config.alt.jsonc`) available for a different look.

### Powerlevel10k (`.p10k.zsh`)

Pure-style prompt with:
- Left: directory, git status (minimal), prompt char
- Right: command execution time (if >= 5s), virtualenv, context (SSH/root only), time
- Vi mode indicators: `>` normal, `<` visual
- Git: commit hash in detached HEAD, dirty indicator (`*`), ahead/behind arrows

### LS_COLORS

Custom color definitions matching the palette:
- Directories: cream
- Symlinks: blush
- Executables: blush
- Archives (tar, zip, gz): greige
- Python files: light grey
- JSON: greige
- Markdown: blush

### Cargo / Rust

Cargo and rustup are installed to `~/.cargo` and `~/.rustup`. On school servers with `/goinfre` (local per-machine storage with more quota), the `move-cargo` target moves them there and creates symlinks. This preserves home directory quota.

On regular Ubuntu systems without `/goinfre`, cargo stays in `~/.cargo`.

The `cargo` target detects broken symlinks (from switching PCs on a school server) and reinstalls cleanly.

### Myx (Spotify TUI)

Installed via `cargo install myx`. Requires system dependencies that may need sudo:

```
pkg-config libssl-dev libasound2-dev
```

If missing, `make` prompts to install them. On systems without sudo, myx is skipped — everything else still works.

### Opencode

AI coding agent. Installed to `~/.opencode/bin`.

## Goinfre (school servers)

On school servers, `/goinfre` is local per-machine storage with more quota than home. The Makefile moves cargo/rustup there:

1. `cargo` target detects broken symlinks from PC switches and reinstalls
2. `move-cargo` checks if `/goinfre` exists — if yes, moves cargo there and symlinks; if no, skips
3. PATH ordering (`~/.local/bin` first) ensures local binaries take precedence over system ones

When switching PCs, broken symlinks are automatically detected and cleaned up. Run `make` on the new PC to reinstall.

## Structure

```
dotfiles/
├── .zshrc                        # shell config
├── .p10k.zsh                     # powerlevel10k prompt
├── .tmux.conf                    # tmux config + 3-pane auto-layout
├── fastfetch/
│   ├── config.jsonc              # Berserk logo + Modern Neutrals
│   ├── config.alt.jsonc          # alternate colorful config
│   └── now-playing.sh            # currently playing song script
├── myx/config.toml               # spotify TUI config
├── opencode/opencode.jsonc       # opencode config
├── Makefile                      # install everything
└── README.md                     # this file
```

After `make link`, symlinks are created:

```
~/.zshrc                        → ~/dotfiles/.zshrc
~/.p10k.zsh                     → ~/dotfiles/.p10k.zsh
~/.tmux.conf                    → ~/dotfiles/.tmux.conf
~/.config/fastfetch/config.jsonc     → ~/dotfiles/fastfetch/config.jsonc
~/.config/fastfetch/config.alt.jsonc → ~/dotfiles/fastfetch/config.alt.jsonc
~/.config/myx/config.toml            → ~/dotfiles/myx/config.toml
~/.config/opencode/opencode.jsonc    → ~/dotfiles/opencode/opencode.jsonc
```

Editing any file in the dotfiles repo immediately takes effect since they're symlinked.

## Makefile targets

```
make           # install everything (default)
make zsh       # check zsh is available
make oh-my-zsh # install Oh My Zsh (skips if already installed)
make plugins   # install zsh plugins (skips if already installed)
make p10k      # install Powerlevel10k (skips if already installed)
make tmux      # install tmux static binary (skips if already installed)
make tpm       # install tmux plugin manager (skips if already installed)
make fastfetch # download fastfetch binary (skips if already installed)
make cargo     # install Rust toolchain (skips if already installed)
make myx       # install myx via cargo (checks deps first)
make opencode  # install opencode (skips if already installed)
make link      # symlink all configs to ~
make unlink    # remove all symlinks
make clean     # remove stale files (backups, cache)
make help      # show all targets
```

### Idempotency

Every target checks if its component is already installed before doing anything. Running `make` multiple times is safe — nothing gets reinstalled or deleted unnecessarily.

### Error handling

- If `myx` dependencies are missing, you're prompted to install with sudo or skip
- If `cargo` installation fails, the error is caught and reported
- Broken symlinks (from PC switches) are detected and cleaned up automatically
- If `/goinfre` doesn't exist, `move-cargo` skips gracefully
- `make all` continues even if optional targets fail

### Dependency check order

`make all` runs targets in this order:

```
zsh → oh-my-zsh → plugins → p10k → tmux → tpm → fastfetch → cargo → myx → opencode → link → move-cargo
```

Each target is independent — a failure in one doesn't prevent others from running (except `myx` which depends on `cargo`, and `tpm` which logically follows `tmux`).
