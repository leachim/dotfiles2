#!/bin/bash
# Configuration for macOS machines

# Add pixi to path if present
if [ -d "$HOME/.pixi/bin" ]; then
    PATH="$PATH:$HOME/.pixi/bin"
fi
