#!/bin/sh
#
# Node.js via nvm

# Check if node is already installed
if command -v node >/dev/null 2>&1; then
  echo "  node: already installed ($(node --version))"

  # Still install gemini-cli if node exists
  if ! command -v gemini >/dev/null 2>&1; then
    echo "  gemini-cli: installing globally"
    npm install -g @google/gemini-cli
  else
    echo "  gemini-cli: already installed"
  fi
  exit 0
fi

# Install nvm if not present
if [ ! -d "$HOME/.config/nvm" ]; then
  echo "  nvm: installing"
  (unset NVM_DIR; curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash)
else
  echo "  nvm: already installed"
fi

# Load nvm from .config/nvm (current default)
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install node LTS
echo "  node: installing LTS version"
nvm install --lts
nvm use --lts

# Install gemini-cli
echo "  gemini-cli: installing globally"
npm install -g @google/gemini-cli

exit 0
