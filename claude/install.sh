#!/bin/sh
#
# Claude Code configuration
#
# Symlinks CLAUDE.md, settings.json, and asset directories into ~/.claude/
# Backs up existing files/directories to $BACKUP_DIR or ~/.claude/*.backup

CLAUDE_DIR="$HOME/.claude"
DOTFILES_CLAUDE="$HOME/.dotfiles/claude"

mkdir -p "$CLAUDE_DIR"

backup_claude_item () {
    local item=$1
    if [ -n "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR/claude"
        mv "$item" "$BACKUP_DIR/claude/$(basename "$item")"
        echo "  Backed up $item to $BACKUP_DIR/claude/"
    else
        mv "$item" "${item}.backup"
        echo "  Backed up $item to ${item}.backup"
    fi
}

# Symlink files
for file in CLAUDE.md settings.json; do
    src="$DOTFILES_CLAUDE/$file"
    dst="$CLAUDE_DIR/$file"

    if [ ! -f "$src" ]; then
        continue
    fi

    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -f "$dst" ]; then
        backup_claude_item "$dst"
    fi

    ln -s "$src" "$dst"
    echo "  Linked $src -> $dst"
done

# Symlink directories (commands, agents, skills)
for dir in commands agents skills; do
    src="$DOTFILES_CLAUDE/$dir"
    dst="$CLAUDE_DIR/$dir"

    if [ ! -d "$src" ]; then
        continue
    fi

    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -d "$dst" ]; then
        backup_claude_item "$dst"
    fi

    ln -s "$src" "$dst"
    echo "  Linked $src -> $dst"
done
