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

**Phase II — Developer Productivity** is complete.

- Git integration (gitsigns.nvim + vim-fugitive)
- Integration patterns documented for terminal, session, debugging, task runners, and testing

**Phase III — User Experience** is next.

---

## Requirements

- [Neovim](https://neovim.io) 0.12+
- [git](https://git-scm.com/)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (for Telescope live grep)
- [fd](https://github.com/sharkdp/fd) (for Telescope file finder)
- A C compiler (for Treesitter parsing — `gcc`, `clang`, or `cc`)
- LSP servers on `$PATH`: `lua-language-server`, `typescript-language-server`, `html-languageserver`, `css-languageserver`

Perpend does not use Mason. All servers are installed manually.

---

## Getting Started

### Install (to try)

Run the install script. It backs up your existing config and installs only the runtime files.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/skorla09/perpend/main/install.sh)
```

Or clone and run manually:

```bash
git clone https://github.com/skorla09/perpend.git
cd perpend
bash install.sh
```

The script installs to `~/.config/nvim/`. Your existing config is backed up to `~/.config/nvim.bak.<timestamp>`.

### Clone (to contribute)

Clone the full repository, including documentation and architecture decision records.

```bash
git clone https://github.com/skorla09/perpend.git ~/.config/nvim
```

### LSP Servers

Perpend does not use Mason. LSP servers must be installed manually on your `$PATH`.

---

## Key Workflows

Leader key is `<Space>`.

### Navigation

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Move between windows |
| `<leader>e` | Toggle file explorer (neo-tree) |
| `<leader>f` | Find files (Telescope) |
| `<leader>fg` | Live grep (Telescope) |

### Editing

| Key | Action |
|-----|--------|
| `<leader>w` | Save file |
| `<leader>q` | Close window |
| `<leader>x` | Save and close |
| `<leader>cf` | Format buffer (conform) |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover documentation |
| `<leader>lr` | Rename symbol |
| `<leader>la` | Code action |

### Diagnostics

| Key | Action |
|-----|--------|
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>df` | Show line diagnostics |

### Git

| Key | Action |
|-----|--------|
| `<leader>gS` | Git status (fugitive) |
| `]h` / `[h` | Next / previous hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gb` | Toggle blame |

---

## Project Structure

```
perpend/
├── init.lua                 # Entry point
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
