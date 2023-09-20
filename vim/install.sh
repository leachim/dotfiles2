#!/bin/sh

## vim
echo "Installing Vim Plugins .."
command -v nvim >/dev/null

if [[ $? -ne 0 ]]; then
    echo "Nvim is not installed"
  # install plug.vim for vim
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim +PlugInstall
else
    echo "Nvim is installed"
  # and for nvim
  #curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  #  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  nvim +PlugInstall
fi

if test ! "$(uname)" = "Darwin"
  then
  exit 0
fi

exit 0
