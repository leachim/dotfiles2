#!/usr/bin/env bash
#
# Install GitHub CLI (gh) on Linux using precompiled binaries.
# On macOS, gh is installed via Homebrew (Brewfile), so this is a no-op.

set -e

if [ "$(uname -s)" = "Darwin" ]; then
  echo "  gh: skipping (installed via Homebrew on macOS)"
  exit 0
fi

if command -v gh &> /dev/null; then
  echo "  gh: already installed"
  exit 0
fi

echo "  gh: installing GitHub CLI for Linux (precompiled binary)"

# Install location
GH_INSTALL_DIR="$HOME/.local"
GH_VERSION="2.62.0"  # Update this to the latest version as needed
ARCH=$(uname -m)

# Map architecture names
case "$ARCH" in
  x86_64)
    GH_ARCH="amd64"
    ;;
  aarch64)
    GH_ARCH="arm64"
    ;;
  *)
    echo "  gh: unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# Download and extract
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

echo "  gh: downloading gh_${GH_VERSION}_linux_${GH_ARCH}.tar.gz"
curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_${GH_ARCH}.tar.gz" -o gh.tar.gz

echo "  gh: extracting to $GH_INSTALL_DIR"
tar -xzf gh.tar.gz
mkdir -p "$GH_INSTALL_DIR/bin"
cp "gh_${GH_VERSION}_linux_${GH_ARCH}/bin/gh" "$GH_INSTALL_DIR/bin/"
chmod +x "$GH_INSTALL_DIR/bin/gh"

# Optional: copy man pages and completions
if [ -d "$GH_INSTALL_DIR/share/man/man1" ]; then
  cp "gh_${GH_VERSION}_linux_${GH_ARCH}/share/man/man1/"* "$GH_INSTALL_DIR/share/man/man1/" 2>/dev/null || true
fi

# Cleanup
cd - > /dev/null
rm -rf "$TMP_DIR"

echo "  gh: installed $("$GH_INSTALL_DIR/bin/gh" --version | head -1)"
echo "  gh: make sure $GH_INSTALL_DIR/bin is in your PATH"
