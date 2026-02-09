#!/bin/sh
#
# starship
#

# Check if starship is already installed (e.g., via cargo)
if command -v starship >/dev/null 2>&1; then
  echo "  starship: already installed ($(starship --version | head -1))"
  exit 0
fi

if test "$(uname)" = "Darwin"
then
  if command -v brew >/dev/null 2>&1; then
    brew install starship
  fi
elif test "$(uname -s | cut -c1-5)" = "Linux"
then
  echo "  starship: installing via official installer"
  curl -sS https://starship.rs/install.sh | sh -s -- -y --bin-dir "$HOME/.local/bin"
fi

exit 0
