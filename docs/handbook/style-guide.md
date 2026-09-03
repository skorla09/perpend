# STYLE GUIDE

> **Establish the reference.**
> **Build with intention.**
> **Leave the workshop better than you found it.**

This chapter defines the coding and writing conventions of Perpend.

A style guide exists so that the project remains predictable. Consistency reduces cognitive load, makes reviews faster, and helps new contributors understand where things belong without asking. These conventions are prescriptive for new work; existing files are migrated incrementally rather than rewritten wholesale.

---

# LUA CONVENTIONS

## 1. Indentation

- Use tabs for indentation.
- Tab width is two spaces (`shiftwidth = 2`, matching `config/options.lua`).

## 2. Naming

- Use `snake_case` for files, functions, and variables.
- Use kebab-case for plugin declaration files in `lua/plugins/`, matching the plugin owner/repository name (e.g. `smear_cursor` -> `smear-cursor.nvim` when consistency requires it; existing names remain as-is until migrated).
- Prefer short, intention-revealing names over abbreviations.

## 3. Local aliases

- Assign frequently used API tables to a local once at the top of a file:

```lua
local map = vim.keymap.set
local opt = vim.opt
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
```

This keeps the body of the file readable and consistent.

## 4. Quotes

- Use double quotes for Lua strings.

## 5. Comments

- Write comments in English.
- A comment explains why a decision was made, not what the code does.
- Use full sentences with a trailing period and an initial capital letter.
- The word "Clipbiard" and all other typos in existing comments are corrected on touch.

## 6. Keymaps

- Every mapping that uses `vim.keymap.set` must include a `desc` (ADR-001).
- `desc` values use sentence case: capitalize the first letter and the first letter of the action, e.g. `"Go to definition"`, `"Save file"`, `"Git status"`.
- Pattern for a keymap with a callback:

```lua
map("n", "<leader>cl", function()
	pcall(require("lint").try_lint)
	vim.notify("Lint check complete", vim.log.levels.INFO)
end, { desc = "Lint buffer" })
```

## 7. Return tables from config files

- Config files in `lua/config/` return a plain table consumed by Lazy via `opts` or `config()`.
- Do not call `setup()` in plugin declaration files unless imperative initialization is required (ADR-002).

---

# WRITING CONVENTIONS

## 8. Handbook communication

- New chapters follow the commentary style established in `philosophy.md`, `principles.md`, and `architecture.md`.
- A chapter opens with the workshop inscription:

```
> **Establish the reference.**
> **Build with intention.**
> **Leave the workshop better than you found it.**
```

- Statements are separated by blank lines; paragraphs are short and direct.
- The reader must be able to understand *why* before *what*.

## 9. ADR format

- ADRs follow the structure defined by the existing records in `docs/adr/`:
  - Status
  - Context
  - Problem
  - Decision
  - Rationale (Why)
  - Alternatives considered
  - Consequences
  - Related Principles
  - Review Notes
- ADRs record *decisions*; Research Notes record *knowledge* (`agent-guide.md` sections 3 and 10).

## 10. Documentation references

- Reference project files by their repository path (`docs/adr/004-...md`, `lua/config/lsp.lua`).
- Reference Handbook chapters by title and mention the file only when it helps the reader navigate.

## 11. Scope of this guide

The style guide is a contract for consistency, not a barrier. When an established convention conflicts with a genuinely better approach, discuss it before changing the guide.