# Perpend

> Establish the reference. Build with intention. Leave the workshop better than you found it.

Perpend is a Neovim distribution built as a software engineering learning project.

The editor is the medium. Engineering is the objective.

---

## Why Perpend Exists

Every project begins with a question.

Perpend began with this one:

> How difficult would it be to build a Neovim configuration that feels like a professional code editor?

As the project evolved, another question emerged:

> Can a Neovim configuration teach software engineering by the way it is built?

That question became the foundation of Perpend.

There are many excellent Neovim configurations. Many provide outstanding defaults, powerful workflows, and impressive collections of plugins. Perpend does not exist to compete with them. It exists to demonstrate a different idea:

That software can be engineered in a way that is intentionally understandable.

---

## What Makes It Different

- **Documentation is part of the product.** Every architectural decision is recorded. Every design choice has a rationale. The Handbook explains not only what Perpend does, but why it was built this way.

- **Clarity over features.** When clarity and convenience conflict, clarity wins. Every dependency must justify its place. Every component has one responsibility.

- **Architecture as communication.** The project is organized into independent layers — Configuration, Plugin Integration, Keymaps, and Documentation. A contributor should be able to browse the repository and develop an intuitive understanding before reading individual files.

---

## Architecture

```
Configuration       →  lua/config/
     ↓
Plugin Integration  →  lua/plugins/
     ↓
Keymaps             →  lua/keymaps/
     ↓
Documentation       →  docs/
```

Each layer depends on the ones beneath it while remaining responsible only for its own concerns. This separation reduces coupling and makes the project easier to maintain as it grows.

---

## Current Status

**Phase I — Foundation** is complete.

- Project architecture and layered organization
- Native LSP with servers on `$PATH` (no Mason)
- Treesitter provider subsystem
- Formatting (conform.nvim) and linting (nvim-lint)
- Diagnostics and Telescope navigation
- Git integration (gitsigns.nvim + vim-fugitive)
- Keymap architecture with ADR documentation
- Perpend Handbook

**Phase II — Developer Productivity** is in progress.

---

## Requirements

### Required

- [Neovim](https://neovim.io) **0.12+**
- [git](https://git-scm.com/) 2.19+
- [tree-sitter-cli](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md) **0.26.1+**
- `tar` and `curl` (used by nvim-treesitter to fetch parsers)
- A C compiler (`cc`, `gcc`, or `clang`) to build Treesitter parsers

### Recommended

- [ripgrep](https://github.com/BurntSushi/ripgrep) — Telescope live grep
- [fd](https://github.com/sharkdp/fd) — Telescope file finder
- [Node.js](https://nodejs.org/) — required by some LSP servers and formatters
- A clipboard provider — `wl-copy`/`xclip`/`xsel` on Linux, `pbcopy` on macOS

### LSP servers (on `$PATH`)

Perpend does not use Mason. Install these manually:

| Language   | Binary                        |
| ---------- | ----------------------------- |
| Lua        | `lua-language-server`         |
| TypeScript | `typescript-language-server`  |
| HTML       | `vscode-html-language-server` |
| CSS        | `vscode-css-language-server`  |

### Formatters and linters (optional)

`stylua`, `prettierd`/`prettier`, `eslint_d`, `markdownlint-cli2`, and `shellcheck`. Perpend skips a missing formatter or linter without crashing.

### Supported platforms

Linux, macOS, and WSL. The installer is a bash script; native Windows is not supported.

---

## Getting Started

### Install (to try)

Run the install script. It validates the environment, backs up your existing config, and installs only the runtime files.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/skorla09/perpend/main/install.sh)
```

Or clone and run manually:

```bash
git clone https://github.com/skorla09/perpend.git
cd perpend
bash install.sh
```

The installer:

- refuses to run without Neovim 0.12+ (set `SKIP_NVIM_CHECK=1` to bypass the check),
- respects `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, and `NVIM_APPNAME`,
- installs to `$XDG_CONFIG_HOME/nvim` by default,
- backs up an existing config directory, file, or symlink to `<path>.bak.<timestamp>`,
- copies `lazy-lock.json` so plugin versions match the repository,
- warns about missing optional tools but does not install them.

Set `SKIP_BACKUP=1` to remove an existing config instead of backing it up.

### Clone (to contribute)

Clone the full repository, including documentation and architecture decision records.

```bash
git clone https://github.com/skorla09/perpend.git ~/.config/nvim
```

`lazy-lock.json` is committed. Update plugins intentionally with `:Lazy update` and commit the lockfile with the related change (`ADR-005`).

### First launch

Open Neovim and let lazy.nvim install the pinned plugins. Then run `:checkhealth` and `:Lazy` to confirm the setup.

---

## Key Workflows

Leader key is `<Space>`. Neovim 0.12's default LSP mappings are preserved.

### Navigation

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Move between windows |
| `<leader>e` | Toggle file explorer (neo-tree) |
| `<leader>E` | Focus file explorer |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fr` | Recent files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fc` | Commands |
| `<leader>fh` | Help tags |
| `<leader>fk` | Keymaps |

### Editing

| Key | Action |
|-----|--------|
| `<leader>h` | Clear search highlight |
| `<leader>w` | Save file |
| `<leader>q` | Close window |
| `<leader>x` | Save and close |
| `<leader>cf` | Format buffer (conform) |
| `<leader>cl` | Lint buffer (nvim-lint) |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `K` | Hover documentation (Neovim default) |
| `gra` | Code action (Neovim default) |
| `gri` | Implementation (Neovim default) |
| `grn` | Rename symbol (Neovim default) |
| `grr` | References (Neovim default) |
| `grt` | Type definition (Neovim default) |
| `<leader>lr` | Rename symbol (alias) |
| `<leader>la` | Code action (alias) |

### Diagnostics

| Key | Action |
|-----|--------|
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>df` | Show line diagnostics |
| `<leader>dl` | Diagnostics list |

### Git

| Key | Action |
|-----|--------|
| `<leader>gS` | Git status (fugitive) |
| `]h` / `[h` | Next / previous hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gu` | Undo stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gR` | Reset buffer |
| `<leader>gb` | Toggle blame |
| `<leader>gd` | Diff this |

---

## Project Structure

```
perpend/
├── init.lua                 # Entry point
├── lazy-lock.json           # Pinned plugin versions (committed)
├── install.sh               # Installation script
├── AGENTS.md                # Agent operating rules
├── lsp/
│   └── lua_ls.lua           # Per-server LSP config
├── lua/
│   ├── config/              # Editor behavior and plugin options
│   ├── keymaps/             # User interactions by workflow
│   └── plugins/             # Plugin declarations and lifecycle
├── docs/
│   ├── adr/                 # Architecture Decision Records
│   └── handbook/            # Engineering companion
└── scripts/
    └── smoke.sh             # Startup smoke test
```

---

## Next Reads

Start with the [Handbook](docs/handbook/README.md) — it tells the full story.

| Chapter | What It Explains |
|---------|------------------|
| [Philosophy](docs/handbook/philosophy.md) | Why Perpend exists |
| [Vision](docs/handbook/vision.md) | Where the project is headed |
| [Principles](docs/handbook/principles.md) | The values that guide every decision |
| [Architecture](docs/handbook/architecture.md) | How the project is organized |
| [Roadmap](docs/handbook/roadmap.md) | Current milestones and future direction |
| [Agent Guide](docs/handbook/agent-guide.md) | How to work within the repository |

---

## License

[MIT](LICENSE)
