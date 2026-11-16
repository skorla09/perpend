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
- **Version Investigated:** `main` branch (commit `a2f69447` per `lazy-lock.json`; the original investigation used `61df8498`)
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
- **Version Investigated:** `master` commit `52107ce2` per `lazy-lock.json` (the original investigation used `a219b2c9`)
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
  - **Update (2026-11-16):** The telescope example is obsolete — `config/telescope.lua` is now wired through `opts`; only the optional fzf sorter remains commented out. See N-023.
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

## N-018: nvim-treesitter `main` does not enable highlighting

- **Technology:** nvim-treesitter
- **Version Investigated:** `main` branch (commit `a2f69447` per `lazy-lock.json`)
- **Perpend Version:** same
- **Source:** Official repository `nvim-treesitter/nvim-treesitter` README; Neovim `:help treesitter` (`vim.treesitter.start()`)
- **Finding:** The `main` rewrite installs parsers and ships queries but does not enable Treesitter features automatically. Highlighting is started by the consumer — either an ftplugin or a `FileType` autocommand calling `vim.treesitter.start()`. Neovim core only does this for a small number of filetypes (for example Lua).
- **Impact:** Without an explicit consumer, JavaScript, TypeScript, HTML, CSS, JSON, YAML, Markdown, and shell fall back to regex syntax. Perpend now starts highlighting from a `FileType` autocommand in `config/autocmds.lua`, wrapped in `pcall` so filetypes without a parser stay quiet.
- **Conclusion:** Highlighting remains a consumer responsibility per `ADR-003`; the provider (`config/treesitter.lua`) continues to own parsers only.
- **Date:** 2026-10-29

---

## N-019: lazy.nvim evaluates `keys` when it loads the spec

- **Technology:** lazy.nvim
- **Version Investigated:** `main` commit `85c7ff37` per `lazy-lock.json`
- **Perpend Version:** same
- **Source:** `lazy/core/plugin.lua` and `lazy/core/loader.lua` in the official repository; observed startup failure
- **Finding:** lazy.nvim reads each spec's `keys` table while loading plugin specifications at startup, so any module required at the top of a keymaps file is loaded immediately. Requiring `telescope.builtin` at module scope defeated Telescope's lazy-loading and produced a `loop or previous error loading module 'keymaps.find.telescope'` failure.
- **Impact:** Perpend requires plugin modules inside the keymap callbacks instead of at file scope. The same rule applies to any lazy-loaded plugin whose mappings are returned through `keys`.
- **Conclusion:** Keep plugin requires inside callbacks for lazy-loaded plugins; this preserves startup cost and avoids module-loading cycles.
- **Date:** 2026-10-29

---

## N-020: nvim-ts-autotag setup API and `opts` contract

- **Technology:** nvim-ts-autotag
- **Version Investigated:** `main` commit `d7220b55` per `lazy-lock.json`
- **Perpend Version:** same
- **Source:** Official repository `windwp/nvim-ts-autotag` README
- **Finding:** The current setup call is `require("nvim-ts-autotag").setup({ opts = { ... } })`. The options (`enable_close`, `enable_rename`, `enable_close_on_slash`) live in a nested `opts` table; `per_filetype` overrides are optional.
- **Impact:** Perpend's `config/autotag.lua` returns `{ opts = { ... } }` so the Lazy `opts` field passes the nested table the plugin expects. The earlier file returned nothing, which silently disabled the contract.
- **Conclusion:** Keep the nested `opts` table and state the defaults explicitly so behavior is reviewable.
- **Date:** 2026-10-29

---

## N-021: Neovim 0.12 default LSP keymaps

- **Technology:** Neovim native LSP
- **Version Investigated:** Neovim 0.12.2
- **Perpend Version:** same
- **Source:** `:help lsp-defaults` and `runtime/doc/news.txt` in Neovim `v0.12.2`
- **Finding:** Neovim 0.12 creates the `gr` LSP prefix unconditionally: `gra` (code action), `gri` (implementation), `grn` (rename), `grr` (references), `grt` (type definition), `grx` (codelens). `gO` maps to document symbols. `K` is mapped to hover unless `keywordprg` is customized or a custom `K` keymap exists.
- **Impact:** Perpend previously defined `gr`, `gi`, and `gt`, which shadowed core behavior (`gi` insert-at-last-position, `gt` next tabpage, and the native `gr*` prefix). Those overrides were removed. The explicit `K` mapping was also removed because it would suppress Neovim's buffer-local hover mapping. `gd` and `gD` remain because Neovim has no default LSP equivalent, and `<leader>lr` / `<leader>la` provide discoverable aliases without shadowing.
- **Conclusion:** Prefer Neovim defaults for LSP navigation; add leader aliases only where they improve discoverability.
- **Date:** 2026-10-29

---

## N-022: TypeScript language server — `vtsls` vs `ts_ls` vs `tsc`

