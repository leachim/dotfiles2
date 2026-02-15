#!/bin/sh

# Relies on TMUX_TMPDIR being set in ~/.profile

if tmux list-sessions >/dev/null 2>&1; then
  tmux kill-server
  echo "Killed tmux server"
else
  echo "No tmux server running"
fi
