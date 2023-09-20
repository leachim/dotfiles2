#!/bin/sh

## vim
echo "Installing Vim Plugins .."
# install plug.vim for vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# and for nvim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#vim +PlugInstall

if test ! "$(uname)" = "Darwin"
  then
  exit 0
fi

exit 0
