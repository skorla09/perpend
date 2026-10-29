# Proposal: UI Consistency

## Problem
Perpend has multiple colorschemes available but no easy way to switch between them. The current colorscheme is hardcoded in the kanagawa config.

## Solution
Add a colorscheme switcher keymap and ensure all colorschemes are properly configured for consistency.

## Benefits
- Easy colorscheme switching for users
- Consistent colorscheme configuration across all themes
- Better user experience with visual feedback

## Alternatives Considered
- Keep hardcoded colorscheme (rejected: inflexible)
- Use a colorscheme picker plugin (rejected: over-engineering)
- Add multiple colorscheme configs (rejected: maintenance burden)

## Decision
Add `<leader>uc` keymap to cycle through available colorschemes and ensure all colorschemes have consistent configuration.

## Date
2026-09-14
