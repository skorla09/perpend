## Context

Perpend currently uses startup.nvim with default configuration. The project follows lazy.nvim plugin management with a 3-file pattern (plugin declaration, config file, keymaps). Telescope is the primary fuzzy finder with keymaps under `<leader>f`.

## Goals / Non-Goals

**Goals:**
- Replace startup.nvim with snacks.nvim dashboard
- Preserve existing Telescope keymaps (no conflicts)
- Add Perpend ASCII art branding
- Show startup stats (plugin count, load time)
- Follow 3-file pattern and lazy.nvim conventions

**Non-Goals:**
- Replace Telescope with snacks.picker (keep Telescope as primary picker)
- Add session persistence (documented as optional in integration-patterns.md)
- Add multi-pane layout (keep simple for now)

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Dashboard plugin | **snacks.nvim** | 8k+ stars, folke maintainer, declarative config, part of cohesive ecosystem |
| Picker integration | **Telescope (fallback)** | snacks.nvim auto-detects Telescope; preserve existing keymaps |
| Header style | **ASCII art** | Consistent with Perpend's minimalist aesthetic |
| Button actions | **Telescope commands** | Maintain existing workflows, no new keymaps to learn |
| Session restore | **Omit** | Intentionally excluded per minimalist philosophy (M-009) |

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| snacks.nvim is a large plugin | Only enable dashboard module; other modules disabled by default |
| Dashboard keymaps might confuse users | Keymaps are buffer-local; documented in dashboard footer |
| Removing startup.nvim loses its features | startup.nvim had no custom features; all defaults |
