#!/bin/bash

## vim
echo "Installing Vim Plugins .."

if command -v vim &> /dev/null
then
  echo "Vim is installed"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &>/dev/null
  vim -u "$HOME/.dotfiles/vim/vimrc.symlink" +PlugInstall +qall </dev/null &>/dev/null
  stty sane 2>/dev/null
fi

if command -v nvim &> /dev/null
then
  echo "Nvim is installed"
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &>/dev/null
  nvim --headless -u "$HOME/.dotfiles/vim/vimrc.symlink" +PlugInstall +qall &>/dev/null
fi

exit 0
