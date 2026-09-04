#!/usr/bin/env bash
set -euo pipefail

# Perpend installation script.
# Installs only the runtime configuration files to ~/.config/nvim.
# For contributing, clone the full repository instead.

REPO_URL="${REPO_URL:-https://github.com/skorla09/perpend.git}"
NVIM_DIR="${NVIM_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/nvim}"
TEMP_DIR=""

cleanup() {
    if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT

echo "Perpend installer"
echo ""

# Check dependencies
if ! command -v git &> /dev/null; then
    echo "Error: git is required" >&2
    exit 1
fi

if ! command -v nvim &> /dev/null; then
    echo "Warning: nvim not found in PATH" >&2
    echo "Install Neovim 0.12+ before using Perpend" >&2
fi

# Clone to temp directory first (before any destructive operations)
echo "Cloning Perpend..."
TEMP_DIR=$(mktemp -d)
if ! git clone --depth 1 "$REPO_URL" "$TEMP_DIR/perpend" 2>/dev/null; then
    echo "Error: failed to clone $REPO_URL" >&2
    echo "Check your network connection and the repository URL" >&2
    exit 1
fi

# Validate clone produced expected files
for f in init.lua lua lsp; do
    if [[ ! -e "$TEMP_DIR/perpend/$f" ]]; then
        echo "Error: clone missing expected file: $f" >&2
        exit 1
    fi
done

# Handle existing config
if [[ -L "$NVIM_DIR" ]]; then
    echo "Warning: $NVIM_DIR is a symlink" >&2
    echo "Target: $(readlink "$NVIM_DIR")" >&2
    echo "The symlink will be replaced with a directory" >&2
    rm "$NVIM_DIR"
elif [[ -d "$NVIM_DIR" ]]; then
    if [[ "${SKIP_BACKUP:-}" == "1" ]]; then
        echo "Skipping backup (SKIP_BACKUP=1)"
        rm -rf "$NVIM_DIR"
    else
        BACKUP="${NVIM_DIR}.bak.$(date +%s)"
        echo "Backing up existing config to: $BACKUP"
        mv "$NVIM_DIR" "$BACKUP"
    fi
fi

# Install runtime files
echo "Installing to $NVIM_DIR..."
mkdir -p "$NVIM_DIR"

cp "$TEMP_DIR/perpend/init.lua" "$NVIM_DIR/"
cp "$TEMP_DIR/perpend/lazy-lock.json" "$NVIM_DIR/"
cp -r "$TEMP_DIR/perpend/lua" "$NVIM_DIR/"
cp -r "$TEMP_DIR/perpend/lsp" "$NVIM_DIR/"

# Verify installation
for f in init.lua lua lsp; do
    if [[ ! -e "$NVIM_DIR/$f" ]]; then
        echo "Error: $f was not installed correctly" >&2
        exit 1
    fi
done

echo ""
echo "Perpend installed successfully."
echo ""
echo "Open Neovim to bootstrap plugins:"
echo "  nvim"
echo ""
echo "LSP servers must be installed on your \$PATH."
echo "Perpend does not use Mason."
