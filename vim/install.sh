#!/bin/sh

## vim
echo "Installing Vim Plugins .."

if ! command -v nvim &> /dev/null
then
    echo "Nvim is not installed"
  # install plug.vim for vim
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -u "~/.dotfiles.vim/vimrc.symlink" +PlugInstall
fi
if
echo "Nvim is installed"
  # and for nvim
  #curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  #  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  sh -c 'curl -fLo "~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  nvim "~/.dotfiles.vim/vimrc.symlink" +PlugInstall
fi

if test ! "$(uname)" = "Darwin"
  then
  exit 0
fi

exit 0
