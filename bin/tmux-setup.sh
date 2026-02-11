#!/bin/sh

# Relies on TMUX_TMPDIR being set in ~/.profile

# setup session and first window
tmux new-session -d -s "$1" -n "$1"
tmux split-window -h
tmux split-window -v

# second window
if ! [ "$1" = "darwin" ]; then
	tmux new-window -n claude
	tmux split-window -h
	tmux split-window -v
else
	echo "There is only one Darwin."
fi

tmux attach-session -d
