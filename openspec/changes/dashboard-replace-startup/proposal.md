## Why

startup.nvim is installed with minimal configuration (defaults only). It has lower community adoption (502 stars) compared to alternatives, a restrictive GPL license, and fewer features. snacks.nvim (8,000+ stars) is maintained by folke (lazy.nvim author) and provides a modern, declarative dashboard with multi-pane layouts, session auto-detection, and built-in picker integration.

## What Changes

- Replace startup.nvim with snacks.nvim dashboard module
- Configure dashboard with Perpend branding (ASCII art header)
- Add quick action buttons (Find File, New File, Recent Files, Find Text, Find Buffer, Config, Lazy, Quit)
- Integrate with existing Telescope keymaps
- Display startup stats (plugins loaded, time)

## Capabilities

### New Capabilities

- `snacks-dashboard`: Modern dashboard with declarative configuration
- `startup-stats`: Display lazy.nvim plugin count and startup time

### Modified Capabilities

None — no existing specs to modify.

## Impact

- **Removed dependency**: startup.nvim (plus telescope-file-browser dependency)
- **Added dependency**: snacks.nvim (single plugin, multiple modules)
- **File changes**: Create `lua/plugins/dashboard.lua`, comment out `lua/plugins/startup.lua`
- **Keymap changes**: Dashboard keymaps are buffer-local (no global conflicts)
