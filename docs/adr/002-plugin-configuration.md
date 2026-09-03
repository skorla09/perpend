# ADR-002: PLUGIN CONFIGURATION ARCHITECTURE

## Status

Accepted

## Context

As Perpend grew, plugins were configured using different approaches depending on examples found in documentation or community configurations.

Some plugins used declarative options through Lazy.nvim's opts field, while others relied on imperative config() functions.

Without a consistent approach, plugin specifications became harder to read, compare, and maintain.

## Problem

How should plugins be configured so that specifications remain consistent, declarative whenever possible, and aligned with modern Lazy.nvim conventions?

## Decision

Perpend follows the following hierarchy when configuring plugins:

1. Prefer opts whenever the plugin exposes a setup() function compatible with Lazy.nvim.
2. Use config() only when imperative initialization is required, such as:
   - creating autocommands
   - defining user commands
   - runtime initialization
   - integrating multiple subsystems
   - calling APIs that cannot be expressed declaratively
3. Plugin specifications should remain responsible only for:
   - lifecycle
   - dependencies
   - lazy-loading conditions

Configuration data should be delegated to the `config/` directory whenever practical

## Rationale (Why)

- Separating plugin lifecycle from plugin behavior makes plugin specifications easier to read and maintain.
- Declarative configuration emphasizes what should be configured instead of how to configure it.
- Using opts whenever possible also aligns Perpend with Lazy.nvim's recommended practices and reduces unnecessary boilerplate.
- Imperative configuration remains available for situations where declarative configuration is insufficient.

## Alternatives considered

1. Configure every plugin using config()
   Rejected - Although universally applicable, this approach introduces unnecessary imperative code and obscures plugin intent

2. Always use opts
   Rejected - Some plugins require runtime initialization that cannot be represented declaratively

3. Allow each plugin to choose its own style
   Rejected - While flexible, inconsistent plugin specifications reduce readability and increase maintenance costs

## Consequences

### Benefits

- Consistent plugin specifications.
- Reduced boilerplate.
- Better readability.
- Easier onboarding.
- Alignment with Lazy.nvim's architecture.
- Cleaner separation between lifecycle and configuration.

## Trade-off

- Contributors must understand when declarative configuration is appropriate.
- Some plugins naturally require a hybrid approach.

## Related Principles

- Declarative Configuration
- Convention over Configuration
- Separation of Concerns
- Simplicity

## Review Notes

This decision should be revisited if Lazy.nvim significantly changes its plugin specification API or if Neovim introduces new native plugin configuration mechanisms
