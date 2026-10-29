# Proposal: Enable Which-Key Keymaps

## Problem
The which-key plugin is configured but the keymaps are commented out, making it less useful for discoverability.

## Solution
Enable the `<leader>?` keymap to show buffer-local keymaps, making it easier for users to discover available keybindings.

## Benefits
- Better keymap discoverability
- Consistent with other distributions
- Helps new users learn available keymaps

## Alternatives Considered
- Keep which-key as-is (rejected: less useful without keymaps)
- Remove which-key (rejected: useful for discoverability)
- Add more keymaps (rejected: over-engineering for minimal setup)

## Decision
Enable the `<leader>?` keymap to show buffer-local keymaps.

## Date
2026-09-14
