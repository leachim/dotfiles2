#!/bin/bash
# Configuration for macOS machines

# Add conda to path if present
if [ -d "$HOME/.miniconda/condabin" ]; then
    PATH="$PATH:$HOME/.miniconda/condabin"
fi
