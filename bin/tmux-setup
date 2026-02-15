#!/bin/sh

# Relies on TMUX_TMPDIR being set in ~/.profile

SESSION="${1:-$(hostname -s 2>/dev/null || echo main)}"

# setup session and first window
tmux new-session -d -s "$SESSION" -n "$SESSION"
tmux split-window -h
tmux split-window -v

# second window
if ! [ "$SESSION" = "darwin" ]; then
	tmux new-window -n claude
	tmux split-window -h
	tmux split-window -v
else
	echo "There is only one Darwin."
fi

tmux attach-session -d
