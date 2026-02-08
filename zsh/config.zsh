export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

fpath=($DOTFILES/functions $fpath)

autoload -U $DOTFILES/functions/*(:t)

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# You may need to manually set your language environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
# share history between terminals
#unsetopt share_history
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF
setopt APPEND_HISTORY # adds history

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

setopt interactive_comments hist_ignore_dups  octal_zeroes   no_prompt_cr
setopt no_hist_no_functions no_always_to_end  append_history list_packed
setopt inc_append_history   complete_in_word  auto_pushd     complete_aliases
setopt pushd_ignore_dups    no_glob_complete  no_glob_dots   c_bases
setopt numeric_glob_sort    no_share_history  promptsubst    auto_cd
setopt rc_quotes            extendedglob      notify
setopt IGNORE_EOF

# improvements to history handling
setopt extendedhistory histexpiredupsfirst histverify
setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS INC_APPEND_HISTORY
setopt histignorespace
# cd
setopt autocd autonamedirs autopushd pushdsilent pushdignoredups cdablevars
# ignore ctrl-d command to close terminal
setopt ignoreeof nolistambiguous prompt_subst nobeep
# job
setopt nohup nocheckjobs nobgnice

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^?' backward-delete-char
