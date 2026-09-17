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

## N-008: Testing framework exclusion — agnostic approach

- **Technology:** neotest, vim-test (evaluated, excluded from default)
- **Version Investigated:** Current mainstream distributions (2026)
- **Perpend Version:** — (not adopted)
- **Source:** Distribution analysis (LazyVim, NvChad, AstroNvim, kickstart.nvim)
- **Finding:** No major Neovim distribution includes a testing framework by default. LazyVim offers neotest as an optional extra via `:LazyExtras`. NvChad and kickstart.nvim do not include testing at all. AstroNvim provides it as an optional community extra.
- **Impact:** Perpend does not include testing plugins. Testing is project-specific and should be configured per-project.
- **Conclusion:** Testing is excluded from Perpend's default plugins. Users can follow integration patterns in `handbook/integration-patterns.md`.
- **Date:** 2026-09-14

---

## N-009: Debugging (DAP) exclusion — workflow-dependent

- **Technology:** nvim-dap, nvim-dap-ui (evaluated, excluded from default)
- **Version Investigated:** Current mainstream distributions (2026)
- **Perpend Version:** — (not adopted)
- **Source:** Distribution analysis (LazyVim, NvChad, AstroNvim, kickstart.nvim)
- **Finding:** Debugging inclusion is split. AstroNvim and LunarVim include DAP by default as "IDE-like" distributions. LazyVim offers it as an optional extra. NvChad does not include it. kickstart.nvim provides a commented-out example. The author of nvim-dap states: "Debug adapter installations are out of scope. It's not the business of an editor plugin to re-invent a package manager."
- **Impact:** Perpend does not include DAP plugins. Many developers debug outside Neovim (print/log statements, VS Code, JetBrains).
- **Conclusion:** Debugging is excluded from Perpend's default plugins. Users can follow integration patterns in `handbook/integration-patterns.md`.
- **Date:** 2026-09-14

---

## N-010: Task runner exclusion — terminal suffices

- **Technology:** overseer.nvim, vim-dispatch (evaluated, excluded from default)
- **Version Investigated:** Current mainstream distributions (2026)
- **Perpend Version:** — (not adopted)
- **Source:** Distribution analysis (LazyVim, NvChad, AstroNvim, kickstart.nvim)
- **Finding:** Task runners are not universally included. LazyVim offers overseer.nvim as an optional extra. NvChad, AstroNvim, and kickstart.nvim do not include task runners by default. Most developers use terminal commands, `:!`, or tmux for task execution.
- **Impact:** Perpend does not include task runner plugins. Terminal commands and `:!` suffice for most users.
- **Conclusion:** Task runners are excluded from Perpend's default plugins. Users can follow integration patterns in `handbook/integration-patterns.md`.
- **Date:** 2026-09-14

---

## N-011: Terminal integration exclusion — documented pattern

- **Technology:** toggleterm.nvim, snacks.nvim (evaluated, excluded from default)
- **Version Investigated:** Current mainstream distributions (2026)
- **Perpend Version:** — (not adopted)
- **Source:** Distribution analysis (LazyVim, NvChad, AstroNvim, kickstart.nvim)
- **Finding:** All major distributions include terminal integration by default. LazyVim uses snacks.nvim. NvChad includes a built-in terminal module. AstroNvim uses toggleterm.nvim. kickstart.nvim provides minimal built-in support.
- **Impact:** Perpend does not include terminal integration plugins. This is a deviation from the ecosystem norm.
- **Conclusion:** Terminal integration is excluded from Perpend's default plugins to maintain minimalism. Users who need it can follow integration patterns in `handbook/integration-patterns.md`.
- **Date:** 2026-09-14

---

## N-012: Session persistence exclusion — documented pattern

- **Technology:** persistence.nvim, resession.nvim (evaluated, excluded from default)
- **Version Investigated:** Current mainstream distributions (2026)
- **Perpend Version:** — (not adopted)
- **Source:** Distribution analysis (LazyVim, NvChad, AstroNvim, kickstart.nvim)
- **Finding:** Session persistence is included by default in LazyVim (persistence.nvim) and AstroNvim (resession.nvim). NvChad and kickstart.nvim do not include it. Project switching (project.nvim) is typically optional.
- **Impact:** Perpend does not include session persistence plugins. Users who frequently switch between projects may miss this feature.
- **Conclusion:** Session persistence is excluded from Perpend's default plugins. Users can follow integration patterns in `handbook/integration-patterns.md`.
- **Date:** 2026-09-14

