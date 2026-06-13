#!/bin/sh
#
# opencode — symlink safe global configuration
#
# opencode reads its global config from $XDG_CONFIG_HOME/opencode (default
# ~/.config/opencode). Auth tokens live in ~/.local/share/opencode/auth.json
# and are intentionally NOT tracked.
#
# Backs up existing files/directories to $BACKUP_DIR or ~/.config/opencode/*.backup

OPENCODE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
DOTFILES_OPENCODE="$HOME/.dotfiles/opencode"

mkdir -p "$OPENCODE_DIR"

backup_opencode_item () {
    local item=$1
    if [ -n "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR/opencode"
        mv "$item" "$BACKUP_DIR/opencode/$(basename "$item")"
        echo "  Backed up $item to $BACKUP_DIR/opencode/"
    else
        mv "$item" "${item}.backup"
        echo "  Backed up $item to ${item}.backup"
    fi
}

# Symlink files (track only stable, non-secret config)
for file in opencode.jsonc; do
    src="$DOTFILES_OPENCODE/$file"
    dst="$OPENCODE_DIR/$file"

    if [ ! -f "$src" ]; then
        continue
    fi

    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -f "$dst" ]; then
        backup_opencode_item "$dst"
    fi

    ln -s "$src" "$dst"
    echo "  Linked $src -> $dst"
done
