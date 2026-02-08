# GRC colorizes nifty unix tools all over the place
if (( $+commands[grc] )) && (( $+commands[brew] ))
then
  local _grc_conf="$(brew --prefix)/etc/grc.zsh"
  [ -f "$_grc_conf" ] && source "$_grc_conf"
fi
