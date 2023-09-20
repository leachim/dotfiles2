#!/bin/sh

echo "Setting up your instance..."
echo "First install vim git zsh curl"

## Intro
echo "Install basic command line environment"
sleep 2
echo "The following packages should be installed: vim git zsh curl (conky)"
hash git 2>/dev/null || { echo >&2 "I require git but it's not installed.  Aborting."; exit 1; }
hash vim 2>/dev/null || { echo >&2 "I require vim but it's not installed.  Aborting."; exit 1; }
hash curl 2>/dev/null || { echo >&2 "I require curl but it's not installed.  Aborting."; exit 1; }
hash zsh 2>/dev/null || { echo >&2 "I require zsh but it's not installed.  Aborting."; exit 1; }

##
echo "symlinking dotfiles..."
dir="$HOME/.dotfiles/"

#
echo "backing up existing dotfiles..."
for dotfile in ${HOME}/.*;
do
  if [ "$dotfile" != "${HOME}/.dotfiles" ] && [ "$dotfile" != "${HOME}/.ssh" ] ;
  then
    echo "backing up $dotfile"
    mv $dotfile "$dotfile.bak"
  fi;
done
sleep 3

for dotfile in  .* ;
do
	echo "creating symlik for $dotfile"
    if [ -d $dotfile ]; then
        ln -sf "$dir/$dotfile/" "$HOME/$dotfile"
    else
	    ln -sf "$dir/$dotfile" "$HOME/$dotfile"
    fi
done
sleep 5


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
    eval "$(/home/${USER}/.linuxbrew/bin/brew shellenv)"
    brew update --force --quiet
    chmod -R go-w "$(brew --prefix)/share/zsh"

    # requires basic tools like gcc, make
    curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir /home/$USER/.dotfiles/bin
    #brew install starship
    #brew install tmux
    #brew install neovim
    #brew install fasd
fi


if [ "$(uname)" == "Darwin" ]; then
  # Update Homebrew recipes
  brew update

  # Install all our dependencies with bundle (See Brewfile)
  brew tap homebrew/bundle
  brew bundle --file ./Brewfile

  # Symlink the Mackup config file to the home directory
  ln -s ./.mackup.cfg $HOME/.dotfiles/.mackup.cfg

  # Set macOS preferences - we will run this last because this will reload the shell
  source ./.macos
fi

## vim
echo "Installing Vim Plugins .."
# install plug.vim for vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# and for nvim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall
