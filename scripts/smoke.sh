#!/usr/bin/env bash
set -euo pipefail

# Perpend startup smoke test.
# Boots the configuration headless and fails if Neovim reports an error.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NVIM="${NVIM:-nvim}"

# `-u` does not add the repository to the runtime path or to `package.path`.
# Do both explicitly so the test exercises the working tree rather than an
# installed copy at `stdpath("config")`.
OUTPUT="$(
    PERPEND_ROOT="$REPO_ROOT" "$NVIM" --headless \
        --cmd "lua local root = vim.env.PERPEND_ROOT; vim.opt.rtp:prepend(root); package.path = root .. '/lua/?.lua;' .. root .. '/lua/?/init.lua;' .. package.path" \
        -u "$REPO_ROOT/init.lua" +qa 2>&1
)" || {
    echo "Perpend smoke test FAILED" >&2
    echo "$OUTPUT" >&2
    exit 1
}

# `grep -E` keeps the alternation portable across GNU and BSD grep.
if printf '%s\n' "$OUTPUT" | grep -Eqi 'error|traceback'; then
    echo "Perpend smoke test FAILED — errors found in output" >&2
    echo "$OUTPUT" >&2
    exit 1
fi

echo "Perpend smoke test passed"
