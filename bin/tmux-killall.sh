#!/bin/sh

SOCKET_DIR="$HOME/.tmux_server"
SOCKET_FILE="$SOCKET_DIR/tmux.sock"

# Kill sessions on custom socket
if [ -S "$SOCKET_FILE" ]; then
  tmux -S "$SOCKET_FILE" kill-server
  echo "Killed tmux server on $SOCKET_FILE"
fi

# Kill sessions on default socket
if tmux list-sessions >/dev/null 2>&1; then
  tmux kill-server
  echo "Killed default tmux server"
fi
