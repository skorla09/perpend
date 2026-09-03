# MILESTONES

> **Establish the reference.**
> **Build with intention.**
> **Leave the workshop better than you found it.**

This chapter records the lessons learned throughout Perpend's evolution.

A milestone is not merely a feature that ships. It is a moment of understanding — a point where the project learned something about its architecture, its tools, or the discipline of building software. This chapter preserves those lessons so that future contributors do not need to repeat the same journey.

These entries reflect what the repository's artifacts verify. The project does not invent history; it records what is evidence-backed.

---

# PHASE I MILESTONES

## M-001: Separation of keymaps (ADR-001)

Initially, keymaps were defined close to the plugins that used them. This scattered global editor interactions across plugin definitions, duplicated namespaces, and made ownership unclear.

**Lesson:** Mappings should be organized by ownership and responsibility, not by proximity to a plugin. Global interactions belong to the keymap layer; plugin-owned mappings stay with the plugin to preserve lazy loading. Every mapping earns a `desc`.

_Verified by:_ `docs/adr/001-keymap-architecture.md`, `lua/keymaps/`.

---

## M-002: Declarative plugin configuration (ADR-002)

Plugins were once configured using whatever example appeared in their documentation or a community config — some declarative, some imperative. The specs became hard to compare and maintain.

**Lesson:** Establish a configuration hierarchy before the plugin collection grows. Prefer `opts` whenever the plugin exposes a compatible `setup()`, and keep declarations responsible only for lifecycle, dependencies, and lazy loading. Imperative `config()` is reserved for what cannot be expressed declaratively.

_Verified by:_ `docs/adr/002-plugin-configuration.md`, `lua/plugins/`.

---

## M-003: Treesitter is a provider, not a feature collection (ADR-003)

Treesitter is often presented as one feature responsible for syntax highlighting, indentation, folding, and text objects. Treating it as the owner of every syntax-related behavior turns its configuration into an unowned pile of options.

**Lesson:** Separate providers from consumers. Treesitter owns parsers and queries; the features built on the syntax tree belong to their own subsystems. This separation mirrors modern Neovim and keeps configuration clear.

_Verified by:_ `docs/adr/003-treesitter-subsystem.md`, `lua/config/treesitter.lua`, `lua/plugins/treesitter*`.

---

## M-004: Native LSP without Mason (ADR-004)

LSP tooling is commonly delivered through a manager that installs and updates servers on the user's behalf. That convenience carries a dependency and an abstraction layer.

**Lesson:** When Neovim core matures to own a capability, prefer the native path. Neovim 0.12's `vim.lsp.enable()` and `vim.lsp.config()` made server configuration explicit and greppable, removing the need for both Mason and the `lspconfig.setup()` pattern. Servers on `$PATH` behave like any other tool.

_Verified by:_ `docs/adr/004-native-lsp-no-mason.md`, `lua/config/lsp.lua`, `lsp/lua_ls.lua`, `AGENTS.md`.

---

## M-005: Remove what Neovim core now provides

When a tool's only justification was a gap Neovim has since closed, keeping it adds maintenance without value.

**Lesson:** Revisiting the dependency list against the current Neovim version is a first-class maintenance activity. `vim-oscyank` was removed because Neovim 0.10+ ships native OSC52 support.

_Verified by:_ `AGENTS.md` (Important Conventions).

---

## M-006: Dead config is knowledge

Deleting disabled or experimental configuration loses the context of a decision. Leaving it as commented-out lines with a note makes rejection visible and re-enabling intentional.

**Lesson:** When an option is disabled or deferred, keep it in place with an explanatory comment. The decision's history becomes part of the codebase.

_Verified by:_ `config/telescope.lua`, `config/neo-tree.lua`, `plugins/which-key.lua`, `plugin-guidelines.md`.

---

## M-007: The 3-file pattern grows as needed

Not every plugin needs three files. Requiring a config or keymaps file for every plugin adds structure without purpose.

**Lesson:** Apply the 3-file pattern only when the plugin actually needs it. `mini.pairs` needs no config (defaults) and no keymaps (bindings handled internally); `startup.nvim` needs no config (built-in theme). Structure should follow need, not ceremony.

_Verified by:_ `lua/plugins/mini-pairs.lua`, `lua/plugins/startup.lua`, `AGENTS.md` (Architecture section).

---

## M-008: Research must be recorded

Perpend's engineering regularly investigates plugins, APIs, and version changes. When that research stays in an agent's context or a contributor's memory, the knowledge is lost.

**Lesson:** Record significant findings in `handbook/research-notes.md` before or while integrating a technology. Research preserves what Perpend learned; ADRs preserve what Perpend decided. The two are not interchangeable.

_Verified by:_ `docs/adr/`, `docs/handbook/research-notes.md`, `agent-guide.md` (section 3).

---

# SUSTAINING THIS CHAPTER

New milestones should be appended with a new `M-NNN` number and must point to the artifact that verifies the lesson. A milestone without evidence is a claim, not a lesson.

The moment a phase is declared complete, the lessons that emerged during that phase belong here — before the details fade from the workshop.