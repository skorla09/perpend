# ADR-004: NATIVE LSP AND NO MASON

## Status

Accepted

## Context

Language servers and editor tooling are commonly installed and managed through tooling such as mason.nvim, which provides a unified interface for downloading, updating, and configuring LSP servers, linters, and formatters.

During the design of Perpend, the value of that convenience was weighed against the architectural principles of clarity, minimal dependencies, and explicit responsibility. Installing servers through Mason adds a dependency, an abstraction layer, and a runtime step between the configuration and the tools it uses.

At the same time, Neovim 0.12 introduced mature native LSP configuration APIs (`vim.lsp.enable()` and `vim.lsp.config()`) that reduce the need for the `nvim-lspconfig` setup pattern.

## Problem

How should LSP servers be installed and configured so that Perpend remains simple, dependency-aware, and aligned with modern Neovim's native LSP capabilities?

## Decision

Perpend manages LSP servers on `$PATH` and configures them using Neovim's native LSP API.

- LSP servers are installed manually on `$PATH`.
- Servers are enabled with `vim.lsp.enable()` in `lua/config/lsp.lua`.
- Per-server configuration lives in `lsp/<server>.lua` and is consumed natively via `vim.lsp.config()`.
- `mason.nvim` and `mason-lspconfig.nvim` are never used.
- `nvim-lspconfig` is installed (`lazy = false`) only for utility commands such as `:LspInfo`; its setup functions are not used.

## Rationale (Why)

- Dependency minimization: every dependency must justify its place, and tool-managed installation adds layers without owning real behavior.
- Clarity: LSP server configuration is explicit and visible in the repository rather than hidden behind a manager.
- Modern Neovim alignment: native `vim.lsp.enable()` and `vim.lsp.config()` provide what `nvim-lspconfig`'s setup pattern previously supplied.
- Predictability: servers on `$PATH` behave like any other system tool and are free from plugin-managed version drift.

## Alternatives considered

1. Adopt mason.nvim for LSP installation and management
   Rejected - Adds an abstraction layer and dependency without a meaningful gain in clarity; conflicts with the principle that every dependency must justify its place.

2. Keep full `nvim-lspconfig` setup pattern and remove native enabling
   Rejected - `require("lspconfig").X.setup()` duplicates capabilities the native API now provides and obscures per-server configuration.

3. No LSP configuration at all
   Rejected - LSP is a core part of the Phase I foundation; omitting it would leave Perpend without its primary editing intelligence.

## Consequences

### Benefits

- Fewer dependencies.
- Explicit, greppable LSP configuration.
- Direct use of modern Neovim native APIs.
- No version drift between Mason and the tools on `$PATH`.

### Trade-off

- Users must install and maintain servers manually on `$PATH`.
- Per-server files in `lsp/` grow as more servers are added.
- Some community configurations and documentation assume Mason; adapting them requires effort.

## Related Principles

- Every Dependency Must Justify Its Place
- Declarative Configuration
- Clarity over Cleverness
- Simplicity

## Review Notes

This decision should be revisited if Neovim changes its native LSP management APIs, or if manual server management becomes an unsustainable maintenance burden.

