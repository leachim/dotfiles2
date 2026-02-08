#!/bin/sh

SOCKET_DIR="$HOME/.tmux_server"
SOCKET_FILE="$SOCKET_DIR/tmux.sock"

# Create socket directory if it doesn't exist
mkdir -p "$SOCKET_DIR"

# setup session and first window
tmux -S "$SOCKET_FILE" new-session -d -s "$1" -n "$1"
tmux -S "$SOCKET_FILE" split-window -h
tmux -S "$SOCKET_FILE" split-window -v

# second window
if ! [ "$1" = "darwin" ]; then
	tmux -S "$SOCKET_FILE" new-window -n claude
	tmux -S "$SOCKET_FILE" split-window -h
	tmux -S "$SOCKET_FILE" split-window -v
else
	echo "There is only one Darwin."
fi

tmux -S "$SOCKET_FILE" attach-session -d
