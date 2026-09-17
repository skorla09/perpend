# Design: UI Consistency

## Current State
- kanagawa.nvim is the active colorscheme (dragon theme)
- catppuccin.nvim and tokyonight.nvim are available but not configured
- No colorscheme switching mechanism

## Solution Components

### 1. Colorscheme Configuration
- Ensure all colorschemes have consistent configuration
- Add `lazy = false` and `priority = 1000` for all colorschemes
- Configure each with appropriate theme settings

### 2. Colorscheme Switcher
- Create `<leader>uc` keymap to cycle through colorschemes
- Store available colorschemes in a table
- Provide visual feedback when switching

### 3. Colorscheme Keymaps
- `<leader>uc` - Cycle through colorschemes
- `<leader>us` - Show current colorscheme

## Implementation Details

### Plugin Updates
- Update `lua/plugins/catppuccin.lua` with proper config
- Update `lua/plugins/tokyonight.lua` with proper config
- Keep kanagawa.nvim as default

### Keymap Implementation
- Create `lua/keymaps/ui.lua` for UI-related keymaps
- Add colorscheme cycling function
- Add visual notification on switch

### Config Updates
- Create `lua/config/colorschemes.lua` with available themes
- Store current colorscheme in vim.g for persistence

## Testing Strategy
1. Verify all colorschemes load correctly
2. Test colorscheme switching with `<leader>uc`
3. Verify visual feedback on switch
4. Check consistency across all themes
