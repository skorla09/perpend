# Perpend — Neovim Configuration Context for AI Agents

> **Establish the reference. Build with intention. Leave the workshop better than you found it.**

Perpend is a Neovim distribution and a software engineering learning project. The editor is the medium; engineering is the objective. Full rationale lives in the [Perpend Handbook](docs/handbook/README.md) and [Architecture Decision Records](docs/adr/).

## How Agents Should Work Here

The authoritative operational rules are in **`docs/handbook/agent-guide.md`** — read it before significant work. Essentials:

- **Establish the reference first.** Search the repo, read docs/ADRs, inspect the implementation, and consult current authoritative external docs before proposing changes. Never assume the roadmap changed or a decision was never made.
- **Source-of-truth order:** current implementation → ADRs → Handbook → external authoritative docs → this file. If sources conflict, stop and investigate.
- **Two passes:** first understand (no modifications), then implement the smallest appropriate change.
- **Milestones:** the roadmap (`docs/handbook/roadmap.md`) is authoritative — **Phase I — Foundation** is complete; **Phase II — Developer Productivity** is complete; **Phase III — User Experience** is current. Never create a competing roadmap or invent project history.
- **Documentation is part of the product:** update affected docs with changes; record significant research in `handbook/research-notes.md` and decisions in ADRs. Every keymap needs a `desc`.
- **Stay in scope:** minimal changes, no silent direction changes; ask when uncertainty is high.

## Overview

- **Project:** Perpend (previously named "NVCode")
- **Neovim:** 0.12.2
- **Plugin Manager:** lazy.nvim (bootstrapped in `lua/config/lazy.lua`)
- **Config Location:** `~/.config/nvim/`
- **No Mason** — LSP servers installed manually on `$PATH`, configured via native `vim.lsp.enable()`

## Architecture

Every plugin follows a **3-file pattern applied as-needed**:

| File                     | Purpose                                                                | Required?                        |
| ------------------------ | ---------------------------------------------------------------------- | -------------------------------- |
| `lua/plugins/<name>.lua` | Plugin declaration — source, version, deps, events, opts, config, keys | Always                           |
| `lua/config/<name>.lua`  | Setup options — returned table consumed by `opts` or `config()`        | Only if the plugin needs options |
| `lua/keymaps/<name>.lua` | Key mappings — returned table for `keys`, or function for `on_attach`  | Only if the plugin has keymaps   |

Create config/keymaps files only when the plugin actually needs them. For example, `mini.pairs` has no keymaps file (handled internally) and no config file (uses defaults).

Disabled config is left in place as commented-out lines with the reason (see neo-tree, telescope, which-key below).

## Entry Point

`init.lua` loads `config.lazy`, which:

1. Sets `vim.g.node_host_prog`, bootstraps lazy.nvim, then loads `config.options`, `keymaps`, `config.autocmds`, `config.diagnostics`
2. Calls `require("lazy").setup("plugins")`
3. LSP servers enabled via the `nvim-lspconfig` plugin (`lazy = false`), which loads `config/lsp.lua` and iterates with `pcall(vim.lsp.enable, ...)`

## Plugins

