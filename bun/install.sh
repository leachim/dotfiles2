#!/bin/sh
#
# Bun runtime + global packages

# Check if bun is already installed
if command -v bun >/dev/null 2>&1; then
  echo "  bun: already installed ($(bun --version))"
else
  echo "  bun: installing"
  curl -fsSL https://bun.sh/install | bash
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

# Global packages from packages.txt
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
while IFS= read -r pkg || [ -n "$pkg" ]; do
  [ -z "$pkg" ] && continue
  name=$(echo "$pkg" | sed 's|.*/||')
  if command -v "$name" >/dev/null 2>&1; then
    echo "  $name: already installed"
  else
    echo "  $name: installing globally"
    bun install -g "$pkg"
  fi
done < "$SCRIPT_DIR/packages.txt"

exit 0
