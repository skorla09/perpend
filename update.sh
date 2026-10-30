#!/usr/bin/env bash
set -Eeuo pipefail

# Perpend update script.
# Applies the latest runtime configuration to an existing installation while
# keeping a full backup of the previous configuration.

REPO_URL="${REPO_URL:-https://github.com/skorla09/perpend.git}"
REPO_REF="${REPO_REF:-main}"
APP_NAME="${NVIM_APPNAME:-nvim}"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
NVIM_DIR="${NVIM_DIR:-$CONFIG_HOME/$APP_NAME}"
SOURCE_DIR="${SOURCE_DIR:-}"
SKIP_BACKUP="${SKIP_BACKUP:-0}"
FORCE="${FORCE:-0}"
DRY_RUN=0
TEMP_DIR=""
BACKUP=""

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
Perpend updater

Usage:
  bash update.sh [options]

Options:
  --source DIR       Update from a local Perpend checkout instead of cloning
  --dry-run          Show the files that would change, without writing anything
  --no-backup        Do not back up the existing configuration (dangerous)
  --force            Update even when the target is not a Perpend installation
  --help             Show this help

Environment:
  NVIM_APPNAME       Neovim app name (default: nvim)
  NVIM_DIR           Install directory (default: $XDG_CONFIG_HOME/nvim)
  REPO_URL           Git repository to clone
  REPO_REF           Git branch or tag to update from (default: main)
  SOURCE_DIR         Same as --source
  SKIP_BACKUP=1      Same as --no-backup
  FORCE=1            Same as --force

The updater replaces init.lua, lua/, lsp/, and lazy-lock.json. Other files in
the configuration directory are left untouched. The previous configuration is
backed up to <path>.bak.<timestamp> unless backups are disabled.

Perpend supports Linux, macOS, and WSL. Native Windows is not supported by
this bash updater.
EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --source)
                [[ $# -ge 2 ]] || die "--source requires a directory"
                SOURCE_DIR="$2"
                shift 2
                ;;
            --source=*)
                SOURCE_DIR="${1#*=}"
                shift
                ;;
            --dry-run)
                DRY_RUN=1
                shift
                ;;
            --no-backup|--skip-backup)
                SKIP_BACKUP=1
                shift
                ;;
            --force)
                FORCE=1
                shift
                ;;
            --help|-h)
                usage
                exit 0
                ;;
            *)
                usage >&2
                exit 1
                ;;
        esac
    done
}

check_git() {
    if ! command -v git >/dev/null 2>&1; then
        die "git is required to fetch the latest configuration"
    fi
}

is_perpend_install() {
    [[ -f "$NVIM_DIR/init.lua" && -f "$NVIM_DIR/lua/config/lazy.lua" ]]
}

validate_source() {
    local file

    for file in init.lua lua lsp; do
        if [[ ! -e "$SOURCE_DIR/$file" ]]; then
            die "source is missing expected file: $file"
        fi
    done
}

resolve_source() {
    if [[ -n "$SOURCE_DIR" ]]; then
        [[ -d "$SOURCE_DIR" ]] || die "source directory does not exist: $SOURCE_DIR"
        SOURCE_DIR="$(cd "$SOURCE_DIR" && pwd)"
        say "Using local checkout: $SOURCE_DIR"
        return
    fi

    check_git

    say "Fetching Perpend ($REPO_REF) from $REPO_URL..."
    TEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/perpend.XXXXXX")"
    if ! git clone --depth 1 --branch "$REPO_REF" "$REPO_URL" "$TEMP_DIR/perpend"; then
        die "failed to clone $REPO_URL ($REPO_REF)"
    fi
    SOURCE_DIR="$TEMP_DIR/perpend"
}

