# Pipe my public key to my clipboard.
if [[ "$OSTYPE" == darwin* ]]; then
  alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
fi
