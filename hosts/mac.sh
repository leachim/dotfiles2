#!/bin/bash
# Configuration for macOS machines

# Add pixi to path if present
if [ -d "$HOME/.pixi/bin" ]; then
    PATH="$PATH:$HOME/.pixi/bin"
fi

# LM Studio CLI (macOS-only install; was hardcoded into the tracked shell rc
# files, where it also landed on every Linux/HPC host as a dead PATH entry)
if [ -d "$HOME/.lmstudio/bin" ]; then
    PATH="$PATH:$HOME/.lmstudio/bin"
fi