- **Technology:** TypeScript language servers (`vtsls`, `typescript-language-server`/`ts_ls`, `tsc --lsp`)
- **Version Investigated:** `vtsls` current npm release; `typescript-language-server` current; TypeScript 7.0.2; Neovim 0.12.6; `nvim-lspconfig` commit `4b2b045b`
- **Perpend Version:** — (adopted `vtsls`)
- **Source:** `yioneko/vtsls` and `typescript-language-server/typescript-language-server` READMEs; Microsoft TypeScript 7 announcement; `nvim-lspconfig` server configs for `vtsls`, `ts_ls`, and `vue_ls`; local headless verification
- **Finding:**
  - `vtsls` is a community project by `yioneko` that wraps Microsoft's VS Code TypeScript extension (`extensions/typescript-language-features`). Its README calls it a "best-effort product" that may be "not as reliable as other functionally identical alternatives."
  - `typescript-language-server` (`ts_ls`) is also community-maintained and states it is "not directly associated with Microsoft."
  - `tsc` is Microsoft's official TypeScript 7 language server (`tsc --lsp --stdio`), supported by `nvim-lspconfig`'s `tsc` config. It was verified locally: it attaches and exposes completion, hover, rename, code actions, inlay hints, semantic tokens, formatting, definition, and references.
  - TypeScript 7 has no stable programmatic API, so Vue, Svelte, Astro, MDX, and Angular editor workflows still need TypeScript 6. `nvim-lspconfig`'s `vue_ls` forwards TypeScript requests only to `ts_ls`, `vtsls`, or `typescript-tools` — not `tsc`.
  - Neovim ecosystem default: LazyVim uses `vtsls` and offers `tsc` as a newer extra.
- **Impact:** Perpend enables `vtsls` for TypeScript/TSX. The LSP choice does not affect compilation (`tsc` remains the compiler) or formatting (`conform.nvim`). Framework servers are deferred to Phase IV (see `docs/handbook/roadmap.md`).
- **Conclusion:** Keep `vtsls` as the default because it is the only TypeScript client `vue_ls` can use today, and Perpend's goal is to handle any JS framework. Document `tsc` as an opt-in for plain TypeScript/React projects. Revisit if `vtsls` becomes unmaintained or a TypeScript release restores embedded-language support.
- **Date:** 2026-11-14

---

## N-023: Telescope configuration — `opts` contract and fzf-native under lazy.nvim

- **Technology:** telescope.nvim, telescope-fzf-native.nvim, lazy.nvim
- **Version Investigated:** telescope.nvim `v0.2.2` (`5255aa27`), telescope-fzf-native.nvim `main` (last push 2026-05-06), lazy.nvim `main` (`306a0552`), Neovim 0.12.6 (LuaJIT)
- **Perpend Version:** Neovim 0.12.2–0.12.6 with the same plugin commits
- **Source:** telescope.nvim `README.md` at `v0.2.2` and on `master`, telescope-fzf-native.nvim `README.md`, lazy.nvim plugin-spec documentation, and headless verification against the installed plugins
- **Finding:**
  - The `README.md` shipped with `v0.2.2` requires Neovim > 0.10.4 compiled with LuaJIT; `master` raises that floor to >= 0.11.7. No Neovim 0.12-specific setup API exists: `require("telescope").setup(opts)` remains the entry point and only forwards `defaults`, `pickers`, and `extensions` to `telescope.config`.
  - lazy.nvim treats `opts` as implying the default `config`, which calls `require(MAIN).setup(opts)`. A hand-written `config` replaces that default, so `setup(opts)` must then be called manually — mixing both paths invites double setup with divergent tables.
  - The previous `opts = {}` made lazy.nvim call `setup({})`, leaving `config/telescope.lua` unread: `telescope.config.values.mappings.i` stayed empty. Passing the module instead (`opts = require("config.telescope")`) yields `<C-j>`/`<C-k>` = `move_selection_next`/`move_selection_previous`, verified after loading the spec through `require("lazy").load()`.
  - telescope-fzf-native.nvim is optional and must be compiled at install time with `make` or CMake; upstream ships no binaries. `require("telescope").load_extension("fzf")` raises `'fzf' extension doesn't exist or isn't installed` when the dependency is absent, and the `extensions.fzf` table passed to `setup()` is inert until the extension is loaded.
  - `:Telescope` is created in the plugin's own `plugin/telescope.lua`, so it exists only after the plugin loads. With the spec lazy-loaded through `keys` alone, the snacks dashboard actions (`:Telescope find_files`, `:Telescope oldfiles`, `:Telescope live_grep`, `:Telescope buffers`) failed on a fresh session with `E492: Not an editor command: Telescope find_files`; pressing `<leader>ff` once made them work.
  - Telescope's `:checkhealth` passes on this machine with plenary, ripgrep 15.2.0, and fd 10.5.0 detected; `find_files` opens and lists results on Neovim 0.12.6.
- **Impact:** Perpend wires the existing `config/telescope.lua` through `opts`, adds `cmd = "Telescope"` so the dashboard's ex-command actions work on a fresh session, and keeps the optional fzf-native sorter commented out with its reason. Enabling it would add a `make` + C compiler requirement to every install, conflicting with the portable install workflow; if it is enabled later, it needs `build = "make"` plus a `pcall`-guarded `load_extension("fzf")` so a missing build degrades to the Lua sorter instead of erroring on every picker.
- **Conclusion:** Telescope is required by `keymaps/find/telescope.lua` (the only picker in Perpend) and is still maintained. Configure it through `opts`, not a hand-written `config` that re-calls `setup()`. Revisit fzf-native only if fuzzy-match throughput becomes a measured problem. Supersedes the telescope example in N-006.
- **Date:** 2026-11-16

---

# MAINTAINING THIS CHAPTER

New findings should be appended with a new `N-NNN` number following the format above. When later research corrects an earlier finding, preserve the original note, clearly mark the newer information, and record the relevant version or date. Do not let obsolete knowledge appear as current guidance (`agent-guide.md` section 3.8).