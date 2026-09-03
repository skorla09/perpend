# RESEARCH NOTES

> **Establish the reference.**
> **Build with intention.**
> **Leave the workshop better than you found it.**

This chapter records what Perpend learned through investigation.

Research Notes preserve *knowledge*: technology evaluations, plugin investigations, version differences, API changes, rejected alternatives, and lessons learned from authoritative documentation. Architecture Decision Records preserve *decisions*. A research investigation may lead to an ADR, but the two documents serve different purposes (`agent-guide.md` section 3).

Each note identifies the relevant version, source, and date so that another engineer can trace where a conclusion came from.

---

# NOTES

## N-001: Native LSP configuration in Neovim

- **Technology:** Neovim native LSP
- **Version Investigated:** Neovim 0.12.2
- **Perpend Version:** Neovim 0.12.2
- **Source:** Neovim documentation and running implementation
- **Finding:** `vim.lsp.enable()` enables a server from the default config, and `vim.lsp.config()` provides per-server configuration consumed natively. This removes the need for `nvim-lspconfig`'s `require("lspconfig").X.setup()` pattern for enabling and configuration.
- **Impact:** Perpend enables servers via `config/lsp.lua` iterating `pcall(vim.lsp.enable, server)` and stores per-server options in `lsp/:lua_ls.lua`. `nvim-lspconfig` is installed (`lazy = false`) only for utility commands like `:LspInfo`.
- **Conclusion:** Sticking with the native API is recommended. Decision recorded in `ADR-004`.
- **Date:** 2026-08-19

---

## N-002: No Mason — servers on `$PATH`

- **Technology:** mason.nvim / mason-lspconfig.nvim (evaluated, rejected)
- **Version Investigated:** Current mainstream guidance as of investigation
- **Perpend Version:** — (not adopted)
- **Source:** Project conventions documented in `AGENTS.md`
- **Finding:** Manager-managed server installation adds a dependency and an abstraction layer without owning real behavior. LSP servers installed manually on `$PATH` behave like any other system tool and avoid plugin-managed version drift.
- **Impact:** Perpend does not use Mason. This is a hard constraint for contributors.
- **Conclusion:** No change; the decision is recorded in `ADR-004`.
- **Date:** 2026-08-19

---

## N-003: New nvim-treesitter setup and install API

- **Technology:** nvim-treesitter
- **Version Investigated:** `main` branch (commit `61df8498` per `lazy-lock.json`)
- **Perpend Version:** same
- **Source:** Official repository `nvim-treesitter/nvim-treesitter`
- **Finding:** The modern API uses `setup()` plus `install()`; the legacy `require("nvim-treesitter.configs").setup()` (`configs.setup()`) is replaced.
- **Impact:** Perpend's `config/treesitter.lua` lists parsers and is consumed by the new API. No legacy `configs.setup()` call.
- **Conclusion:** Continue with the new API. Architectural model documented in `ADR-003`.
- **Date:** 2026-08-19

---

## N-004: blink.cmp internal keybindings and lazy loading

- **Technology:** blink.cmp (completion)
- **Version Investigated:** V1 series (`version = "1.*"`), `main` commit `78336bc8`
- **Perpend Version:** same
- **Source:** Official repository `Saghen/blink.cmp`, project repository inspection
- **Finding:** blink.cmp handles keybindings internally via `keymap.preset`. Setting a plugin-level `keys` field in the Lazy spec interferes with lazy loading.
- **Impact:** Perpend does not define a `keys` field for blink.cmp; bindings are configured through `config/blink.lua`.
- **Conclusion:** Keep `keys` unset for blink.cmp. Stated in `AGENTS.md` conventions.
- **Date:** 2026-08-19

---

## N-005: nvim-lint resilience with missing linters

- **Technology:** nvim-lint
- **Version Investigated:** `master` commit `a219b2c9`
- **Perpend Version:** same
- **Source:** Official repository `mfussenegger/nvim-lint`, running implementation
- **Finding:** Calling `lint.try_lint` can fail when the expected linter binary is missing. Wrapping calls in `pcall` prevents a missing linter from crashing unrelated plugins on BufWritePost/InsertLeave.
- **Impact:** Perpend wraps all `lint.try_lint` calls in `pcall`; the manual lint keymap (`keymaps/code/nvim-lint.lua`) does the same and notifies on completion.
- **Conclusion:** Keep the `pcall` pattern.
- **Date:** 2026-08-19

---

## N-006: Dead config convention

- **Technology:** Configuration discipline (non-technical practice)
- **Perpend Version:** current
- **Source:** Project conventions documented in `AGENTS.md`
- **Finding:** Disabled or experimental configuration kept as commented-out lines with an explanatory note preserves context and makes re-enabling intentional. Examples: `config/telescope.lua` (setup + fzf extension commented out), `config/neo-tree.lua` (`opts` commented out), `plugins/which-key.lua` (`keys` commented out).
- **Impact:** Contributors find rejected or deferred options next to their decision instead of lost to history.
- **Conclusion:** Keep the convention; captured in `plugin-guidelines.md`.
- **Date:** 2026-08-19

---

## N-007: vim-oscyank removal — native OSC52

- **Technology:** vim-oscyank (removed)
- **Version Investigated:** end-of-life for Perpend purposes
- **Perpend Version:** — (not installed)
- **Source:** Neovim release notes (OSC52 support in Neovim 0.10+)
- **Finding:** Neovim 0.10+ has native OSC52 support for copy-to-clipboard over SSH; the plugin provided no capability Neovim core lacked.
- **Impact:** Plugin removed from Perpend; no replacement configured.
- **Conclusion:** Removal was correct; documented in `AGENTS.md`.
- **Date:** 2026-08-19

---

# MAINTAINING THIS CHAPTER

New findings should be appended with a new `N-NNN` number following the format above. When later research corrects an earlier finding, preserve the original note, clearly mark the newer information, and record the relevant version or date. Do not let obsolete knowledge appear as current guidance (`agent-guide.md` section 3.8).