| Plugin                | Keymaps                               | Config                        | Notes                                                                                                    |
| --------------------- | ------------------------------------- | ----------------------------- | -------------------------------------------------------------------------------------------------------- |
| blink.cmp             | —                                     | `config/blink.lua`            | Completion engine, V1 stable (`version = "1.*"`), `keys` not set (blink handles bindings internally)     |
| conform.nvim          | `keymaps/code/conform.lua`            | `config/conform.lua`          | Formatter, format on save, `<leader>cf` to format                                                        |
| gitsigns.nvim         | `keymaps/git/gitsigns.lua` (on_attach)| `config/gitsigns.lua`         | `lazy = false`, v2.0 on_attach pattern                                                                   |
| telescope.nvim        | `keymaps/find/telescope.lua`          | —                             | `config/telescope.lua` exists but is **disabled** (setup call + fzf extension commented out)             |
| neo-tree.nvim         | `keymaps/explorer/neo-tree.lua`       | —                             | `<leader>e` toggle, `<leader>E` focus; `config/neo-tree.lua` is **disabled** (opts line commented out)    |
| which-key.nvim        | `keymaps/which-key.lua`               | `config/which-key.lua`        | v3 spec format; `<leader>?` shows buffer-local keymaps                                                  |
| nvim-treesitter       | —                                     | `config/treesitter.lua`       | New setup + install API (no `configs.setup()`)                                                           |
| nvim-treesitter-textobjects | `keymaps/language/textobjects.lua` | —                            | Select/move via treesitter queries, `vim.g.no_plugin_maps = true`                                        |
| nvim-ts-autotag       | —                                     | `config/autotag.lua`          | New standalone setup API (opts nested)                                                                   |
| lualine.nvim          | —                                     | `config/lualine.lua`          | Statusline, enhanced with sections and separators                                                        |
| kanagawa.nvim         | —                                     | `config/kanagawa.lua`         | Active colorscheme (dragon), `lazy = false`, `priority = 1000`                                           |
| smear-cursor.nvim     | —                                     | `config/smear-cursor.lua`     | Cursor animation                                                                                         |
| snacks.nvim           | —                                     | `config/dashboard.lua`        | Dashboard + notifier, `lazy = false`, `priority = 1000`                                                  |
| vim-fugitive          | `keymaps/git/fugitive.lua`            | —                             | Git, cmd-triggered (`Git`, `G`, `Gwrite`, ...) + `<leader>gS`                                            |
| nvim-highlight-colors | —                                     | `config/highlight-colors.lua` | Color value highlighting                                                                                 |
| catppuccin.nvim       | —                                     | —                             | Available for switching (`lazy = false`, `priority = 1000`)                                              |
| tokyonight.nvim       | —                                     | —                             | Available for switching (`lazy = false`, `priority = 1000`)                                              |
| mini.pairs            | —                                     | —                             | Auto-pairs, `nvim-mini/mini.pairs`, event-triggered, uses defaults                                       |
| nvim-lint             | `keymaps/code/nvim-lint.lua`          | `config/nvim-lint.lua`        | Linter, triggers on BufWritePost/InsertLeave, all calls wrapped in pcall                                 |
| nvim-lspconfig        | —                                     | `config/lsp.lua`              | `lazy = false`, enables servers via `vim.lsp.enable()` loop, per-server configs in `lsp/*.lua`           |
| lsp-file-operations   | —                                     | —                             | Depends on neo-tree.nvim                                                                                 |
| diagnostics (global)  | `keymaps/diagnostics/init.lua`        | `config/diagnostics.lua`      | `[d`/`]d` navigation, `<leader>df` float, `<leader>dl` loclist                                          |
| defaults (global)     | `keymaps/defaults.lua`                | `config/options.lua`          | Window nav, save/close, search, splits                                                                   |
| LSP (global)          | `keymaps/language/lsp.lua`            | —                             | gd, gD, gr, gi, gt, K, rename, code actions                                                             |

## LSP Configuration

`nvim-lspconfig` is installed as a plugin (`lazy = false`) for utility commands like `:LspInfo`, but server enabling and configuration uses Neovim's native LSP API.

One config file per server in `lsp/` — loaded by Neovim's native LSP system on `vim.lsp.enable()`:

| File             | Server                | Source                                                         |
| ---------------- | --------------------- | -------------------------------------------------------------- |
| `lsp/lua_ls.lua` | Lua                   | `lua-language-server`                                          |

The remaining servers (`ts_ls`, `html`, `cssls`) use nvim-lspconfig's built-in configs.

Servers enabled via `config/lsp.lua` loaded by the `nvim-lspconfig` plugin (`lazy = false`):

```lua
-- lua/config/lsp.lua
local servers = { "lua_ls", "ts_ls", "html", "cssls" }
for _, server in ipairs(servers) do
    pcall(vim.lsp.enable, server)
end
```

## Keymaps (Global)

Loaded by `keymaps/init.lua`: `defaults`, `diagnostics`, `language.lsp`.

**`lua/keymaps/defaults.lua`:**

- `<leader>` = Space
- `<C-h/j/k/l>` = Window navigation
- `<leader>h` = Clear search highlight
- `<leader>w` = Save
- `<leader>q` = Close window
- `<leader>x` = Save and close

**`lua/keymaps/diagnostics/init.lua`:**

- `[d` / `]d` = Previous / Next diagnostic
- `<leader>df` = Float diagnostics
- `<leader>dl` = Diagnostics list

**`lua/keymaps/language/lsp.lua`:** gd, gD, gr, gi, gt, K, `<leader>lr` rename, `<leader>la` code actions.

**Which-key groups** (`config/which-key.lua`): `<leader>g` Git, `<leader>l` Language, `<leader>f` Find, `<leader>c` Code, `<leader>t` Tests, `<leader>b` Buffers, `<leader>e` Explorer.

## Important Conventions

