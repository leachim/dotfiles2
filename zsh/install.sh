# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  git clone --depth 1 --recurse-submodules https://github.com/ohmyzsh/ohmyzsh /home/$USER/.ohmyzsh

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
