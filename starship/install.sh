#!/bin/sh
#
# starship
#
if test "$(uname)" = "Darwin"
then
  brew install starship
elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
then
  curl -sS https://starship.rs/install.sh | sh -s -- -y --bin-dir /$HOME/.dotfiles/bin
fi

exit 0
