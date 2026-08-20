# Dotfiles

Cross-platform dotfiles for macOS and Linux servers. Clone once, run bootstrap, get a consistent environment everywhere.

## Quick Start

```bash
git clone https://github.com/YOUR_USER/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

Bootstrap will prompt you for:

1. **Git identity** -- name and email (auto-detects credential helper per platform)
2. **Machine role** -- `mac`, `linux-desktop`, or `hpc` (stored locally, not tracked)
3. **Symlinks** -- all `*.symlink` files get linked into `$HOME`
4. **Homebrew** -- installs Homebrew and Brewfile packages (macOS only)
5. **Optional software** -- each prompted individually:
   - Oh My Zsh
   - Vim/Neovim plugins (vim-plug)
   - Starship prompt
   - Rust (via rustup)
   - Bun (includes gemini-cli, codex, ccusage)
   - Claude Code config
   - Codex CLI config
   - opencode config
   - GitHub CLI (gh)
6. **pixi** -- optional, cross-platform

## Updating

Run `script/update` to update an existing installation. It refreshes symlinks, then
updates whatever it finds installed: Homebrew, rustup and cargo binaries, vim/nvim
plugins, Oh My Zsh, starship (Linux) and pixi. Anything absent is skipped, so it is
safe on every host.

`dot` is narrower and macOS-only: it applies the macOS defaults from
`macos/set-defaults.sh` and runs `brew update` plus the Brewfile. It does not
re-run the optional installers -- use `script/install` for those.

## Repository Structure

```
~/.dotfiles/
├── aliases/           Shell aliases and git aliases (*.symlink)
├── autocompletion/    Shell completion scripts
├── bash/              Bash config (bash_profile, bashrc)
├── bin/               Executables added to $PATH (dot, utilities)
├── claude/            Claude Code config (CLAUDE.md, settings.json)
├── codex/             Codex CLI config (config.toml)
├── opencode/          opencode config (opencode.jsonc)
├── docker/            Docker aliases (*.zsh, auto-sourced)
├── functions/         Autoloaded zsh functions and completions
├── gh/                GitHub CLI installer (Linux; macOS uses Brewfile)
├── git/               Git config, aliases, completion
├── homebrew/          Brewfile and install script
├── hosts/             Role-specific config (mac.sh, linux-desktop.sh, hpc.sh)
├── macos/             macOS defaults and software updates
├── bun/               Bun runtime, gemini-cli, codex, ccusage
├── ruby/              Ruby/RVM config
├── rust/              Rust install via rustup
├── script/            Bootstrap, install, pixi-setup
├── starship/          Starship prompt config
├── system/            Environment, PATH, keys, aliases (*.zsh)
├── tmux/              Tmux configuration
├── vim/               Vim/Neovim config and plugin installer
├── xcode/             Xcode aliases
├── yarn/              Yarn PATH setup
└── zsh/               Zsh config, Oh My Zsh, history, keybindings
```

## How It Works

### Backups

Bootstrap automatically backs up any existing config files before replacing them with symlinks. Backups are stored in a timestamped directory:

```
~/.dotfiles_backup/20260208_143022/
├── .zshrc
├── .vimrc
├── .gitconfig
└── claude/
    └── CLAUDE.md
```

This means running bootstrap on a machine with existing configs is safe -- nothing is lost. Install scripts (Claude Code, Oh My Zsh) use the same backup directory.

### Symlinks

Any file named `*.symlink` gets symlinked to `$HOME/.FILENAME` during bootstrap. For example:

- `zsh/zshrc.symlink` -> `~/.zshrc`
- `vim/vimrc.symlink` -> `~/.vimrc`
- `git/gitconfig.symlink` -> `~/.gitconfig`

### Auto-sourced files

The zsh config (`zshrc.symlink`) automatically sources all `*.zsh` files under
`$DOTFILES` (`~/.dotfiles`). Note `$ZSH` is a different variable -- zshrc points it
at `~/.oh-my-zsh`.

- `path.zsh` -- loaded first (PATH setup)
- `completion.zsh` -- loaded last (after compinit)
- Everything else -- loaded in between

The match is on the exact name `path.zsh`, so a file named `_path.zsh` lands in the
"everything else" pass instead. `system/path.zsh` is the single place that orders
the system prefixes, including Homebrew's.

This means adding a new `*.zsh` file to any topic directory picks it up automatically.

### Install scripts

Each `*/install.sh` is run by `script/install` with an interactive prompt. They handle their own platform detection.

### Machine roles

The `hosts/` directory contains role-specific shell config. During bootstrap you pick a role, which gets written to `host_role` (gitignored). Your shell sources `hosts/<role>.sh` on startup.

Available roles:

| Role | Platform | Purpose |
|------|----------|---------|
| `mac` | macOS | pixi PATH, macOS-specific setup |
| `linux-desktop` | Linux | Wayland/Sway desktop session |
| `hpc` | Linux | HPC cluster paths |

Add new roles by creating a file in `hosts/` and selecting it during bootstrap.

### Per-machine overrides

For variables specific to a single machine (API keys, one-off paths), use `~/.localrc`. It is sourced by zsh and not tracked in git.

### Private environment

API keys and secrets go in `~/.dotfiles/private/env` (gitignored). Sourced by `profile.symlink`.

## Platform Support

| Feature | macOS | Linux |
|---------|-------|-------|
| Shell config (zsh/bash) | Yes | Yes |
| Vim/Neovim | Yes | Yes |
| Tmux | Yes | Yes |
| Git config | Yes | Yes |
| Starship prompt | Homebrew | curl installer |
| Rust | rustup | rustup |
| pixi | Optional | Optional |
| Homebrew + Brewfile | Yes | -- |
| macOS defaults | Yes | -- |
| Claude Code | Yes | Yes |
| Codex CLI | Yes | Yes |

## Prerequisites

Install these before running bootstrap:

- `git`
- `curl`
- `zsh` (or use bash -- both are configured)
- `vim` or `neovim` (optional, for plugin install)

On macOS, Homebrew handles most dependencies. On Linux, install via your package manager.
