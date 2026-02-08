#!/bin/sh
#
# Rust (via rustup)

if [ -f "$HOME/.cargo/env" ]; then
    echo "  Rust already installed, updating..."
    . "$HOME/.cargo/env"
    rustup update
else
    echo "  Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    . "$HOME/.cargo/env"
fi

cargo install cargo-update skim zoxide bat fd-find eza git-delta

exit 0
