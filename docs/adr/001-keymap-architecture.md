# ADR-001: KEYMAP ARCHITECTURE

## Status

Accepted

## Context

Initially, keymaps were defined close to the plugins that used them, resulting in inconsistent organization and duplicated namespaces.

## Problem

How should keymaps be organized so that responsibilities remain clear, plugin loading stays predictable, and users can easily discover and maintain mappings?

## Decision

Perpend separates keymaps according to ownership.

- Global editor interactions are defined in the keymaps/ directory and loaded during startup.
- Plugin-specific mappings are returned to Lazy.nvim using each plugin's keys specification.
- Global keymaps are organized by workflow or responsibility rather than by plugin.
- "Every mapping should include a descriptive desc to improve discoverability and Which-key integration".

## Rationale (Why)

Separating global interactions from plugin-owned interactions allows each subsystem to manage its own lifecycle. Global mappings are always available, while plugin mappings are only registered when their corresponding plugin is loaded. This keeps startup behavior predictable, avoids unnecessary mappings, and makes ownership immediately apparent.

## Alternatives considered

1. Keep all keymaps in one file

   Rejected because it doesn't scale and makes ownership unclear.

2. Define every keymap inside each plugin

   Rejected because global editor interactions become fragmented across plugin definitions.

3. Load every keymap through keymaps/init.lua

   Partially adopted.

   Global mappings follow this model, but plugin-owned mappings remain with their plugin to preserve lazy-loading behavior.

## Consequences

### Benefits

- Clear ownership.
- Consistent interaction model.
- Reduced namespace collisions.
- Better Which-key integration.
- Easier onboarding for contributors.

### Trade-off

- Requires understanding the distinction between global and plugin-owned mappings.
- Some keymaps are intentionally defined in different places.

## Related Principles

- Separation of Concerns
- Single Responsibility
- Discoverability

## Review Notes

This decision may be revisited if Neovim or Lazy.nvim introduce architectural changes that significantly alter keymap ownership or loading behavior.
