#!/bin/bash

## vim
echo "Installing Vim Plugins .."

if command -v vim &> /dev/null
then
    echo "Vim is installed"
  # install plug.vim for vim
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -u "$HOME/.dotfiles/vim/vimrc.symlink" +PlugInstall +qall
fi

if command -v nvim &> /dev/null
then
echo "Nvim is installed"
  sh -c 'curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  nvim -u "$HOME/.dotfiles/vim/vimrc.symlink" +PlugInstall +qall
fi

if test ! "$(uname)" = "Darwin"
  then
  exit 0
fi

exit 0