---

## N-013: Dashboard plugin selection — snacks.nvim vs startup.nvim

- **Technology:** snacks.nvim, startup.nvim (evaluated, snacks.nvim adopted)
- **Version Investigated:** snacks.nvim latest, startup.nvim 502 stars
- **Perpend Version:** — (adopted)
- **Source:** GitHub repository analysis and feature comparison
- **Finding:** snacks.nvim is maintained by folke (lazy.nvim author) with 16k+ stars, MIT license, and active development. startup.nvim has 502 stars, GPL license, and lower adoption. snacks.nvim provides dashboard, notifier, and other UI modules in a single plugin.
- **Impact:** Perpend replaces startup.nvim with snacks.nvim for the dashboard. This provides better maintenance, more features, and consistency with the lazy.nvim ecosystem.
- **Conclusion:** snacks.nvim adopted for dashboard. Decision documented in openspec change `dashboard-replace-startup`.
- **Date:** 2026-09-14

---

## N-014: Statusline enhancement — lualine.nvim configuration

- **Technology:** lualine.nvim
- **Version Investigated:** Current lualine.nvim
- **Perpend Version:** — (adopted)
- **Source:** lualine.nvim documentation and best practices
- **Finding:** Minimal `theme = "auto"` configuration lacks essential developer information. Enhanced configuration with explicit sections, separators, and components provides better visibility into file state, LSP connections, and editing context.
- **Impact:** Perpend enhances lualine.nvim with proper section separators (, ), component separators (, ), and explicit section configuration.
- **Conclusion:** Enhanced lualine.nvim configuration adopted. Decision documented in openspec change `statusline-enhance`.
- **Date:** 2026-09-14

---

## N-015: Notification system — snacks.nvim notifier

- **Technology:** snacks.nvim notifier module
- **Version Investigated:** snacks.nvim latest
- **Perpend Version:** — (adopted)
- **Source:** snacks.nvim documentation and integration patterns
- **Finding:** snacks.nvim provides a built-in notifier module that can be used for LSP progress, plugin notifications, and user messages. It integrates with `vim.notify()` and provides a consistent notification UI.
- **Impact:** Perpend adopts snacks.nvim notifier for LSP progress notifications with LspProgress autocmd. This provides visual feedback for background operations.
- **Conclusion:** snacks.nvim notifier adopted. Decision documented in openspec change `notifications`.
- **Date:** 2026-09-14

---

## N-016: Which-key enablement — keymap discoverability

- **Technology:** which-key.nvim
- **Version Investigated:** which-key.nvim v3
- **Perpend Version:** — (adopted)
- **Source:** which-key.nvim documentation and best practices
- **Finding:** which-key.nvim is configured with groups but keymaps are commented out. Enabling the `<leader>?` keymap provides buffer-local keymap discovery, improving usability for new users.
- **Impact:** Perpend enables the `<leader>?` keymap to show buffer-local keymaps. This helps users discover available keybindings without memorizing them.
- **Conclusion:** which-key keymaps enabled. Decision documented in openspec change `which-key-enable`.
- **Date:** 2026-09-14

---

## N-017: UI consistency — colorscheme switching

- **Technology:** kanagawa.nvim, catppuccin.nvim, tokyonight.nvim
- **Version Investigated:** Current colorscheme plugins
- **Perpend Version:** — (adopted)
- **Source:** Colorscheme plugin documentation and best practices
- **Finding:** Multiple colorschemes are available but not configured consistently. Adding proper configuration and a colorscheme switcher improves user experience and allows easy theme switching.
- **Impact:** Perpend adds colorscheme configuration for all themes and a `<leader>uc` keymap to cycle through them. This provides visual feedback and improves discoverability.
- **Conclusion:** UI consistency adopted with colorscheme switcher. Decision documented in openspec change `ui-consistency`.
- **Date:** 2026-09-14

---

# MAINTAINING THIS CHAPTER

New findings should be appended with a new `N-NNN` number following the format above. When later research corrects an earlier finding, preserve the original note, clearly mark the newer information, and record the relevant version or date. Do not let obsolete knowledge appear as current guidance (`agent-guide.md` section 3.8).