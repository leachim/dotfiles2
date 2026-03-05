#!/bin/bash
# Configuration for HPC cluster environments

# Cluster-specific paths
export PATH="$HOME/.local/bin:$PATH"
export PATH=$HOME/cuda/bin:$HOME/.claude/local:$PATH
export XDG_CONFIG_HOME="$HOME/.config"

# Slurm shortcuts (qsq* = squeue, qw* = watch, sqg = GPU detail)
alias qsq="squeue -u \$(whoami) -o \"%.18i %.12P %.20j %.3T %.12M %.10l %.6D %.4C %R\""
alias qsqa='squeue -o "%.18i %.12P %.20j %.8u %.3T %.12M %.10l %.6D %.4C %.16b %R" | sed "1!s/gres\/gpu:[^:]*://g; 1!s/N\/A/0/g"'
alias qsqd="squeue -u \$(whoami) -o \"%.14i %.20j %.2t %.10M %.9l %.5D %16R %5K %3C %o\""
alias qsqm='SACCT_FORMAT="JobID%20,JobName,User,Partition,NodeList,Elapsed,State,ExitCode,MaxRSS,AllocTRES%32" sacct'
sqg() { squeue -u "$(whoami)" -h -o "%i %j" | while read jobid name; do gpu=$(scontrol show job "$jobid" 2>/dev/null | sed -n 's/.*gres\/gpu:\([0-9]\+\).*/\1/p' | head -1); echo "Job $jobid ($name): ${gpu:-0} GPUs"; done; }
qsqc() { [[ -z "$1" || "$1" =~ ^[[:space:]]*$ ]] && { echo "Error: Pattern required" >&2; return 1; }; squeue -u "$(whoami)" -h -o "%i %j" | grep "$1" | awk '{print $1}' | xargs scancel; }
alias qwsq="watch -n 10 'squeue -u \$(whoami) -o \"%.18i %.12P %.20j %.3T %.12M %.10l %.6D %.4C %R\"'"
alias qwsqa='watch -n 10 '\''squeue -o "%.18i %.12P %.20j %.8u %.3T %.12M %.10l %.6D %.4C %.16b %R" | sed "1!s/gres\/gpu:[^:]*://g; 1!s/N\/A/0/g"'\'''
alias qwsqd="watch -n 10 -d 'squeue -u \$(whoami) -o \"%.14i %.20j %.2t %.10M %.9l %.5D %16R %5K %3C %o\"'"

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
    elif [ -n "$BASH_VERSION" ]; then
        PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}set_starship_config"
    fi

fi

# Add pixi to path if present
if [ -d "$HOME/.pixi/bin" ]; then
    PATH="$PATH:$HOME/.pixi/bin"
fi
