#!/usr/bin/env bash
#
# Install GitHub CLI (gh) on Linux.
# On macOS, gh is installed via Homebrew (Brewfile), so this is a no-op.

set -e

if [ "$(uname -s)" = "Darwin" ]; then
  echo "  gh: skipping (installed via Homebrew on macOS)"
  exit 0
fi

if command -v gh &> /dev/null; then
  echo "  gh: already installed"
  exit 0
fi

echo "  gh: installing GitHub CLI for Linux"

# Official install method: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
  && sudo mkdir -p -m 755 /etc/apt/keyrings \
  && out=$(mktemp) && wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  && cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
  && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo apt update \
  && sudo apt install gh -y

echo "  gh: installed $(gh --version | head -1)"
