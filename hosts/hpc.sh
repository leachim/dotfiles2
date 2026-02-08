#!/bin/bash
# Configuration for HPC cluster environments

# Cluster-specific paths
export PATH="$HOME/.local/bin:$PATH"
export PATH=$HOME/cuda/bin:$HOME/.claude/local:$HOME/mmseqs2/bin:$PATH
export LD_LIBRARY_PATH=$HOME/cuda/lib64:$LD_LIBRARY_PATH
export TORCH_CUDA_ARCH_LIST="8.0;8.6;8.9;9.0"
export XDG_CONFIG_HOME="$HOME"

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

alias pd="~/.local/bin/push \"Run ended!\" \"euler\" -p \"0\""
alias gemini-api="GEMINI_API_KEY=\$GEMINI_API_KEY gemini"

# Skip heavy cluster initialization for Claude Code
# Module loads and conda can hang if cluster services are slow/unresponsive
if [ "$CLAUDE_CODE" != "1" ]; then
    [ -f /etc/profile.d/lmod.sh ] && source /etc/profile.d/lmod.sh
    [ -f /etc/profile.d/module_path.sh ] && source /etc/profile.d/module_path.sh

    module load eth_proxy 2>/dev/null
    module load stack/2024-06 2>/dev/null
    module load gcc/12.2.0 2>/dev/null
    module load cuda/12.8.0 2>/dev/null

    # Starship config switcher: disable git on cluster filesystems
    function set_starship_config() {
        if [[ $PWD == /cluster/* ]]; then
            export STARSHIP_CONFIG=~/.config/starship-nogit.toml
        else
            export STARSHIP_CONFIG=~/.config/starship.toml
        fi
    }
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}set_starship_config"

    # >>> conda initialize >>>
    __conda_setup="$("$HOME/miniforge3/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
            . "$HOME/miniforge3/etc/profile.d/conda.sh"
        else
            export PATH="$HOME/miniforge3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
fi
