#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if test $(which brew)
then
  # Update Homebrew recipes
  brew update

  # Install all our dependencies with bundle (See Brewfile)
  brew bundle --file="$HOME/.Brewfile"
fi

exit 0
