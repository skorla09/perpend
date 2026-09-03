# FOLDER STRUCTURE

> **Establish the reference.**
> **Build with intention.**
> **Leave the workshop better than you found it.**

This chapter explains the repository layout and the responsibility of each location.

The folder structure is a form of architecture: it communicates intent before any file is read. Every directory has a single responsibility, and each file belongs to exactly one of them. If you know which directory handles a concern, you know where its implementation lives.

---

# THE LAYERED MODEL

Perpend follows a four-layer model, each dependent on the ones beneath it:

```
Configuration
     ↓
Plugin Integration
     ↓
Keymaps
     ↓
Implementation
```

The directories mirror the separation:

| Directory  | Responsibility |
| ---------- | -------------- |
| `lua/config/`  | Editor behavior and plugin options |
| `lua/plugins/` | Plugin lifecycle, dependencies, and lazy-loading |
| `lua/keymaps/` | User interactions and shortcuts |
| `docs/`        | Preserved knowledge behind the implementation |
| `lsp/`         | Native LSP per-server configuration |

---

# THE ROOT

- `init.lua` — the single entry point; loads `config.lazy`.
- `lua/config/lazy.lua` — bootstraps lazy.nvim, loads the global config and keymaps, then calls `require("lazy").setup("plugins")`.
- `lazy-lock.json` — pinned plugin versions managed by lazy.nvim.
- `docs/` — the Handbook and Architecture Decision Records.
- `lsp/` — per-server configs for native LSP (`vim.lsp.config()`).
- Root-level scratch files (`*.tsx`, `*.js`, `*.py`, etc.) are not part of the configuration.

---

# LUA/CONFIG/

Editor behavior and plugin options.

| File | Purpose |
| ---- | ------- |
| `options.lua`        | Neovim global options (`vim.opt`) |
| `autocmds.lua`       | Global autocommands |
| `diagnostics.lua`    | Diagnostics presentation (`vim.diagnostic.config`) |
| `lsp.lua`            | Enables LSP servers via `vim.lsp.enable()` |
| `lazy.lua`           | lazy.nvim bootstrap and global requires |
| `keymaps`-adjacent   | — |
| `<plugin>.lua`       | Setup options for a plugin, returned as a table for `opts`/`config()` |

Disabled plugin options are left as commented-out lines with the reason (see `telescope.lua`, `neo-tree.lua`).

---

# LUA/PLUGINS/

One declaration file per plugin, named after the plugin repository (e.g. `telescope.lua`, `gitsigns.lua`, `mini-pairs.lua`).

Each file declares:

- source and version,
- dependencies,
- lazy-loading conditions (events, commands, keys),
- `opts` or `config()`,

and optionally a `keys` field provided by `lua/keymaps/`.

The plugin declaration owns the plugin's *lifecycle*. It does not own configuration data or user-facing behavior.

---

# LUA/KEYMAPS/

Organized by workflow or responsibility, not by plugin (ADR-001).

- `defaults.lua` — leader keys, window navigation, search, save/close.
- `diagnostics/` — diagnostic navigation and listing.
- `language/` — LSP actions and text objects.
- `git/` — gitsigns and fugitive mappings.
- `find/` — telescope mappings.
- `code/` — conform (format) and nvim-lint mappings.
- `explorer/` — neo-tree mappings.
- `init.lua` — loads the global keymap groups.

Plugin-owned keymaps remain with their plugin, returned as the `keys` field (ADR-001), or attached via `on_attach` (e.g. gitsigns).

---

# LSP/

One file per language server, consumed natively by `vim.lsp.config()`.

| File | Server |
| ---- | ------ |
| `lsp/lua_ls.lua` | Lua (`lua-language-server`) |

Remaining servers (`ts_ls`, `html`, `cssls`) use `nvim-lspconfig`'s built-in defaults and therefore have no per-server file.

---

# DOCS/

Preserved knowledge.

- `docs/handbook/` — the Perpend Handbook (philosophy, vision, principles, architecture, roadmap, style guide, folder structure, plugin guidelines, milestones, research notes, agent guide).
- `docs/adr/` — Architecture Decision Records (`NNN-topic.md`).

---

# WHERE DOES X GO?

- A new plugin? → `lua/plugins/<name>.lua`, with `lua/config/<name>.lua` only if it needs options and `lua/keymaps/<path>` only if it has keymaps.
- A new editor option? → `lua/config/options.lua`.
- A new global keymap? → `lua/keymaps/defaults.lua` or the matching workflow group.
- A new LSP server requiring options? → `lsp/<server>.lua`.
- A significant decision? → an ADR.
- Significant findings from research? → `docs/handbook/research-notes.md`.

When a new capability does not fit this layout, that is a signal that the architecture needs to evolve deliberately, not that a file should be placed arbitrarily.