- **Never add mason.nvim, mason-lspconfig.nvim** — servers on `$PATH` only
- **LSP**: Use `vim.lsp.enable()` + `vim.lsp.config()`, NOT `require("lspconfig").X.setup()`
- **nvim-lspconfig**: Installed for utility commands (`:LspInfo`) only — server configs use native `vim.lsp.enable()` + `vim.lsp.config()`, NOT `require("lspconfig").X.setup()`. Per-server configs in `lsp/*.lua` are consumed natively by Neovim 0.12+
- **Gitsigns**: `lazy = false` (must load at startup), keymaps via `on_attach`
- **Treesitter**: Uses new `nvim-treesitter/nvim-treesitter` with `setup()` + `install()` API (no `configs.setup()`)
- **nvim-ts-autotag**: Uses new standalone setup with nested `opts` key
- **lualine**: `theme = "auto"` (auto-detects colorscheme)
- **lsp-file-operations**: Must list neo-tree as dependency for correct loading order
- **vim-fugitive**: cmd-triggered, lazyloaded via keys
- **vim-oscyank**: REMOVED (Neovim 0.10+ has native OSC52)
- **blink.cmp**: `keys` field NOT set — blink handles keybindings internally via `keymap.preset`; setting `keys` breaks lazy loading
- **nvim-lint**: Uses `pcall(lint.try_lint)` in autocmds to prevent missing linters from crashing other plugins — triggers on BufWritePost/InsertLeave
- **Keymaps**: every mapping includes a descriptive `desc` for discoverability and Which-key integration (ADR-001)
- **Dead config**: disabled/experimental config stays as commented-out lines with an explanatory note (neo-tree opts, telescope setup, which-key keys)
- **Decisions**: significant architectural decisions go in `docs/adr/`; engineering rationale in the Handbook; research findings in `handbook/research-notes.md`
- **Node.js**: `vim.g.node_host_prog` set inline in `lua/config/lazy.lua`. A standalone Node.js path management utility (`lua/config/nodejs.lua`) exists but is not loaded by default — available for manual use or future integration

## File Structure

```
~/.config/nvim/
├── init.lua
├── lazy-lock.json
├── AGENTS.md
├── docs/
│   ├── adr/
│   │   ├── 001-keymap-architecture.md
│   │   ├── 002-plugin-configuration.md
│   │   ├── 003-treesitter-subsystem.md
│   │   └── 004-native-lsp-no-mason.md
│   └── handbook/
│       ├── agent-guide.md
│       ├── architecture.md
│       ├── folder-structure.md
│       ├── milestones.md
│       ├── philosophy.md
│       ├── plugin-guidelines.md
│       ├── principles.md
│       ├── README.md
│       ├── research-notes.md
│       ├── roadmap.md
│       ├── style-guide.md
│       └── vision.md
├── lsp/
│   └── lua_ls.lua
├── lua/
│   ├── config/
│   │   ├── autocmds.lua
│   │   ├── autotag.lua
│   │   ├── blink.lua
│   │   ├── colorschemes.lua
│   │   ├── conform.lua
│   │   ├── dashboard.lua
│   │   ├── diagnostics.lua
│   │   ├── gitsigns.lua
│   │   ├── highlight-colors.lua
│   │   ├── kanagawa.lua
│   │   ├── lazy.lua
│   │   ├── lsp.lua
│   │   ├── lualine.lua
│   │   ├── neo-tree.lua
│   │   ├── nodejs.lua
│   │   ├── nvim-lint.lua
│   │   ├── options.lua
│   │   ├── smear-cursor.lua
│   │   ├── telescope.lua
│   │   ├── treesitter.lua
│   │   └── which-key.lua
│   ├── keymaps/
│   │   ├── code/
│   │   │   ├── conform.lua
│   │   │   └── nvim-lint.lua
│   │   ├── diagnostics/
│   │   │   └── init.lua
│   │   ├── explorer/
│   │   │   └── neo-tree.lua
│   │   ├── find/
│   │   │   └── telescope.lua
│   │   ├── git/
│   │   │   ├── fugitive.lua
│   │   │   └── gitsigns.lua
│   │   ├── language/
│   │   │   ├── lsp.lua
│   │   │   └── textobjects.lua
│   │   ├── defaults.lua
│   │   ├── init.lua
│   │   ├── ui.lua
│   │   └── which-key.lua
│   └── plugins/
│       ├── autotag.lua
│       ├── blink.lua
│       ├── catppuccin.lua
│       ├── conform.lua
│       ├── dashboard.lua
│       ├── fugitive.lua
│       ├── gitsigns.lua
│       ├── highlight-colors.lua
│       ├── kanagawa.lua
│       ├── lsp-file-operations.lua
│       ├── lsp.lua
│       ├── lualine.lua
│       ├── mini-pairs.lua
│       ├── neo-tree.lua
│       ├── nvim-lint.lua
│       ├── smear_cursor.lua
│       ├── startup.lua (disabled)
│       ├── telescope.lua
│       ├── tokyonight.lua
│       ├── treesitter-textobjects.lua
│       ├── treesitter.lua
│       └── which-key.lua
```

> Root-level scratch files (`*.tsx`, `*.js`, `*.py`, `ripple.html`, `tsconfig.json`, etc.) are not part of the config.
