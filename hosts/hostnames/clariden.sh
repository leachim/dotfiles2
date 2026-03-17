#!/bin/bash
# Config for Clariden cluster nodes (aarch64, matches clariden-*)
# GPU nodes available but only used via containers (enroot/docker/podman)
# No module loads needed

# aarch64-specific prefix (shadows ~/.local/bin from hpc.sh)
export PATH="$HOME/.local/aarch64/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/aarch64/lib:${LD_LIBRARY_PATH:-}"
export CPATH="$HOME/.local/aarch64/include:${CPATH:-}"

# Override Starship cluster filesystem detection (/capstor instead of /cluster)
if [ "$AI_AGENT" != "1" ]; then
    set_starship_config() {
        if [[ $PWD == /capstor/* ]]; then
            export STARSHIP_CONFIG=~/.starship_nogit.toml
        else
            export STARSHIP_CONFIG=~/.starship.toml
        fi
    }
fi
