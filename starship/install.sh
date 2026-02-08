#!/bin/sh
#
# starship
#
if test "$(uname)" = "Darwin"
then
  if command -v brew >/dev/null 2>&1; then
    brew install starship
  fi
elif test "$(uname -s | cut -c1-5)" = "Linux"
then
  curl -sS https://starship.rs/install.sh | sh -s -- -y --bin-dir "$HOME/.dotfiles/bin"
fi

exit 0
