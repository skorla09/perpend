# ADR-003: TREESITTER SUBSYSTEM ARCHITECTURE

## Status

Accepted

## Context

Treesitter is frequently presented as a single feature responsible for syntax highlighting, indentation, folding, text objects, and other editor capabilities.

During the design of Perpend, it became clear that modern Neovim separates these responsibilities across multiple layers. Treesitter provides syntactic information, while Neovim core and other plugins consume that information to implement editor behavior.

Without recognizing these boundaries, configuration tends to accumulate unrelated responsibilities inside a single Treesitter configuration.

## Problem

How should Treesitter be integrated into Perpend so that responsibilities remain clearly separated between syntax providers and feature consumers?

## Decision

Perpend treats Treesitter as a provider subsystem.

Treesitter owns:

- parser installation
- parser management
- parser configuration
- syntax queries

Treesitter does not own:

- syntax highlighting
- code folding
- indentation behavior
- text objects
- autotag
- rainbow delimiters
- context windows
- any feature built on top of the syntax tree

Those are consumer responsibilities.

## Rationale (Why)

Separating providers from consumers prevents subsystem configurations from becoming feature collections.

Each subsystem remains responsible only for the capabilities it originates, while user-facing behavior is configured by the subsystem that owns that behavior.

This approach improves maintainability, reduces coupling, and mirrors the architecture of modern Neovim.

## Alternatives considered

1. Treat treesitter as the owner of every syntax-related feature
   Rejected - It mixes parser management with editor behavior and creates a configuration that grows without clear ownership
2. Configure each plugin independently without defining subsystem boundaries
   Rejected - It avoids centralization but loses architectural relationship between providers and consumers
3. Adopt Neovim defaults without documenting subsystem ownership
   Rejected - While functional, it doesn't provide contributors with a shared mental model for future decisions

## Consequences

### Benefits

- Clear subsystem boundaries.
- Easier maintenance.
- Better scalability.
- Easier onboarding.
- Cleaner future integrations.
- Reusable provider/consumer model.

### Trade-off

- Requires contributors to understand subsystem ownership.
- May introduce additional configuration files as the project grows.

## Related Principles

- Separation of Concerns
- Provider vs Consumer
- Single Responsibility

## Review Notes

This decision should be revisited if Neovim fundamentally changes the ownership of syntax parsing or if Treesitter becomes part of Neovim core in a way that alters subsystem responsibilities.
