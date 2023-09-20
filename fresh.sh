#!/bin/sh

echo "Setting up your instance..."

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if [ "$(uname)" == "Darwin" ]; then
  if test ! $(which brew); then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
    mkdir /home/$USER/.linuxbrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C /home/$USER/.linuxbrew
    eval "$(~/l/bin/brew shellenv)"
    brew update --force --quiet
    chmod -R go-w "$(brew --prefix)/share/zsh"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -f $HOME/.zshrc
ln -s .zshrc $HOME/.zshrc

if [ "$(uname)" == "Darwin" ]; then
  # Update Homebrew recipes
  brew update

  # Install all our dependencies with bundle (See Brewfile)
  brew tap homebrew/bundle
  brew bundle --file ./Brewfile

  # Symlink the Mackup config file to the home directory
  ln -s ./.mackup.cfg $HOME/.mackup.cfg

  # Set macOS preferences - we will run this last because this will reload the shell
  source ./.macos
fi
