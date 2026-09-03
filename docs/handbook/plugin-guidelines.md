# PLUGIN GUIDELINES

> **Establish the reference.**
> **Build with intention.**
> **Leave the workshop better than you found it.**

This chapter defines how plugins are evaluated, integrated, and maintained in Perpend.

Plugins are the primary extension mechanism of Perpend. Because every dependency increases maintenance responsibility, each plugin must earn its place. These guidelines ensure that plugin integration is deliberate, documented, and consistent with the project's architecture.

---

# 1. WHEN TO ADD A PLUGIN

A plugin is added when it solves a real problem that Neovim does not already solve acceptably.

Before adding a plugin, ask:

- Does Neovim core already provide this capability?
- Is a small hand-written implementation simpler than a dependency?
- Does the capability belong to the current phase of the roadmap?
- Does the plugin align with Perpend's principles and architecture?

Every plugin must justify its place (Principle: Every Dependency Must Justify Its Place). A popular plugin is not automatically a justified plugin.

---

# 2. THE EVALUATION PROCESS

Follow the research protocol described in `agent-guide.md` (section 3) before adopting a plugin.

At minimum, verify:

- the plugin's current official repository,
- the latest relevant version,
- the current official configuration guidance,
- relevant breaking changes and deprecations,
- compatibility with the pinned Neovim version and existing plugins,
- license and maintenance status.

Record significant findings in `docs/handbook/research-notes.md` before or while integrating. Do not rely on remembered configuration snippets.

---

# 3. THE 3-FILE PATTERN

Every plugin follows the **3-file pattern, applied as needed**:

| File | Purpose | Required? |
| ---- | ------- | --------- |
| `lua/plugins/<name>.lua` | Declaration — source, version, deps, events, opts, config, keys | Always |
| `lua/config/<name>.lua` | Setup options — returned table consumed by `opts` or `config()` | Only if the plugin needs options |
| `lua/keymaps/<name>.lua` | Key mappings — returned table for `keys`, or function for `on_attach` | Only if the plugin has keymaps |

Examples:

- `mini.pairs` — no keymaps file (bindings handled internally) and no config file (defaults used).
- `startup.nvim` — no config file (built-in dashboard theme used).
- `gitsigns.nvim` — config file and an `on_attach` keymaps function.

Create a config or keymaps file only when the plugin actually needs it. Do not create empty files.

---

# 4. CONFIGURATION STYLE

Follow `ADR-002`:

1. Prefer `opts` whenever the plugin exposes a `setup()` function compatible with Lazy.
2. Use `config()` only for imperative initialization (autocommands, user commands, runtime init, subsystem integration, non-declarative APIs).
3. Keep declarations responsible only for lifecycle, dependencies, and lazy-loading.

Every keymap, whether global or plugin-owned, requires a descriptive `desc` (ADR-001).

---

# 5. LAZY-LOADING

Prefer lazy-loading to keep startup fast, but load a plugin eagerly when correctness requires it (`lazy = false`):

- `gitsigns.nvim` must load at startup to render signs.
- `nvim-lspconfig` must load at startup for utility commands.
- Colorschemes load eagerly with high priority.

Use event, command, key, and filetype triggers only when they do not break required behavior. See the notes in `AGENTS.md` for edge cases such as `blink.cmp`'s internal keybinding.

---

# 6. DEAD CONFIG CONVENTION

Disabled or experimental configuration is left in place as commented-out lines with an explanatory note, rather than deleted silently:

- `config/telescope.lua` — setup call and fzf extension commented out.
- `config/neo-tree.lua` — `opts` line commented out.
- `plugins/which-key.lua` — `keys = require("keymaps.which-key")` commented out ("PROBABLY NOT NEEDED").

This preserves context, documents rejections near the decision, and makes re-enabling intentional and cheap.

---

# 7. DEPENDENCIES

A plugin may depend on others only when the dependency is real and justified:

- `lsp-file-operations.nvim` depends on `neo-tree.nvim` for correct loading order.
- `startup.nvim` depends on `telescope.nvim` and `plenary.nvim`.

List dependencies in the plugin declaration. Never add a dependency merely to bundle convenience.

---

# 8. REMOVING A PLUGIN

Removing a plugin is an architectural decision:

- Identify what responsibility the plugin was covering.
- Confirm Neovim core or an existing plugin provides an acceptable replacement (e.g. `vim-oscyank` removed because Neovim 0.10+ has native OSC52).
- Update declarations, config, and keymaps.
- Update the affected documentation and, when the decision is significant, record an ADR.

A rejection is knowledge: preserve the reason.

---

# 9. THE DECISION TEST

Before finalizing any plugin change, apply the decision test (`agent-guide.md` section 16): Does it solve a real problem? Is it simpler than alternatives? Does it have a clear responsibility? Does every dependency justify its place? Can the decision be explained? Does it align with the current phase?

If several answers are unclear, investigate before implementing.