check_target() {
    if [[ ! -e "$NVIM_DIR" ]]; then
        die "no configuration found at $NVIM_DIR; run install.sh for a fresh install"
    fi

    if [[ ! -d "$NVIM_DIR" ]]; then
        die "$NVIM_DIR is not a directory; run install.sh for a fresh install"
    fi

    if [[ "$FORCE" == "1" ]]; then
        warn "skipping installation checks (--force)"
        return
    fi

    if [[ -L "$NVIM_DIR" ]]; then
        die "$NVIM_DIR is a symlink; update its target directly or run install.sh"
    fi

    if [[ -d "$NVIM_DIR/.git" ]]; then
        die "$NVIM_DIR is a git clone; update it with: git -C \"$NVIM_DIR\" pull --ff-only"
    fi

    if ! is_perpend_install; then
        die "$NVIM_DIR does not look like a Perpend installation; run install.sh or use --force"
    fi
}

report_changes() {
    local rel
    local found=0

    for rel in init.lua lua lsp lazy-lock.json; do
        if [[ ! -e "$SOURCE_DIR/$rel" ]]; then
            warn "source does not contain $rel; it will be left unchanged"
            continue
        fi

        if [[ ! -e "$NVIM_DIR/$rel" ]]; then
            say "add:    $rel"
            found=1
        elif [[ -d "$SOURCE_DIR/$rel" ]]; then
            if ! diff -rq "$NVIM_DIR/$rel" "$SOURCE_DIR/$rel" 2>/dev/null; then
                found=1
            fi
        elif ! cmp -s "$NVIM_DIR/$rel" "$SOURCE_DIR/$rel"; then
            say "update: $rel"
            found=1
        fi
    done

    if [[ "$found" == "0" ]]; then
        say "Already up to date."
    fi
}

backup_config() {
    if [[ "$SKIP_BACKUP" == "1" ]]; then
        warn "skipping backup (--no-backup)"
        return
    fi

    BACKUP="${NVIM_DIR}.bak.$(date +%Y%m%d-%H%M%S)"
    while [[ -e "$BACKUP" || -L "$BACKUP" ]]; do
        BACKUP="${BACKUP}.1"
    done

    say "Backing up current configuration to: $BACKUP"
    cp -a "$NVIM_DIR" "$BACKUP"
}

sync_path() {
    local rel="$1"
    local src="$SOURCE_DIR/$rel"
    local dst="$NVIM_DIR/$rel"

    if [[ ! -e "$src" ]]; then
        warn "source does not contain $rel; leaving it unchanged"
        return
    fi

    if [[ -d "$src" ]]; then
        rm -rf "$dst"
        cp -R "$src" "$dst"
    else
        cp "$src" "$dst"
    fi
}

apply_update() {
    local rel

    say "Updating $NVIM_DIR..."
    for rel in init.lua lua lsp lazy-lock.json; do
        sync_path "$rel"
    done

    for rel in init.lua lua lsp; do
        if [[ ! -e "$NVIM_DIR/$rel" ]]; then
            die "$rel was not updated correctly"
        fi
    done
}

if [[ -z "$NVIM_DIR" || "$NVIM_DIR" == "/" || "$NVIM_DIR" == "$HOME" ]]; then
    die "refusing to update '$NVIM_DIR'"
fi

trap cleanup EXIT
trap 'code=$?; printf "Error: command failed on line %s (exit %s)\n" "$LINENO" "$code" >&2; exit "$code"' ERR

parse_args "$@"

say "Perpend updater"
say ""

check_target
resolve_source
validate_source

if [[ "$DRY_RUN" == "1" ]]; then
    say ""
    say "Dry run: no files will be written."
    say ""
    report_changes
    exit 0
fi

backup_config
apply_update

say ""
say "Perpend updated successfully in $NVIM_DIR."
if [[ -n "$BACKUP" ]]; then
    say "Previous configuration: $BACKUP"
fi
say ""
say "Open Neovim and let lazy.nvim sync the pinned plugins:"
say "  nvim"
say ""
say "Then verify the installation with:"
say "  :Lazy"
say "  :checkhealth"
