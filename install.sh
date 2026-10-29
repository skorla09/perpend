#!/usr/bin/env bash
set -Eeuo pipefail

# Perpend installation script.
# Installs only the runtime configuration files to the Neovim config directory.
# For contributing, clone the full repository instead.

REPO_URL="${REPO_URL:-https://github.com/skorla09/perpend.git}"
APP_NAME="${NVIM_APPNAME:-nvim}"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
NVIM_DIR="${NVIM_DIR:-$CONFIG_HOME/$APP_NAME}"
DATA_DIR="$DATA_HOME/$APP_NAME"
TEMP_DIR=""

say() {
    printf '%s\n' "$*"
}

warn() {
    printf 'Warning: %s\n' "$*" >&2
}

die() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

cleanup() {
    if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}

usage() {
    cat <<'EOF'
Perpend installer

Usage:
  bash install.sh [--help]

Environment:
  NVIM_APPNAME       Neovim app name (default: nvim)
  NVIM_DIR           Install directory (default: $XDG_CONFIG_HOME/nvim)
  REPO_URL           Git repository to clone
  SKIP_BACKUP=1      Remove an existing config without backing it up
  SKIP_NVIM_CHECK=1  Skip the Neovim presence and version check

Perpend supports Linux, macOS, and WSL. Native Windows is not supported by
this bash installer.
EOF
}

check_optional_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        warn "optional dependency not found: $1"
    fi
}

check_neovim() {
    if [[ "${SKIP_NVIM_CHECK:-0}" == "1" ]]; then
        warn "skipping Neovim check (SKIP_NVIM_CHECK=1)"
        return
    fi

    if ! command -v nvim >/dev/null 2>&1; then
        die "Neovim 0.12+ is required but 'nvim' was not found on PATH"
    fi

    local version
    version="$(nvim --version | head -n 1 | awk '{print $2}')"
    version="${version#v}"

    if [[ ! "$version" =~ ^([0-9]+)\.([0-9]+) ]]; then
        die "could not parse the Neovim version: $version"
    fi

    local major="${BASH_REMATCH[1]}"
    local minor="${BASH_REMATCH[2]}"

    if (( major < 0 || (major == 0 && minor < 12) )); then
        die "Neovim 0.12+ is required; found $version"
    fi
}

check_git() {
    if ! command -v git >/dev/null 2>&1; then
        die "git is required"
    fi

    local version
    version="$(git --version | awk '{print $3}')"
    if [[ "$version" =~ ^([0-9]+)\.([0-9]+) ]]; then
        local major="${BASH_REMATCH[1]}"
        local minor="${BASH_REMATCH[2]}"
        if (( major < 2 || (major == 2 && minor < 19) )); then
            warn "git $version is older than 2.19; lazy.nvim partial clones may not work"
        fi
    fi
}

check_platform() {
    local os
    os="$(uname -s)"
    case "$os" in
        Linux|Darwin)
            ;;
        *)
            warn "unsupported platform: $os; Perpend supports Linux, macOS, and WSL"
            ;;
    esac
}

check_optional_dependencies() {
    local command_name

    for command_name in rg fd node npm; do
        check_optional_command "$command_name"
    done

    if ! command -v tar >/dev/null 2>&1; then
        warn "tar not found; Treesitter parsers will not install"
    fi

    if ! command -v curl >/dev/null 2>&1; then
        warn "curl not found; Treesitter parsers will not install"
    fi

    if ! command -v tree-sitter >/dev/null 2>&1; then
        warn "tree-sitter-cli 0.26.1+ not found; Treesitter parsers will not build"
    fi

    if ! command -v cc >/dev/null 2>&1 \
        && ! command -v gcc >/dev/null 2>&1 \
        && ! command -v clang >/dev/null 2>&1; then
        warn "no C compiler found (cc, gcc, or clang); Treesitter parsers may fail to build"
    fi

    for command_name in \
        lua-language-server \
        typescript-language-server \
        vscode-html-language-server \
        vscode-css-language-server; do
        check_optional_command "$command_name"
    done

    for command_name in stylua prettierd prettier eslint_d markdownlint-cli2 shellcheck; do
        check_optional_command "$command_name"
    done

    if [[ "$(uname -s)" == "Darwin" ]]; then
        check_optional_command pbcopy
    elif ! command -v wl-copy >/dev/null 2>&1 \
        && ! command -v xclip >/dev/null 2>&1 \
        && ! command -v xsel >/dev/null 2>&1; then
        warn "no clipboard provider found (wl-copy, xclip, or xsel)"
    fi
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    usage
    exit 0
elif [[ $# -gt 0 ]]; then
    usage >&2
    exit 1
fi

if [[ -z "$NVIM_DIR" || "$NVIM_DIR" == "/" || "$NVIM_DIR" == "$HOME" ]]; then
    die "refusing to install to '$NVIM_DIR'"
fi

trap cleanup EXIT
trap 'code=$?; printf "Error: command failed on line %s (exit %s)\n" "$LINENO" "$code" >&2; exit "$code"' ERR

say "Perpend installer"
say ""

check_platform
check_git
check_neovim
check_optional_dependencies

say "Cloning Perpend..."
TEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/perpend.XXXXXX")"
if ! git clone --depth 1 "$REPO_URL" "$TEMP_DIR/perpend"; then
    die "failed to clone $REPO_URL"
fi

for file in init.lua lua lsp; do
    if [[ ! -e "$TEMP_DIR/perpend/$file" ]]; then
        die "clone is missing expected file: $file"
    fi
done

if [[ -e "$NVIM_DIR" || -L "$NVIM_DIR" ]]; then
    if [[ "${SKIP_BACKUP:-0}" == "1" ]]; then
        say "Removing existing config (SKIP_BACKUP=1): $NVIM_DIR"
        rm -rf "$NVIM_DIR"
    else
        BACKUP="${NVIM_DIR}.bak.$(date +%Y%m%d-%H%M%S)"
        while [[ -e "$BACKUP" || -L "$BACKUP" ]]; do
            BACKUP="${BACKUP}.1"
        done
        say "Backing up existing config to: $BACKUP"
        mv "$NVIM_DIR" "$BACKUP"
    fi
fi

say "Installing to $NVIM_DIR..."
mkdir -p "$NVIM_DIR"
mkdir -p "$DATA_DIR/undo"

cp "$TEMP_DIR/perpend/init.lua" "$NVIM_DIR/"
cp -R "$TEMP_DIR/perpend/lua" "$NVIM_DIR/"
cp -R "$TEMP_DIR/perpend/lsp" "$NVIM_DIR/"

if [[ -f "$TEMP_DIR/perpend/lazy-lock.json" ]]; then
    cp "$TEMP_DIR/perpend/lazy-lock.json" "$NVIM_DIR/"
else
    warn "lazy-lock.json was not found; plugins will resolve to their latest allowed versions"
fi

for file in init.lua lua lsp; do
    if [[ ! -e "$NVIM_DIR/$file" ]]; then
        die "$file was not installed correctly"
    fi
done

say ""
say "Perpend installed successfully in $NVIM_DIR."
say ""
say "Open Neovim to bootstrap plugins:"
say "  nvim"
say ""
say "Then verify the installation with:"
say "  :Lazy"
say "  :checkhealth"
say ""
say "LSP servers must be installed on your \$PATH. Perpend does not use Mason."
