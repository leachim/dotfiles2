#!/bin/bash
echo "Installing Tmux Plugin Manager (TPM) .."

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Install plugins headlessly
"$TPM_DIR/bin/install_plugins"

exit 0
