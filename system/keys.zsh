# Pipe a public key to the clipboard.
#
# Keys here are named per purpose (mac-1-github.pub, cscs-key-*.pub, ...) rather
# than the conventional id_*, so this takes an optional name and otherwise shows
# what is available instead of guessing.
#
#   pubkey                 # conventional key if present, else list choices
#   pubkey mac-1-github    # ~/.ssh/mac-1-github.pub
#
# Only ever resolves to a .pub path, and verifies the contents look like a public
# key before copying: a bare name like `mac-1-github` matches the PRIVATE key
# sitting next to the public one, and copying that to the pasteboard would leak it.
if [[ "$OSTYPE" == darwin* ]]; then
  pubkey() {
    local key

    _pubkey_copy() {
      local f=$1
      # A public key is one line starting with its type. Anything else -- above
      # all "-----BEGIN OPENSSH PRIVATE KEY-----" -- must never reach pbcopy.
      if ! head -1 "$f" | grep -qE '^(ssh-|ecdsa-|sk-)'; then
        echo "pubkey: $f is not a public key -- refusing to copy" >&2
        return 1
      fi
      pbcopy < "$f"
      echo "=> ${f:t} copied to pasteboard."
    }

    if [ -n "$1" ]; then
      # Resolve only to .pub paths, never to a bare private-key name.
      for key in "${1%.pub}.pub" "$HOME/.ssh/${${1:t}%.pub}.pub"; do
        [[ "$key" == *.pub ]] || continue
        [ -f "$key" ] && { _pubkey_copy "$key"; return $?; }
      done
      echo "pubkey: no public key matching '$1'" >&2
      return 1
    fi

    for key in ~/.ssh/id_ed25519.pub ~/.ssh/id_ecdsa.pub ~/.ssh/id_rsa.pub; do
      [ -f "$key" ] && { _pubkey_copy "$key"; return $?; }
    done

    echo "pubkey: no conventional key found; pass one of:" >&2
    print -l -- ${${(f)"$(print -l ~/.ssh/*.pub(N))"}:t:r} >&2
    return 1
  }
fi
