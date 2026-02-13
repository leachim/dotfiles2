#!/bin/bash
# Config for Euler cluster nodes (matches eu-*)

alias quota_euler="cat /cluster/work/bewi/.bewi_user_data_usage.txt"
alias clusterquota='lfs quota -h -g fmlab'

# Cluster-specific paths
export PATH="$HOME/.local/bin:$PATH"
export PATH=$HOME/cuda/bin:$HOME/.claude/local:$HOME/mmseqs2/bin:$PATH
export PATH="/cluster/home/michaes/.pixi/bin:$PATH"
export PATH="/cluster/work/bewi/members/michaes/npm-global/v22.14.0/bin:$PATH"
export LD_LIBRARY_PATH=$HOME/cuda/lib64:$LD_LIBRARY_PATH
export TORCH_CUDA_ARCH_LIST="8.0;8.6;8.9;9.0"
export XDG_CONFIG_HOME="$HOME/.config"

# Fast Bash defaults on Euler hosts (eu-*). Opt out with:
#   export DOTFILES_CLUSTER_FAST_MODE=0
if [ -n "$BASH_VERSION" ]; then
    : "${DOTFILES_CLUSTER_FAST_MODE:=1}"
    if [ "$DOTFILES_CLUSTER_FAST_MODE" = "1" ]; then
        export DOTFILES_DISABLE_BASH_COMPLETION="${DOTFILES_DISABLE_BASH_COMPLETION:-1}"
        export STARSHIP_DISABLE="${STARSHIP_DISABLE:-true}"

        # Keep frequently-written caches off high-latency network metadata paths.
        export XDG_CACHE_HOME="${XDG_CACHE_HOME:-/tmp/$USER/.cache}"
        export NPM_CONFIG_CACHE="${NPM_CONFIG_CACHE:-$XDG_CACHE_HOME/npm}"
        export PIP_CACHE_DIR="${PIP_CACHE_DIR:-$XDG_CACHE_HOME/pip}"
        export UV_CACHE_DIR="${UV_CACHE_DIR:-$XDG_CACHE_HOME/uv}"

        mkdir -p "$XDG_CACHE_HOME" "$NPM_CONFIG_CACHE" "$PIP_CACHE_DIR" "$UV_CACHE_DIR" 2>/dev/null || true
    fi
fi

# Cluster aliases
alias qqsqu="squeue -u \$(whoami) -o \"%.18i %.12P %.20j %.3T %.12M %.10l %.6D %.4C %R\""
alias qqsqw="watch -n 10 'squeue -u \$(whoami) -o \"%.18i %.12P %.20j %.3T %.12M %.10l %.6D %.4C %R\"'"
alias qqsqwa='watch -n 10 '\''squeue -o "%.18i %.12P %.20j %.8u %.3T %.12M %.10l %.6D %.4C %.16b %R" | sed "1!s/gres\/gpu:[^:]*://g; 1!s/N\/A/0/g"'\'''
alias sqg="squeue -u \$(whoami) -h -o \"%i %j\" | while read jobid name; do gpu=\$(scontrol show job \$jobid 2>/dev/null | sed -n 's/.*gres\/gpu:\([0-9]\+\).*/\1/p' | head -1); echo \"Job \$jobid (\$name): \${gpu:-0} GPUs\"; done"
sqcc() { [[ -z "$1" || "$1" =~ ^[[:space:]]*$ ]] && { echo "Error: Pattern required" >&2; return 1; }; squeue -u "$(whoami)" -h -o "%i %j" | grep "$1" | awk '{print $1}' | xargs scancel ; }

alias squeue="squeue --format=\"%.18i %.9P %.27j %.8u %.2t %.10M %.6D %R\""
alias m-squeuec="squeue -u \$(whoami) -o \"%.14i %.50j %.2t %.10M\""
alias m-squeuei="squeue -u \$(whoami) -o \"%.14i %.5j %.2t %.10M %.9l %.5D %16R %5K %3C %o\""
alias m-squeuea="squeue -o \"%.14i %.5j %.2t %.10M %.9l %.5D %16R %5K %3C %Q %o\""
alias m-jobmonitor="SACCT_FORMAT=\"JobID%20,JobName,User,Partition,NodeList,Elapsed,State,ExitCode,MaxRSS,AllocTRES%32\" sacct"
squeue-watch () { watch -n 3 -d "squeue -u $(whoami) --format=\"%.14i %.5j %.2t %.10M %.9l %.5D %16R %5K %3C %Q %o\"" ; }
alias m-squeuew="squeue-watch"

alias gemini-api="GEMINI_API_KEY=\$GEMINI_API_KEY gemini"

_dotfiles_is_login_shell=false
if [ -n "$BASH_VERSION" ]; then
    shopt -q login_shell && _dotfiles_is_login_shell=true
elif [ -n "$ZSH_VERSION" ]; then
    [[ -o login ]] && _dotfiles_is_login_shell=true
fi

if [[ $- == *i* ]] && [ "$_dotfiles_is_login_shell" = true ]; then
    module load eth_proxy 2>/dev/null
    module load stack/2024-06 2>/dev/null
    module load gcc/12.2.0 2>/dev/null
    module load cuda/12.8.0 2>/dev/null
fi
unset _dotfiles_is_login_shell

# Skip heavy cluster initialization for AI agents
# Module loads can hang if cluster services are slow/unresponsive
if [ "$AI_AGENT" != "1" ]; then
    [ -f /etc/profile.d/lmod.sh ] && source /etc/profile.d/lmod.sh
    [ -f /etc/profile.d/module_path.sh ] && source /etc/profile.d/module_path.sh

    # Starship config switcher: use fast config on cluster filesystems
    # (disables git scanning, language detection, custom commands)
    set_starship_config() {
        if [[ $PWD == /cluster/* ]]; then
            export STARSHIP_CONFIG=~/.starship_nogit.toml
        else
            export STARSHIP_CONFIG=~/.starship.toml
        fi
    }
    if [ -n "$ZSH_VERSION" ]; then
        precmd_functions+=(set_starship_config)
    elif [ -n "$BASH_VERSION" ] && [ "${STARSHIP_DISABLE:-}" != "true" ]; then
        PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}set_starship_config"
    fi

fi

# Add pixi to path if present
if [ -d "$HOME/.pixi/bin" ]; then
    PATH="$PATH:$HOME/.pixi/bin"
fi
