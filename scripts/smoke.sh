#!/usr/bin/env bash
set -euo pipefail

# Perpend startup smoke test.
# Boots the configuration headless and fails if Neovim reports an error.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NVIM="${NVIM:-nvim}"

OUTPUT="$("$NVIM" --headless -u "$REPO_ROOT/init.lua" +qa 2>&1)" || {
    echo "Perpend smoke test FAILED" >&2
    echo "$OUTPUT" >&2
    exit 1
}

if printf '%s\n' "$OUTPUT" | grep -qi 'error\|traceback'; then
    echo "Perpend smoke test FAILED — errors found in output" >&2
    echo "$OUTPUT" >&2
    exit 1
fi

echo "Perpend smoke test passed"